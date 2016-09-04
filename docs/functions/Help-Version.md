---
external help file: Watchmen-help.xml
online version: https://github.com/devblackops/watchmen/blob/master/docs/functions/Help-Version.md
schema: 2.0.0
---

# Version
## SYNOPSIS
Specifies the version of the OVF module to execute tests from.
## SYNTAX

```
Version [-Version] <String> [<CommonParameters>]
```

## DESCRIPTION
Specifies the version of the OVF module to execute tests from. Since OVF tests are normal PowerShell modules, multiple versions of the module are
allowed to be installed on the system. If this parameter is not specified, the latest version of the module will be used.
## EXAMPLES

### Example 1
```
WatchmenTest 'MyAppOVF' {
    Version '1.2.3'
}
```

Teslls Watchmen to execute tests from version 1.2.3 of the 'MyAppOVF' module.
## PARAMETERS

### -Version
Version of module to execute tests from. If not specified, the latest installed version of the module will be used.

```yaml
Type: String
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

