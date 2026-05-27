# Quick SonarQube Analysis Script
# Generates reports and runs SonarQube analysis

param(
    [Parameter(Mandatory=$false)]
    [string]$SonarHost = "http://localhost:9000",

    [Parameter(Mandatory=$false)]
    [string]$SonarToken = "admin"
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

sonar-scanner `
    -Dsonar.projectKey=vietnam-map-flutter `
    -Dsonar.sources=lib `
    -Dsonar.tests=test `
    -Dsonar.exclusions="**/*.g.dart,**/*.freezed.dart,**/generated/**,build/**,.dart_tool/**" `
    -Dsonar.host.url=$SonarHost `
    -Dsonar.login=$SonarToken

Write-Host ""
Write-Host "=== Analysis Complete ===" -ForegroundColor Green
Write-Host "View results at: $SonarHost/dashboard?id=vietnam-map-flutter" -ForegroundColor Cyan

