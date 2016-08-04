---
external help file: Watchmen-help.xml
online version: https://github.com/devblackops/watchmen/blob/master/docs/functions/Help-FromSource.md
schema: 2.0.0
---

# FromSource
## SYNOPSIS
Specifies the PowerShell repository source to retreive module from.
## SYNTAX

```
FromSource [-Source] <String> [<CommonParameters>]
```

## DESCRIPTION
Specifies the PowerShell repository source to retreive module from. This repository must already be registered on the system.
## EXAMPLES

### Example 1
```
WatchmenTest 'MyAppOVF' {
    fromSource 'PSGallery'
}
```

Tells Watchmen to download and install the 'MyAppOVF' module from the public PowerShell Gallery.

### Example 2
```
WatchmenTest 'MyOVFModule' {
    fromSource 'PrivateRepository
}
```

Tells Watchmen to download and install the 'MyAppOVF' module from a private repository called 'PrivateRepository'.

## PARAMETERS

### -Source
The PowerShell repository name to search for the module in.

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

