# SonarQube Setup Script for Vietnam Map Flutter Project
# This script helps set up and run SonarQube analysis

param(
    [Parameter(Mandatory=$false)]
    [string]$SonarHost = "http://localhost:9000",

    [Parameter(Mandatory=$false)]
    [string]$SonarToken = "admin",

    [Parameter(Mandatory=$false)]
    [string]$SonarVersion = "community"
)

Write-Host "=== SonarQube Integration Setup ===" -ForegroundColor Cyan

# Function to check if Docker is installed
function Test-Docker {
    try {
        $null = docker --version
        return $true
    }
    catch {
        return $false
    }
}

# Function to start SonarQube with Docker
function Start-SonarQubeDocker {
    Write-Host "Starting SonarQube Community Edition with Docker..." -ForegroundColor Yellow

    if (-not (Test-Docker)) {
        Write-Host "Docker is not installed. Please install Docker first." -ForegroundColor Red
        Write-Host "Download from: https://www.docker.com/products/docker-desktop" -ForegroundColor White
        return $false
    }

    # Check if container already running
    $existingContainer = docker ps -a --filter "name=sonarqube" --format "{{.Names}}"

    if ($existingContainer) {
        Write-Host "SonarQube container already exists. Starting it..." -ForegroundColor Yellow
        docker start sonarqube
    }
    else {
        Write-Host "Creating and starting new SonarQube container..." -ForegroundColor Yellow
        docker run -d `
            --name sonarqube `
            -p 9000:9000 `
            -p 9092:9092 `
            -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLED=true `
            sonarqube:community
    }

    Write-Host "Waiting for SonarQube to start (this may take 30-60 seconds)..." -ForegroundColor Yellow
    Start-Sleep -Seconds 10

    # Wait for SonarQube to be ready
    $maxAttempts = 30
    $attempt = 0

    while ($attempt -lt $maxAttempts) {
        try {
            $response = Invoke-WebRequest -Uri "http://localhost:9000/api/system/health" -ErrorAction SilentlyContinue
            if ($response.StatusCode -eq 200) {
                Write-Host "SonarQube is ready!" -ForegroundColor Green
                return $true
            }
        }
        catch {
            $attempt++
            Start-Sleep -Seconds 2
        }
    }

    Write-Host "SonarQube started (may still be initializing). Proceeding..." -ForegroundColor Yellow
    return $true
}

# Function to generate Dart analysis report
function Generate-DartAnalysisReport {
    Write-Host "Generating Dart analysis report..." -ForegroundColor Yellow

    dart analyze lib/ --format=json > analysis.json

    if ($LASTEXITCODE -eq 0) {
        Write-Host "Dart analysis report generated: analysis.json" -ForegroundColor Green
        return $true
    }
    else {
        Write-Host "Warning: Dart analysis completed with issues (non-zero exit code)" -ForegroundColor Yellow
        return $true
    }
}

# Function to generate code coverage report
function Generate-CoverageReport {
    Write-Host "Generating code coverage report..." -ForegroundColor Yellow

    flutter test --coverage

    if ($LASTEXITCODE -eq 0) {
        Write-Host "Code coverage report generated: coverage/lcov.info" -ForegroundColor Green
        return $true
    }
    else {
        Write-Host "Warning: Some tests may have failed" -ForegroundColor Yellow
        return $true
    }
}

# Function to run SonarQube analysis
function Run-SonarAnalysis {
    param(
        [string]$Host,
        [string]$Token
    )

    Write-Host "Running SonarQube analysis..." -ForegroundColor Yellow

    # Check if sonar-scanner is available
    $sonarScannerPath = (Get-Command sonar-scanner -ErrorAction SilentlyContinue).Path

    if (-not $sonarScannerPath) {
        Write-Host "SonarScanner not found in PATH" -ForegroundColor Red
        Write-Host "Please install SonarScanner:" -ForegroundColor White
        Write-Host "  1. Download from: https://docs.sonarqube.org/latest/analyzing-source-code/scanners/sonarscanner/" -ForegroundColor White
        Write-Host "  2. Extract and add 'bin' directory to PATH" -ForegroundColor White
        Write-Host "  3. Run this script again" -ForegroundColor White
        return $false
    }

    # Run analysis
    sonar-scanner `
        -Dsonar.projectKey=vietnam-map-flutter `
        -Dsonar.sources=lib `
        -Dsonar.tests=test `
        -Dsonar.host.url=$Host `
        -Dsonar.login=$Token

    if ($LASTEXITCODE -eq 0) {
        Write-Host "SonarQube analysis completed successfully!" -ForegroundColor Green
        return $true
    }
    else {
        Write-Host "SonarQube analysis failed with exit code: $LASTEXITCODE" -ForegroundColor Red
        return $false
    }
}

# Main execution
Write-Host ""
Write-Host "Configuration:" -ForegroundColor Cyan
Write-Host "  SonarQube Host: $SonarHost"
Write-Host "  SonarQube Version: $SonarVersion"
Write-Host ""

# Step 1: Start SonarQube
$sonarStarted = Start-SonarQubeDocker
if (-not $sonarStarted) {
    Write-Host "Failed to start SonarQube. Exiting." -ForegroundColor Red
    exit 1
}

Write-Host ""

# Step 2: Generate reports
$dartAnalysisGenerated = Generate-DartAnalysisReport
Write-Host ""

$coverageGenerated = Generate-CoverageReport
Write-Host ""

# Step 3: Run analysis
$analysisCompleted = Run-SonarAnalysis -Host $SonarHost -Token $SonarToken
Write-Host ""

if ($analysisCompleted) {
    Write-Host "=== Setup Complete ===" -ForegroundColor Green
    Write-Host ""
    Write-Host "View your analysis results:" -ForegroundColor Cyan
    Write-Host "  URL: $SonarHost" -ForegroundColor White
    Write-Host "  Project Key: vietnam-map-flutter" -ForegroundColor White
    Write-Host ""
}
else {
    Write-Host "=== Setup Incomplete ===" -ForegroundColor Yellow
    Write-Host "Please review errors above and try again." -ForegroundColor Yellow
}

