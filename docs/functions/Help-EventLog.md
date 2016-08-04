---
external help file: Watchmen-help.xml
online version: https://github.com/devblackops/watchmen/blob/master/docs/functions/Help-EventLog.md
schema: 2.0.0
---

# EventLog
## SYNOPSIS
Specifies an EventLog notifier.
## SYNTAX

```
EventLog -Options <Hashtable[]> [<CommonParameters>]
```

## DESCRIPTION
Specifies an EventLog notifier.

This is not intended to be used anywhere but inside a 'Notifies' block inside a Watchmen file. Directly calling the 'EventLog' function outside of a
'Notifies' block will throw an error.

## EXAMPLES

### Example 1
```
WatchmenTest MyAppOVF {
    Notifies {
        EventLog @{
            eventid = '1'
            eventtype = 'error'
        }
    }
}
```

Add an EventLog notifier to a WatchmenTest block.
### Example 2
```
WatchmenOptions {
    notifies {
        EventLog @{
            eventid = '15'
            eventtype = 'warning'
        }
    }
}
```

Add an EventLog notifier to a WatchmenOptions block.
## PARAMETERS

### -Options
Hashtable of values needed to create an event log entry.

[int]EventId         - REQUIRED - Specifies the event identifier. The maximum allowed value for the EventId parameter is 65535.  
[string]EventType    - REQUIRED - The event type. Valid values are Error, Warning, Information, SuccessAudit, and FailureAudit.    

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

