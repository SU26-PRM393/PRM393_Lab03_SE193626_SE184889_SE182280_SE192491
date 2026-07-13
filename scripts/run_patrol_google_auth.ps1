param(
    [string]$TestFile = "patrol_test/google_login_auth_test.dart",
    [string]$EnvFile = ".env.test",
    [string]$Device
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Get-EnvFileValues {
    param([string]$Path)

    if (-not (Test-Path -LiteralPath $Path)) {
        throw "Environment file not found: $Path"
    }

    $values = @{}

    foreach ($line in Get-Content -LiteralPath $Path) {
        $trimmed = $line.Trim()

        if (-not $trimmed -or $trimmed.StartsWith("#")) {
            continue
        }

        $separatorIndex = $trimmed.IndexOf("=")
        if ($separatorIndex -lt 1) {
            continue
        }

        $key = $trimmed.Substring(0, $separatorIndex).Trim()
        $value = $trimmed.Substring($separatorIndex + 1).Trim()

        if (
            ($value.StartsWith('"') -and $value.EndsWith('"')) -or
            ($value.StartsWith("'") -and $value.EndsWith("'"))
        ) {
            $value = $value.Substring(1, $value.Length - 2)
        }

        $values[$key] = $value
    }

    return $values
}

$repoRoot = Split-Path -Parent $PSScriptRoot
Push-Location $repoRoot

try {
    $envPath = if ([System.IO.Path]::IsPathRooted($EnvFile)) {
        $EnvFile
    } else {
        Join-Path $repoRoot $EnvFile
    }

    $envValues = Get-EnvFileValues -Path $envPath

    $dartDefineKeys = @(
        'PATROL_GOOGLE_TEST_EMAIL',
        'PATROL_GOOGLE_TEST_PASSWORD',
        'TEST_USER_EMAIL',
        'TEST_USER_PASSWORD',
        'TEST_ADMIN_EMAIL',
        'TEST_ADMIN_PASSWORD'
    )

    $cmdArgs = @('test', '-t', $TestFile)

    if ($Device) {
        $cmdArgs += @('-d', $Device)
    }

    foreach ($key in $dartDefineKeys) {
        if ($envValues.ContainsKey($key) -and -not [string]::IsNullOrWhiteSpace($envValues[$key])) {
            $cmdArgs += @('--dart-define', "$key=$($envValues[$key])")
        }
    }

    & patrol @cmdArgs
    if ($LASTEXITCODE -ne 0) {
        exit $LASTEXITCODE
    }
}
finally {
    Pop-Location
}