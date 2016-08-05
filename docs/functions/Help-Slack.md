---
external help file: Watchmen-help.xml
online version: https://github.com/devblackops/watchmen/blob/master/docs/functions/Help-Slack.md
schema: 2.0.0
---

# Slack
## SYNOPSIS
Specifies an EventLog notifier.

## SYNTAX

```
Slack -Options <Hashtable[]> [<CommonParameters>]
```

## DESCRIPTION
Specifies an Slack notifier.

This is not intended to be used anywhere but inside a 'Notifies' block inside a Watchmen file. Directly calling the 'Slack' function outside of a
'Notifies' block will throw an error.

## EXAMPLES

### Example 1
```
WatchmenOptions {
    slack @{
        Token = 'asdfqwerty12345'
        Channel = '#Watchmen_Alerts'
        AuthorName = $env:COMPUTERNAME
        PreText = 'Everything is on :fire:'
        IconEmoji = ':fire:'
    }
}
```

Adds a Slack notifier to a WatchmenOptions block. The hashtable specified includes all the required parameters to send a Slack message using
the PSSlack module.

### Example 2

```
WatchmenTest {
    slack @{
        Token = 'asdfqwerty12345'
        Channel = '#Watchmen_Alerts'
        AuthorName = $env:COMPUTERNAME
        PreText = 'Everything is on :fire:'
        IconUrl = 'http://myicons.mydomain.tld/icon02.png'
    }
}
```

Adds a Slack notifier to a WatchmenTest block. The hashtable specified includes all the required parameters to send a Slack message using
the PSSlack module.

## PARAMETERS

### -Options
Hash table of required parameters to send a Slack message using the PSSlack module.

[string]Token       - REQUIRED - Webhook URL to send message to  
[string]Channel     - REQUIRED - Message for email  
[string]AuthorName  - REQUIRED - Name message should appear from  
[string]PreText     - OPTIONAL - Message to display ahead of message  
[string]IconUrl     - OPTIONAL - URL of icon to display alongside message    
[string]IconEmoji   - OPTIONAL - Emoji to display alongside message  

```yaml
Type: Hashtable[]
Parameter Sets: (All)
Aliases: 

Required: True
Position: Named
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

