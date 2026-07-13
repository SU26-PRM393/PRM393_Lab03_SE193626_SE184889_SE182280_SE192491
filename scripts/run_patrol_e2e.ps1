param(
    [ValidateSet('us1-core-map', 'us1-search-filter-sort', 'us1-province-selection', 'dashboard-stats', 'admin-campaign-crud', 'admin-login-auth', 'admin-user-list', 'notification-workflow', 'user-campaigns-display', 'logout', 'google-auth', 'all')]
    [string]$Suite = 'us1-core-map',
    [string]$EnvFile = '.env.test',
    [string]$Device
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Ensure-AndroidPlatformToolsOnPath {
    if (Get-Command adb -ErrorAction SilentlyContinue) {
        return
    }

    $repoRoot = Split-Path -Parent $PSScriptRoot
    $localPropertiesPath = Join-Path $repoRoot 'android/local.properties'
    $sdkDir = $null

    if (Test-Path -LiteralPath $localPropertiesPath) {
        foreach ($line in Get-Content -LiteralPath $localPropertiesPath) {
            if ($line -match '^\s*sdk\.dir\s*=\s*(.+)\s*$') {
                $sdkDir = $Matches[1].Trim()
                $sdkDir = $sdkDir -replace '\\\\', '\'
                break
            }
        }
    }

    if (-not $sdkDir -and $env:ANDROID_SDK_ROOT) {
        $sdkDir = $env:ANDROID_SDK_ROOT
    }
    if (-not $sdkDir -and $env:ANDROID_HOME) {
        $sdkDir = $env:ANDROID_HOME
    }

    if (-not $sdkDir) {
        return
    }

    $platformTools = Join-Path $sdkDir 'platform-tools'
    if (-not (Test-Path -LiteralPath $platformTools)) {
        return
    }

    if ($env:PATH -notlike "*$platformTools*") {
        $env:PATH = "$platformTools;$env:PATH"
    }
}

function Get-PatrolCommandSpec {
    $patrolCmd = Get-Command patrol -ErrorAction SilentlyContinue
    if ($patrolCmd) {
        return @{
            FilePath = $patrolCmd.Source
            PrefixArgs = @()
        }
    }

    return @{
        FilePath = 'dart'
        PrefixArgs = @('pub', 'global', 'run', 'patrol_cli:main')
    }
}

function Get-EnvFileValues {
    param([string]$Path)

    if (-not (Test-Path -LiteralPath $Path)) {
        throw "Environment file not found: $Path"
    }

    $values = @{}

    foreach ($line in Get-Content -LiteralPath $Path) {
        $trimmed = $line.Trim()

        if (-not $trimmed -or $trimmed.StartsWith('#')) {
            continue
        }

        $separatorIndex = $trimmed.IndexOf('=')
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

function Invoke-PatrolTest {
    param(
        [string]$TestFile,
        [hashtable]$EnvValues,
        [string]$DeviceId
    )

    $dartDefineKeys = @(
        'PATROL_GOOGLE_TEST_EMAIL',
        'PATROL_GOOGLE_TEST_PASSWORD',
        'TEST_USER_EMAIL',
        'TEST_USER_PASSWORD',
        'TEST_ADMIN_EMAIL',
        'TEST_ADMIN_PASSWORD'
    )

    $patrolCommand = Get-PatrolCommandSpec
    $cmdArgs = @($patrolCommand.PrefixArgs + @('test', '-t', $TestFile))

    if ($DeviceId) {
        $cmdArgs += @('-d', $DeviceId)
    }

    foreach ($key in $dartDefineKeys) {
        if ($EnvValues.ContainsKey($key) -and -not [string]::IsNullOrWhiteSpace($EnvValues[$key])) {
            $cmdArgs += @('--dart-define', "$key=$($EnvValues[$key])")
        }
    }

    Write-Host "Running Patrol test: $TestFile" -ForegroundColor Cyan
    Ensure-AndroidPlatformToolsOnPath
    & $patrolCommand.FilePath @cmdArgs
    if ($LASTEXITCODE -ne 0) {
        exit $LASTEXITCODE
    }
}

$suiteToTests = @{
    'us1-core-map' = @('patrol_test/core_map_viewport_controls_test.dart')
    'us1-search-filter-sort' = @('patrol_test/map_search_filter_sort_test.dart')
    'us1-province-selection' = @('patrol_test/province_selection_lower_level_reveal_test.dart')
    'dashboard-stats' = @('patrol_test/dashboard_statistics_test.dart')
    'admin-campaign-crud' = @('patrol_test/admin_campaign_crud_test.dart')
    'admin-login-auth' = @('patrol_test/admin_gate_login_authorization_test.dart')
    'admin-user-list' = @('patrol_test/admin_user_list_test.dart')
    'notification-workflow' = @('patrol_test/notification_workflow_test.dart')
    'user-campaigns-display' = @('patrol_test/user_campaigns_display_test.dart')
    'logout' = @('patrol_test/logout_test.dart')
    'google-auth' = @('patrol_test/google_login_auth_test.dart')
    'all'         = @(
        'patrol_test/core_map_viewport_controls_test.dart',
        'patrol_test/map_search_filter_sort_test.dart',
        'patrol_test/province_selection_lower_level_reveal_test.dart',
        'patrol_test/dashboard_statistics_test.dart',
        'patrol_test/admin_campaign_crud_test.dart',
        'patrol_test/admin_gate_login_authorization_test.dart',
        'patrol_test/admin_user_list_test.dart',
        'patrol_test/notification_workflow_test.dart',
        'patrol_test/user_campaigns_display_test.dart',
        'patrol_test/logout_test.dart',
        'patrol_test/google_login_auth_test.dart'
    )
}

$repoRoot = Split-Path -Parent $PSScriptRoot
Push-Location $repoRoot

try {
    $envPath = if ([System.IO.Path]::IsPathRooted($EnvFile)) {
        $EnvFile
    }
    else {
        Join-Path $repoRoot $EnvFile
    }

    $envValues = Get-EnvFileValues -Path $envPath
    $tests = $suiteToTests[$Suite]

    foreach ($test in $tests) {
        Invoke-PatrolTest -TestFile $test -EnvValues $envValues -DeviceId $Device
    }
}
finally {
    Pop-Location
}