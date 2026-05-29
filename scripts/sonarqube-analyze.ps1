# Quick SonarQube Analysis Script
# Generates reports and runs SonarQube analysis

param(
    [Parameter(Mandatory=$false)]
    [string]$SonarHost = "http://localhost:9000",

    [Parameter(Mandatory=$false)]
    [string]$SonarToken = ""
)

Write-Output "=== Running SonarQube Analysis ==="
Write-Output ""

# Step 1: Flutter analyze
Write-Output "Step 1: Running Flutter analysis..."
flutter analyze lib/
if ($LASTEXITCODE -ne 0) {
    Write-Output "Warning: Flutter analysis found issues"
}
Write-Output ""

# Step 2: Dart analysis (JSON)
Write-Output "Step 2: Generating Dart analysis report..."
dart analyze lib/ --format=json > analysis.json
Write-Output "Analysis report saved to: analysis.json"

# Convert Dart analysis to SonarQube Generic Issue Report format
Write-Output "Step 2b: Converting Dart analysis to SonarQube format..."
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
Write-Output "SonarQube issues report saved to: sonar-issues.json"
Write-Output ""

# Step 3: Coverage report
Write-Output "Step 3: Generating coverage report..."
flutter test --coverage 2>&1 | Out-Null
if (Test-Path "coverage/lcov.info") {
    Write-Output "Coverage report saved to: coverage/lcov.info"
}
else {
    Write-Output "Warning: Coverage report not generated"
}
Write-Output ""

# Step 4: SonarQube Scanner
Write-Output "Step 4: Running SonarQube scanner..."
$sonarScannerPath = (Get-Command Sonar-Scanner -ErrorAction SilentlyContinue).Path

if (-not $sonarScannerPath) {
    Write-Output "Error: SonarScanner not found in PATH"
    Write-Output "Please install SonarScanner first: https://docs.sonarqube.org/latest/analyzing-source-code/scanners/sonarscanner/"
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
    Write-Output "Warning: No authentication token provided. Analysis may fail if SonarQube requires authentication."
}

# Execute SonarScanner with arguments
& Sonar-Scanner $cmdArgs

Write-Output ""
Write-Output "=== Analysis Complete ==="
Write-Output "View results at: $SonarHost/dashboard?id=vietnam-map-flutter"

