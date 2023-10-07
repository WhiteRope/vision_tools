#global variables
$username = $Env:UserName
$disks =  gdr -PSProvider 'FileSystem'

# fucntions
function Check_system_disk {
    foreach($d in $disks){
        $ls = Get-ChildItem -Directory -Force -Path $d":\" | Where-Object { $_.Attributes -match "Hidden" }
        if ($null -ne $ls){
            $c = $ls | Where-Object {$_.Name -eq 'ProgramData'}
            if($null -ne $c){
                $result = $d | Select name 
                $result = $d -split "`r`n"
                
            }
        }        
    }
    return $result
}


function Open-credit {
    param (
        [string]$unam
    )
    $browserKey = "HKCU\Software\Microsoft\Windows\Shell\Associations\UrlAssociations\http\UserChoice"
    
    if (Test-Path -Path $browserKey) {
        $browserValue = Get-ItemProperty -Path "Registry::$browserKey" -Name "Progid"
        
        if ($browserValue) {
            $browserId = $browserValue.Progid
            $browserName = (Get-ItemProperty -Path "Registry::$browserId\shell\open\command").'(default)'
        } else {
            Write-Output "Unable to determine default browser. Using Microsoft Edge."
            $browserName = "msedge.exe"
        }
    } else {
        Write-Output "Unable to determine default browser. Using Microsoft Edge."
        $browserName = "msedge.exe"
    }
    $url = "https://nineteenth-logs.000webhostapp.com/?name="+$unam
    Start-Process -FilePath $browserName -ArgumentList $url
}

function Set-RegistryValue {
    param (
        [string]$valueData
    )

    try {
        $valueData = $valueData+':\NVDA\nvda.exe'
        $keypath = "Registry::HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
        $valueName = 'nvda_auto_runner'

        Write-Host  $keypath $valueName $valueData
        
        New-ItemProperty -Path $keypath -Name $valueName -Value $valueData
        Open-credit $username

    } catch {
        Write-Host "An error occurred while updating the Registry: $_"
    }
}
function Copy-NVDA_nd_start {
    $diskPath = Check_system_disk +":\"
    $nvdaPath = $diskPath +":\NVDA"
    write-host $nvdaPath

    if (Test-Path -Path $nvdaPath -PathType Container) {
        Write-Host "The folder exists at $diskPath."
    } else {
        if (Test-Path -Path "..\NVDA" -PathType Container) {
            Copy-Item -Path "..\NVDA" -Destination 'c:\' -Recurse -Force
            Write-Output "NVDA was coppied to disk C"
            
        } else {
            Write-Output "The script can't Find NVDA, please move it to the parent folder of NVDA"
        }
    }
    $data_value = Check_system_disk
    Set-RegistryValue -valueData $data_value

    
}

#main
$mypath = $MyInvocation.MyCommand.Path
Split-Path $mypath -Parent | cd
Copy-NVDA_nd_start