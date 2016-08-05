---
external help file: Watchmen-help.xml
online version: https://github.com/devblackops/watchmen/blob/master/docs/functions/Help-WatchmenOptions.md
schema: 2.0.0
---

# WatchmenOptions
## SYNOPSIS
Specifies a global set of options that subsequent Watchmen tests will inherit from.

## SYNTAX

```
WatchmenOptions [[-Script] <ScriptBlock>] [<CommonParameters>]
```

## DESCRIPTION
Specifies a global set of options that subsequent Watchmen tests will inherit from. Specifing notifiers within the WatchmenOptions block allows
all subsequent Watchmen tests to use those notifiers in addition to any defined directly on the Watchmen test.

## EXAMPLES

### Example 1
```
WatchmenOptions {
    notifies {
        email @{
            fromAddress = 'watchmen@mydomain.tld'
            smtpServer = 'smtp.mydomain.tld'
            port = 25
            subject = 'Watchmen alert - #{computername} - [#{test}] failed!'
            to = 'admin@mydomain.tld'            
        }
        eventlog @{
            eventid = '1'
            eventtype = 'error'
        }
        logfile '//fileserver01.mydomain.tld/monitoringshare/#{computername}.log'
        powershell {
            Write-Host "Something bad happended! $args[0]"
        }
        powershell '\notifier.ps1'        
        slack @{
            Token = 'webhookurl'
            Channel = '#Watchmen'
            AuthorName = $env:COMPUTERNAME
            PreText = 'Everything is on :fire:'
            IconEmoji = ':fire:'
        }
        syslog 'syslog.mydomain.tld'
    }
}
```

This defines a set of notifiers that will be executed upon any failing Watching tests. All Watchmen tests will execute notifiers specified in
WatchmenOptions in addition to any specified directly on the Watchmen test.

## PARAMETERS

### -Script
ScriptBlock containing a single command 'Notifies' with the desired notifier commands to execute.

```yaml
Type: ScriptBlock
Parameter Sets: (All)
Aliases: 

Required: False
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

