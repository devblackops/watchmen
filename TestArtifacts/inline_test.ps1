#requires -modules Watchmen

# Example script to demonstrate executing Watchmen tests
# inline in an aribrary PowerShell script

$mods = @('OVF.Example1', 'OVF.Example2')
$mods | % {
    WatchmenTest $_ {        
        notifies {
            logfile 'c:\temp\ovf.example1_success.log' -When OnSuccess
            logfile 'c:\temp\ovf.example1_fail.log'
        }
    } | iwt -IncludePesterOutput -Verbose -PassThru
}
