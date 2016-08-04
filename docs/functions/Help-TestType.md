---
external help file: Watchmen-help.xml
online version: https://github.com/devblackops/watchmen/blob/master/docs/functions/Help-TestType.md
schema: 2.0.0
---

# TestType
## SYNOPSIS
Specifies the OVF test type to execute. This may be 'Simple', 'Comprehensive', or 'All'.

## SYNTAX

```
TestType [-Type] <String> [<CommonParameters>]
```

## DESCRIPTION
Specifies the OVF test type to execute. This may be 'Simple', 'Comprehensive', or 'All'. 'All' is the default if not specified.

## EXAMPLES

### Example 1
```
WatchmenTest 'MyAppOVF' {
    TestType 'Simple'
}
```

Teslls Watchmen to only execute 'Simple' tests within the 'MyAppOVF' module.

### Example 2
```
WatchmenTest 'MyAppOVF' {
    TestType 'Comprehensive'
}
```

Teslls Watchmen to only execute 'Comprehensive' tests within the 'MyAppOVF' module.

## PARAMETERS

### -Type
OVF Test type to execute.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 
Accepted values: Simple, Comprehensive, All

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

