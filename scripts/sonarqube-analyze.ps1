# Quick SonarQube Analysis Script
# Generates reports and runs SonarQube analysis

param(
    [Parameter(Mandatory=$false)]
    [string]$SonarHost = "http://localhost:9000",

    [Parameter(Mandatory=$false)]
    [string]$SonarToken = ""
)

Write-Host "=== Running SonarQube Analysis ===" -ForegroundColor Cyan
Write-Host ""

# Step 1: Flutter analyze
Write-Host "Step 1: Running Flutter analysis..." -ForegroundColor Yellow
flutter analyze lib/
if ($LASTEXITCODE -ne 0) {
    Write-Host "Warning: Flutter analysis found issues" -ForegroundColor Yellow
}
Write-Host ""

# Step 2: Dart analysis (JSON)
Write-Host "Step 2: Generating Dart analysis report..." -ForegroundColor Yellow
dart analyze lib/ --format=json > analysis.json
Write-Host "Analysis report saved to: analysis.json" -ForegroundColor Green

# Convert Dart analysis to SonarQube Generic Issue Report format
Write-Host "Step 2b: Converting Dart analysis to SonarQube format..." -ForegroundColor Yellow
$dartAnalysis = Get-Content analysis.json | ConvertFrom-Json
$sonarReport = @{
    rules = @()
    issues = @()
}

# Create a set of unique rule IDs
$ruleIds = @{}

foreach ($diagnostic in $dartAnalysis.diagnostics) {
    $file = $diagnostic.location.file
    $line = $diagnostic.location.range.start.line + 1  # SonarQube uses 1-based line numbers
    $code = $diagnostic.code

    # Add rule if not already added
    if (-not $ruleIds.ContainsKey($code)) {
        $ruleIds[$code] = $true
        $rule = @{
            id = $code
            name = $code
            engineId = "dart-analyzer"
            description = $diagnostic.problemMessage
            type = "CODE_SMELL"
            severity = "MINOR"
            impacts = @(
                @{
                    softwareQuality = "MAINTAINABILITY"
                    severity = "LOW"
                }
            )
        }
        $sonarReport.rules += $rule
    }

    # Map severity: INFO -> MINOR, HINT -> MINOR, WARNING -> MAJOR, ERROR -> CRITICAL
    $severity = switch ($diagnostic.severity) {
        "INFO" { "MINOR" }
        "HINT" { "MINOR" }
        "WARNING" { "MAJOR" }
        "ERROR" { "CRITICAL" }
        default { "MINOR" }
    }

    # Convert absolute path to relative path
    $baseDir = Get-Location
    $relativePath = $file -replace [regex]::Escape("$baseDir\"), ""

    $issue = @{
        engineId = "dart-analyzer"
        ruleId = $code
        primaryLocation = @{
            message = $diagnostic.problemMessage
            filePath = $relativePath
            textRange = @{
                startLine = $line
                endLine = $line
            }
        }
    }

    $sonarReport.issues += $issue
}

$sonarReport | ConvertTo-Json -Depth 10 | Set-Content sonar-issues.json
Write-Host "SonarQube issues report saved to: sonar-issues.json" -ForegroundColor Green
Write-Host ""

# Step 3: Coverage report
Write-Host "Step 3: Generating coverage report..." -ForegroundColor Yellow
flutter test --coverage 2>&1 | Out-Null
if (Test-Path "coverage/lcov.info") {
    Write-Host "Coverage report saved to: coverage/lcov.info" -ForegroundColor Green
}
else {
    Write-Host "Warning: Coverage report not generated" -ForegroundColor Yellow
}
Write-Host ""

# Step 4: SonarQube Scanner
Write-Host "Step 4: Running SonarQube scanner..." -ForegroundColor Yellow
$sonarScannerPath = (Get-Command sonar-scanner -ErrorAction SilentlyContinue).Path

if (-not $sonarScannerPath) {
    Write-Host "Error: sonar-scanner not found in PATH" -ForegroundColor Red
    Write-Host "Please install SonarScanner first: https://docs.sonarqube.org/latest/analyzing-source-code/scanners/sonarscanner/" -ForegroundColor White
    exit 1
}

# Build base command arguments
$cmdArgs = @(
    "-D", "sonar.projectKey=vietnam-map-flutter",
    "-D", "sonar.sources=lib",
    "-D", "sonar.tests=test",
    "-D", "sonar.exclusions=**/*.g.dart,**/*.freezed.dart,**/generated/**,build/**,.dart_tool/**",
    "-D", "sonar.host.url=$SonarHost"
)

# Add token if provided
if ($SonarToken) {
    $cmdArgs += "-D", "sonar.login=$SonarToken"
} else {
    Write-Host "Warning: No authentication token provided. Analysis may fail if SonarQube requires authentication." -ForegroundColor Yellow
}

# Execute sonar-scanner with arguments
& sonar-scanner $cmdArgs

Write-Host ""
Write-Host "=== Analysis Complete ===" -ForegroundColor Green
Write-Host "View results at: $SonarHost/dashboard?id=vietnam-map-flutter" -ForegroundColor Cyan

