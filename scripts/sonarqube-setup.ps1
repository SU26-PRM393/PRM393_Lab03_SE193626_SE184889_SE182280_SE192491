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

Write-Output "=== SonarQube Integration Setup ==="

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
    Write-Output "Starting SonarQube Community Edition with Docker..."

    if (-not (Test-Docker)) {
        Write-Output "Docker is not installed. Please install Docker first."
        Write-Output "Download from: https://www.docker.com/products/docker-desktop"
        return $false
    }

    # Check if container already running
    $existingContainer = docker ps -a --filter "name=sonarqube" --format "{{.Names}}"

    if ($existingContainer) {
        Write-Output "SonarQube container already exists. Starting it..."
        docker start sonarqube
    }
    else {
        Write-Output "Creating and starting new SonarQube container..."
        docker run -d `
            --name sonarqube `
            -p 9000:9000 `
            -p 9092:9092 `
            -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLED=true `
            sonarqube:community
    }

    Write-Output "Waiting for SonarQube to start (this may take 30-60 seconds)..."
    Start-Sleep -Seconds 10

    # Wait for SonarQube to be ready
    $maxAttempts = 30
    $attempt = 0

    while ($attempt -lt $maxAttempts) {
        try {
            $response = Invoke-WebRequest -Uri "http://localhost:9000/api/system/health" -ErrorAction SilentlyContinue
            if ($response.StatusCode -eq 200) {
                Write-Output "SonarQube is ready!"
                return $true
            }
        }
        catch {
            $attempt++
            Start-Sleep -Seconds 2
        }
    }

    Write-Output "SonarQube started (may still be initializing). Proceeding..."
    return $true
}

# Function to generate Dart analysis report
function Generate-DartAnalysisReport {
    Write-Output "Generating Dart analysis report..."

    dart analyze lib test --format=json > analysis.json

    if ($LASTEXITCODE -eq 0) {
        Write-Output "Dart analysis report generated: analysis.json"
        return $true
    }
    else {
        Write-Output "Warning: Dart analysis completed with issues (non-zero exit code)"
        return $true
    }
}

# Function to generate code coverage report
function Generate-CoverageReport {
    Write-Output "Generating code coverage report..."

    flutter test --coverage

    if ($LASTEXITCODE -eq 0) {
        Write-Output "Code coverage report generated: coverage/lcov.info"
        return $true
    }
    else {
        Write-Output "Warning: Some tests may have failed"
        return $true
    }
}

# Function to run SonarQube analysis
function Run-SonarAnalysis {
    param(
        [string]$Host,
        [string]$Token
    )

    Write-Output "Running SonarQube analysis..."

    # Check if SonarScanner is available
    $sonarScannerPath = (Get-Command Sonar-Scanner -ErrorAction SilentlyContinue).Path

    if (-not $sonarScannerPath) {
        Write-Output "SonarScanner not found in PATH"
        Write-Output "Please install SonarScanner:"
        Write-Output "  1. Download from: https://docs.sonarqube.org/latest/analyzing-source-code/scanners/sonarscanner/"
        Write-Output "  2. Extract and add 'bin' directory to PATH"
        Write-Output "  3. Run this script again"
        return $false
    }

    # Run analysis
    Sonar-Scanner `
        -Dsonar.host.url=$Host `
        -Dsonar.login=$Token

    if ($LASTEXITCODE -eq 0) {
        Write-Output "SonarQube analysis completed successfully!"
        return $true
    }
    else {
        Write-Output "SonarQube analysis failed with exit code: $LASTEXITCODE"
        return $false
    }
}

# Main execution
Write-Output ""
Write-Output "Configuration:"
Write-Output "  SonarQube Host: $SonarHost"
Write-Output "  SonarQube Version: $SonarVersion"
Write-Output ""

# Step 1: Start SonarQube
$sonarStarted = Start-SonarQubeDocker
if (-not $sonarStarted) {
    Write-Output "Failed to start SonarQube. Exiting."
    exit 1
}

Write-Output ""

# Step 2: Generate reports
$dartAnalysisGenerated = Generate-DartAnalysisReport
Write-Output ""

$coverageGenerated = Generate-CoverageReport
Write-Output ""

# Step 3: Run analysis
$analysisCompleted = Run-SonarAnalysis -Host $SonarHost -Token $SonarToken
Write-Output ""

if ($analysisCompleted) {
    Write-Output "=== Setup Complete ==="
    Write-Output ""
    Write-Output "View your analysis results:"
    Write-Output "  URL: $SonarHost"
    Write-Output "  Project Key: SU26-PRM393_VietNam-Map-Flutter"
    Write-Output ""
}
else {
    Write-Output "=== Setup Incomplete ==="
    Write-Output "Please review errors above and try again."
}

