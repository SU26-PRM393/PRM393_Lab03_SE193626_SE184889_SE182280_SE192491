# SonarQube Integration Guide

This guide explains how to use SonarQube Community Edition to analyze your Vietnam Map Flutter project.

## Quick Start

### 1. Prerequisites

- **Docker** (recommended) or Java 17+
- **SonarScanner CLI** (for code analysis)
- **Flutter & Dart SDK** (already installed)

### 2. Install SonarScanner

#### Option A: Direct Download (Recommended)

1. Download from GitHub Releases:
   **https://github.com/SonarSource/sonar-scanner-msbuild/releases**
   
   Look for the latest release and download `sonar-scanner-x.x.x-windows.zip`

2. Extract to a folder (e.g., `C:\sonar-scanner`)

3. Add `C:\sonar-scanner\bin` to your Windows PATH:
   - Right-click "This PC" → Properties
   - Advanced system settings → Environment Variables
   - New (User variable):
     - Variable name: `PATH`
     - Variable value: `C:\sonar-scanner\bin`

4. Verify installation:
   ```powershell
   sonar-scanner -h
   ```

#### Option B: Using Chocolatey

```powershell
choco install sonarscanner
```

#### Option C: Using npm

```powershell
npm install -g sonar-scanner
```

### 3. Start SonarQube

#### Option A: Docker (Recommended)

```powershell
docker run -d `
    --name sonarqube `
    -p 9000:9000 `
    -p 9092:9092 `
    -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLED=true `
    sonarqube:community
```

Wait 30-60 seconds for startup, then access: http://localhost:9000
- Username: `admin`
- Password: `admin`

#### Option B: Standalone Installation

1. Download from: https://www.sonarqube.org/downloads/
2. Extract and run: `bin\windows\StartSonar.bat`
3. Access: http://localhost:9000

### 4. Run Analysis

#### Automated Setup (First Time)

```powershell
cd .\scripts
.\sonarqube-setup.ps1
```

This script will:
- Start SonarQube (if using Docker)
- Generate Dart analysis reports
- Generate code coverage reports
- Run SonarQube analysis

#### Manual Analysis (Subsequent Runs)

```powershell
cd .\scripts
.\sonarqube-analyze.ps1
```

### 5. View Results

Open your browser to: **http://localhost:9000**

Navigate to the project: **vietnam-map-flutter**

## Configuration Files

- **`sonar-project.properties`** - Main SonarQube configuration
- **`scripts/sonarqube-setup.ps1`** - Initial setup script
- **`scripts/sonarqube-analyze.ps1`** - Quick analysis script

## Configuration Reference

### sonar-project.properties

| Property | Value | Description |
|----------|-------|-------------|
| `sonar.projectKey` | `vietnam-map-flutter` | Unique project identifier |
| `sonar.projectName` | `Vietnam Map Flutter` | Display name |
| `sonar.sources` | `lib` | Source code directory |
| `sonar.tests` | `test` | Test code directory |
| `sonar.exclusions` | `**/*.g.dart,...` | Excluded files (generated, build, etc.) |
| `sonar.coverageReportPaths` | `coverage/lcov.info` | Code coverage report location |
| `sonar.host.url` | `http://localhost:9000` | SonarQube server URL |

## Generated Reports

The analysis process generates the following reports:

- **`analysis.json`** - Dart analyzer output (JSON format)
- **`coverage/lcov.info`** - Code coverage report (LCOV format)
- **SonarQube Dashboard** - Interactive analysis results

## Troubleshooting

### SonarScanner not found

```powershell
# Check if sonar-scanner is in PATH
Get-Command sonar-scanner

# Add to PATH manually:
$env:Path += ";C:\sonar-scanner\bin"
```

### SonarQube not starting

```powershell
# Check Docker
docker ps

# View SonarQube logs
docker logs sonarqube

# Restart if needed
docker restart sonarqube
```

### Port already in use

```powershell
# Find process using port 9000
Get-NetTCPConnection -LocalPort 9000 | Select-Object OwningProcess

# Or stop existing SonarQube container
docker stop sonarqube
docker remove sonarqube
```

### Analysis fails with authentication error

```powershell
# Use the correct token (default: admin)
# Or generate a token in SonarQube UI:
# Administration > Security > Users > Generate Token

.\sonarqube-analyze.ps1 -SonarToken "your-token-here"
```

## Advanced Usage

### Custom SonarQube Configuration

Edit `sonar-project.properties`:

```properties
# Increase timeout for large projects
sonar.projectBaseDir=.
sonar.working.directory=.sonar

# Quality gates
sonar.qualitygate.wait=true

# Coverage thresholds
sonar.coverage.exclusions=test/**,lib/**/model/**
```

### CI/CD Integration

For GitHub Actions or other CI systems, set environment variable:

```powershell
$env:SONARQUBE_TOKEN = "your-generated-token"
```

Then run:

```powershell
sonar-scanner `
    -Dsonar.projectKey=vietnam-map-flutter `
    -Dsonar.host.url=http://sonarqube-host:9000
```

## Limitations with SonarQube Community

- **Language Support**: Limited Dart/Flutter support (better than most alternatives)
- **Features Not Available**:
  - Custom metrics
  - Advanced portfolio management
  - SAML/OAuth integration
  - Pull request decoration

**Alternative Tools for Better Dart Support:**
- `dart analyze` (built-in, recommended)
- `flutter_lints` (already configured in your project)
- `very_good_cli` (third-party, comprehensive)
- `dartfmt` (code formatting validation)

## Best Practices

1. **Run before commits**:
   ```powershell
   flutter analyze
   flutter test --coverage
   ```

2. **Add to pre-commit hooks** (Git):
   ```bash
   #!/bin/bash
   flutter analyze && flutter test --coverage
   ```

3. **Schedule periodic analysis** (Windows Task Scheduler):
   - Create task to run `scripts/sonarqube-analyze.ps1` daily

4. **Maintain quality gates**:
   - Set minimum coverage threshold (e.g., 80%)
   - Address critical issues before merging

## Documentation

- SonarQube Docs: https://docs.sonarqube.org/
- Dart Analysis: https://dart.dev/guides/language/analysis-options
- Flutter Testing: https://flutter.dev/docs/testing

---

**Project**: Vietnam Map Flutter  
**Version**: 0.1.0  
**Last Updated**: 2026-05-27

