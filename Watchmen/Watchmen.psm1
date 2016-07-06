
# Dot source public/private
$Public  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -Recurse -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -Recurse -ErrorAction SilentlyContinue )
Foreach($import in @($Public + $Private)) {
    . $import.fullname
}

Initialize-Watchmen

# The allowed commands within the scope of 'OvfSetup', 'OvfTest', and 'Notifies'
# If the commands are called outside of their respective scopes and error will be thrown
$script:CommandFences = @{
    WatchmenOptions = @(
        'Notifies',
        'Rorschach'
    )
    WatchmenTest = @(
        'FromSource',
        'Notifies',
        'TestType',
        'Parameters',
        'Test',
        'Version'
    )
    Notifies = @(
        'Notifies',
        'Email',
        'EventLog',
        'LogFile',
        'PowerShell',
        'Slack',
        'Syslog'
    )
}

# Aliases
New-Alias -Name gwt -Value Get-WatchmenTest
New-Alias -Name iwt -Value Invoke-WatchmenTest

# Export aliases / functions
Export-ModuleMember -Alias 'gwt','iwt'
Export-ModuleMember -Function $Public.Basename
