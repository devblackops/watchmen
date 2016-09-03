---
external help file: Watchmen-help.xml
online version: https://github.com/devblackops/watchmen/blob/master/docs/functions/Help-Syslog.md
schema: 2.0.0
---

# Syslog
## SYNOPSIS
Specifies a Syslog notifier.
## SYNTAX

```
Syslog [-Endpoints] <String[]> [-When <String>] [<CommonParameters>]
```

## DESCRIPTION
Specifies a Syslog notifier. This command accepts one parameter which is the IP address or FQDN of a syslog endpoint to send messages to.

This is not intended to be used anywhere but inside a 'Notifies' block inside a Watchmen file. Directly calling the 'Syslog' function outside of a
'Notifies' block will throw an error.
## EXAMPLES

### Example 1
```
WatchmenTest MyAppOVF {
    Notifies {
        syslog 'localhost'
    }
}
```

Adds a Syslog notifier to a WatchmenTest block.
### Example2
```
WatchmenOptions {
    Notifies {
        syslog '192.168.100.100'
    }
}
```

Adds a Syslog notifier to a WatchmenOptions block.
## PARAMETERS

### -Endpoints
One or more IP addresses/FQDNs of syslog endpoints to send messages to.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: 

Required: True
Position: 0
Default value: 
Accept pipeline input: False
Accept wildcard characters: False
```

### -When
{{Fill When Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
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

