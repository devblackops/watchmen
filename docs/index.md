---
schema: 2.0.0
---

# Get-WatchmenTest
## SYNOPSIS
Reads one or more Watchmen files and returns the test objects.
## SYNTAX

```
Get-WatchmenTest [-Path] <String[]> [-Recurse] [<CommonParameters>]
```

## DESCRIPTION
Reads one or more Watchmen files and returns the test objects.
## EXAMPLES

### Example 1
```
PS C:\> $tests = Get-WatchmenTest -Path c:\watchmen\my.watchmen.ps1
```

Reads in the Watchmen file c:\watchmen\my.watchmen.ps1
### Example 2
```
PS C:\> $allTests = Get-WatchmenTest -Path c:\watchmen -Recurse
```

Recursively reads in Watchmen files from path c:\watchmen
## PARAMETERS

### -Path
Path to to a Watchmen file or a folder containing Watchmen files.

If a path to a folder is given, only files with a *.watchmen.ps1 convention are processed. 

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: 

Required: True
Position: 0
Default value: Current directory
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Recurse
Recursively read in Watchmen files from given path.

Only Watchmen files with a *.watchmen.ps1 convention are processed.

```yaml
Type: SwitchParameter
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

### System.String[]

## OUTPUTS

### Watchmen.Test[]

## NOTES

## RELATED LINKS

[Invoke-WatchmenTest]()
