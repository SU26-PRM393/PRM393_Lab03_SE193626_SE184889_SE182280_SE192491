# Run Patrol E2E Tests for Vietnam Map Flutter
# Supports local development and CI execution

param(
    [string]$Target = "android",
    [string]$Suite = "all",
    [int]$Reruns = 1,
    [switch]$Verbose,
    [switch]$Evidence
)

$ErrorActionPreference = "Stop"

# Configuration
$projectRoot = Split-Path -Parent $PSScriptRoot
$patrolTestsDir = Join-Path $projectRoot "patrol_tests"
$evidenceDir = Join-Path $patrolTestsDir "evidence"
$summaryFile = Join-Path $evidenceDir "results-summary.md"

# Color output helpers
function Write-Header {
    param([string]$Message)
    Write-Host "===============================================" -ForegroundColor Cyan
    Write-Host $Message -ForegroundColor Cyan
    Write-Host "===============================================" -ForegroundColor Cyan
}

function Write-Status {
    param([string]$Message, [string]$Status = "INFO")
    $color = @{
        "INFO" = "Green"
        "WARN" = "Yellow"
        "FAIL" = "Red"
    }[$Status]
    Write-Host "[$Status] $Message" -ForegroundColor $color
}

# Verify prerequisites
function Verify-Prerequisites {
    Write-Header "Verifying Prerequisites"
    
    # Check Flutter
    if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
        Write-Status "Flutter not found in PATH" "FAIL"
        exit 1
    }
    Write-Status "Flutter found: $(flutter --version)" "INFO"
    
    # Check Patrol
    $pubspec = Get-Content (Join-Path $projectRoot "pubspec.yaml")
    if ($pubspec -notmatch "patrol:") {
        Write-Status "Patrol not configured in pubspec.yaml" "FAIL"
        exit 1
    }
    Write-Status "Patrol configured in pubspec.yaml" "INFO"
    
    # Check test files exist
    $testFiles = @(
        "authentication_test.dart",
        "publication_test.dart",
        "journal_test.dart",
        "keyword_test.dart",
        "profile_test.dart",
        "export_test.dart",
        "remote_config_test.dart"
    )
    
    foreach ($file in $testFiles) {
        $filePath = Join-Path $patrolTestsDir $file
        if (-not (Test-Path $filePath)) {
            Write-Status "Test file not found: $file" "WARN"
        }
    }
    
    Write-Status "Prerequisites verified" "INFO"
}

# Build app for testing
function Build-App {
    Write-Header "Building Flutter App for Testing"
    
    Set-Location $projectRoot
    
    # Get dependencies
    Write-Status "Getting dependencies..." "INFO"
    flutter pub get
    if ($LASTEXITCODE -ne 0) {
        Write-Status "Failed to get dependencies" "FAIL"
        exit 1
    }
    
    # Build debug APK if needed
    Write-Status "Building debug APK..." "INFO"
    flutter build apk --debug
    if ($LASTEXITCODE -ne 0) {
        Write-Status "Failed to build app" "FAIL"
        exit 1
    }
    
    Write-Status "App built successfully" "INFO"
}

# Run Patrol tests
function Run-Patrol-Tests {
    param(
        [string]$Suite = "all",
        [int]$Reruns = 1
    )
    
    Write-Header "Running Patrol E2E Tests"
    
    Set-Location $projectRoot
    
    $testCmd = "patrol test"
    
    if ($Suite -ne "all") {
        $testCmd += " patrol_tests/${Suite}_test.dart"
    } else {
        $testCmd += " patrol_tests/"
    }
    
    if ($Reruns -gt 1) {
        $testCmd += " --allow-reruns=$Reruns"
    }
    
    if ($Verbose) {
        $testCmd += " --verbose"
    }
    
    Write-Status "Executing: $testCmd" "INFO"
    Invoke-Expression $testCmd
    
    $exitCode = $LASTEXITCODE
    
    if ($exitCode -eq 0) {
        Write-Status "All tests passed" "INFO"
    } else {
        Write-Status "Tests failed with exit code $exitCode" "FAIL"
    }
    
    return $exitCode
}

# Main execution
try {
    Verify-Prerequisites
    Build-App
    
    $exitCode = Run-Patrol-Tests -Suite $Suite -Reruns $Reruns
    
    if ($Evidence) {
        Write-Header "Evidence Collection"
        Write-Status "Evidence files should be in: $evidenceDir" "INFO"
        if (Test-Path $summaryFile) {
            Write-Status "Summary report found" "INFO"
        } else {
            Write-Status "Summary report not yet generated" "WARN"
        }
    }
    
    exit $exitCode
}
catch {
    Write-Status "Error: $_" "FAIL"
    exit 1
}
