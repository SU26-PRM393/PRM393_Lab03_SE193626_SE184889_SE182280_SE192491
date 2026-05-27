# SonarQube Quick Start - Standalone Edition

Your project is now configured to use SonarQube Community Edition with the standalone installation.

## ✅ Current Status
- ✓ `sonar-scanner` is installed and working
- ✓ SonarQube server is running on `http://localhost:9000`
- ✓ Analysis scripts are configured

## 🔐 Step 1: Generate Authentication Token

1. Open **http://localhost:9000** in your browser
2. Log in with default credentials (if first time):
   - Username: `admin`
   - Password: `admin`
3. Click your **profile icon** (top-right corner)
4. Select **My Account**
5. Go to the **Security** tab
6. Under "Generate Tokens":
   - Enter a token name: `flutter-project`
   - Click **Generate**
   - **Copy and save** the token (you won't see it again!)

## 🚀 Step 2: Run Analysis

### Option A: Using Generated Token (Recommended)
```powershell
cd D:\Semesters\Summer2026\PRM393\Project\VietNam-Map-Flutter
.\scripts\sonarqube-analyze.ps1 -SonarToken "YOUR_TOKEN_HERE"
```

Replace `YOUR_TOKEN_HERE` with your actual token from SonarQube.

### Option B: Using User Credentials
```powershell
cd D:\Semesters\Summer2026\PRM393\Project\VietNam-Map-Flutter
.\scripts\sonarqube-analyze.ps1 -SonarToken "admin"
```

## 📊 Step 3: View Results

After the analysis completes, open your browser to:
**http://localhost:9000/dashboard?id=vietnam-map-flutter**

You'll see:
- Code quality metrics
- Issues found
- Code coverage
- Duplications
- Security vulnerabilities

## 📝 Analysis What It Does

The analysis script performs 4 steps:

1. **Flutter Analysis** - Runs `flutter analyze` to check for warnings
2. **Dart Report** - Generates JSON analysis report
3. **Coverage Report** - Creates code coverage metrics via `flutter test`
4. **SonarQube Scan** - Uploads all metrics to SonarQube server

## 🐛 Troubleshooting

### Error: `401 - Unauthorized`
- The token or password is incorrect
- Re-generate a new token from SonarQube UI

### Error: `Cannot connect to http://localhost:9000`
- SonarQube server is not running
- Start it using your standalone installation (usually `bin\windows\StartSonar.bat`)
- Wait 30-60 seconds for it to be fully ready

### Error: `sonar-scanner not found`
- `sonar-scanner` is not in your PATH
- Reinstall via Chocolatey: `choco install sonarscanner`
- Or add the installation folder to your PATH manually

## 📋 Configuration Files

- **sonar-project.properties** - SonarQube project configuration
- **analysis_options.yaml** - Dart analyzer settings
- **scripts/sonarqube-analyze.ps1** - Analysis automation script

## 🔗 Useful Links

- SonarQube Dashboard: http://localhost:9000
- Project Dashboard: http://localhost:9000/dashboard?id=vietnam-map-flutter
- SonarQube Docs: https://docs.sonarqube.org/
- SonarQube Scanner: https://docs.sonarqube.org/latest/analyzing-source-code/scanners/sonarscanner/

---

**Need help?** Check the full integration guide in `SONARQUBE_SETUP.md`

