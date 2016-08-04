---
external help file: Watchmen-help.xml
online version: https://github.com/devblackops/watchmen/blob/master/docs/functions/Help-LogFile.md
schema: 2.0.0
---

# LogFile
## SYNOPSIS
Specifies a LogFile notifier.
## SYNTAX

```
LogFile [-Path] <String[]> [<CommonParameters>]
```

## DESCRIPTION
Specifies a LogFile notifier. This command accepts one parameter which is the path to a log file to either create or append to.

This is not intended to be used anywhere but inside a 'Notifies' block inside a Watchmen file. Directly calling the 'EventLog' function outside of a
'Notifies' block will throw an error.

## EXAMPLES

### Example 1
```
WatchmenTest MyAppOVF {
    Notifies {
        LogFile '\\fileserver01\watchmen\watchmen.log'
    }
}
```

Adds a LogFile notifier to a WatchmenTest block.

### Example2
```
WatchmenOptions {
    Notifies {
        LogFile @{
            '\\fileserver01\watchmen\watchmen.log',
            'c:\temp\watchmen.log'
        }
    }
}
```

Adds a LogFile notifier to a WatchmenOptions block.

## PARAMETERS

### -Path
One or more file paths to append test result to. If the file(s) do not exist, they will be created.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).
## INPUTS

### None

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

