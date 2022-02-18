Param(
    [Hashtable]$parameters
)

$parameters.multitenant = $false
$parameters.RunSandboxAsOnPrem = $true
#if ("$env:GITHUB_RUN_ID" -eq "") {
#    $parameters.includeAL = $true
#    $parameters.doNotExportObjectsToText = $true
#    $parameters.shortcuts = "none"
#}

New-BcContainer @parameters

Get-BcContainerAppInfo -containerName $parameters.ContainerName -tenantSpecificProperties -sort DependenciesLast | 
    Where-Object { $_.appid -ne  "63ca2fa4-4f03-4f2b-a480-172fef340d3f" -and $_.appid -ne "437dbf0e-84ff-417a-965d-ed2bb9650972" -and $_.name -ne "Application" } |
    ForEach-Object {
        Write-Host "Removing $($_.Name)"
        Unpublish-BcContainerApp -containerName $parameters.ContainerName -name $_.Name -unInstall -doNotSaveData -doNotSaveSchema -force
    }

Invoke-ScriptInBcContainer -containerName $parameters.ContainerName -scriptblock { $progressPreference = 'SilentlyContinue' }
