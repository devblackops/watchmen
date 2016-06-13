
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
        'FileSystem',
        'Slack',
        'Syslog'
    )
}

# Export public functions
Export-ModuleMember -Function $Public.Basename
