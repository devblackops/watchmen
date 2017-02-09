---
external help file: Watchmen-help.xml
online version: https://github.com/devblackops/watchmen/blob/master/docs/functions/Help-Parameters.md
schema: 2.0.0
---

# Parameters

## SYNOPSIS
Specifies one or more parameters to pass into a Pester test.

## SYNTAX

```
Parameters [-Parameters] <Hashtable> [<CommonParameters>]
```

## DESCRIPTION
Specifies one or more parameters in the form of a hashtable to pass into a Pester test. These parameters must match script parameters defined in the
Pester test.

## EXAMPLES

### Example 1
```
WatchmenTest 'MyAppOVF' {
    Parameters {
        FreeSpaceThreshold = 40000
    }
}
```

Defines a Watchmen test to execute the OVF module 'MyAppOVF' and pass the parameter 'FreeSpaceThreshold' to the Pester test inside the OVF module.

## PARAMETERS

### -Parameters
Hashtable of parameters to pass into Pester test.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases: 

Required: True
Position: 0
Default value: None
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

