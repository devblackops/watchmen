#requires -modules Watchmen

# Example script to get all OVF modules matching OVF.*
# et the module name from the result
# and invoke a Watchmen test inline

$mods = @('OVF.*')

$mods | % {

    $ovfTests = Get-OperationValidation -ModuleName $_

    $ovfMods = $ovfTests | Group-Object -Property ModuleName

    foreach ($ovfMod in $ovfMods.Name ) {
        $leaf = (Split-Path -Path $ovfMod -Leaf)

        if ($leaf -as [version]) {
            $modName = Split-Path -Path (Split-Path -Path $ovfMod -Parent) -Leaf
        } else {
            $modName = $leaf
        }

        WatchmenTest $modName {
            notifies {
                LogFile 'c:\temp\ovf_inline.log' -When Always
            }
        } | iwt -Verbose -IncludePesterOutput
    }
}
