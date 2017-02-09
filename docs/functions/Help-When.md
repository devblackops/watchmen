---
external help file: Watchmen-help.xml
online version: https://github.com/devblackops/watchmen/blob/master/docs/functions/Help-When.md
schema: 2.0.0
---

# When

## SYNOPSIS
Specifies when one or more notifiers should be executed.

## SYNTAX

```
When [-Condition] <String> [<CommonParameters>]
```

## DESCRIPTION
Specifies when one or more notifiers should be executed.

## EXAMPLES

### Example 1
```
WatchmenOptions {
    notifies {
        when 'Always'
    }
}
```

Tells Watchmen to execute all notifiers regardless if they pass or fail.

## PARAMETERS

### -Condition
The condition for when the notifier should be executed.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 
Accepted values: Always, OnSuccess, OnFailure

Required: True
Position: 0
Default value: OnFailure
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

