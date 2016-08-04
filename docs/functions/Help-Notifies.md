---
external help file: Watchmen-help.xml
online version: https://github.com/devblackops/watchmen/blob/master/docs/functions/Help-Notifies.md
schema: 2.0.0
---

# Notifies
## SYNOPSIS
Specifies one or more notifiers to be executed upon any failing tests.
## SYNTAX

```
Notifies [-Script] <ScriptBlock> [<CommonParameters>]
```

## DESCRIPTION
Specifies one or more notifiers to be executed upon any failing tests.
## EXAMPLES

### Example 1
```
WatchmenOptions {
    Notifies {
        Email @{
            FromAddress = 'watchmen@mydomain.tld'
            SmtpServer = 'smtp.mydomain.tld'
            Port = 25
            Subject = 'Watchmen Alert - #{computername} -[#{test}] failed!'
        }
        EventLog @{
            EventId = 1
            EventType = 'error'
        }
        FileSystem '\\fileserver01.mydomain.tld\monitoringshare\#{computername}.log'
        PowerShell {
            Write-Host "Something bad happended! $args[0]"
        }
        PowerShell '\notifier.ps1'
        Slack @{
            Title = 'Watchmen Bot'
            Token = '<webhookurl>'
            Channel = '#watchmen'
            EconEmoji = ':fire:'
        }
        Syslog 'syslog.mydomain.tld'
    }
}
```

Specifies various notifiers to be executed upon any failing tests.

## PARAMETERS

### -Script
Scriptblock listing notifier functions to execute.

```yaml
Type: ScriptBlock
Parameter Sets: (All)
Aliases: 

Required: True
Position: 0
Default value: 
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).
## INPUTS

### None

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

