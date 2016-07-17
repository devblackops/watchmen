---
external help file: Watchmen-help.xml
schema: 2.0.0
online version: 
---

# Invoke-WatchmenTest
## SYNOPSIS
Execute one or more Watchmen objects representing OVF tests.
## SYNTAX

### File (Default)
```
Invoke-WatchmenTest -Path <String[]> [-Recurse] [-IncludePesterOutput] [-PassThru] [-DisableNotifiers]
 [<CommonParameters>]
```

### InputObject
```
Invoke-WatchmenTest -InputObject <PSObject[]> [-IncludePesterOutput] [-PassThru] [-DisableNotifiers]
 [<CommonParameters>]
```

## DESCRIPTION
Execute one or more Watchmen objects representing OVF tests. Upon any failing tests, Watchmen will optionally execute a number of notifier actions
such as sending en email, or writing to the event log.
## EXAMPLES

### Example 1
```
PS C:\> Invoke-WatchmenTest -Path c:\watchmen\my.watchmen.ps1
```

Invoke All OVF tests defined in Watchmen file c:\watchmen\my.watchmen.ps1

### Example 2
```
$tests = Get-WatchmenTest -Path c:\watchmen\my.watchmen.ps1
$tests | Invoke-WatchmenTest -Verbose

```

Read in Watchmen objects and pass via the pipeline to Invoke-WatchmenTest with verbose output.

### Example 3
```
$results = Get-WatchmenTest -Path c:\watchmen\my.watchmen.ps1 | Invoke-WatchmenTest -Verbose -IncludePesterOutpull -PassTru
```

Include Pester output and return test results

### Example 4
```
Invoke-WatchmenTest -Path c:\watchmen -Recurse -Verbose -IncludePesterOutput -DisableNotifiers
```

Recursively read Watchmen files in c:\watchmen, execute the tests, but do not run any notifier actions.

## PARAMETERS

### -DisableNotifiers
Do not run any notifiers upon failing OVF tests.

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

### -IncludePesterOutput
Display Pester output of tests contained in OVF modules.

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

### -InputObject
Watchmen object representing tests and notifiers to execute.

```yaml
Type: Watchmen.Test[]
Parameter Sets: InputObject
Aliases: 

Required: True
Position: Named
Default value: 
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -PassThru
Return test results after execution.

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

### -Path
One or more paths to Watchmen files, or folders containing Watchmen files.

```yaml
Type: String[]
Parameter Sets: File
Aliases: 

Required: True
Position: Named
Default value: 
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Recurse
Recursively search for Watchmen files inside given path.

```yaml
Type: SwitchParameter
Parameter Sets: File
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
System.Management.Automation.PSObject[]
## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

[Get-WatchmenTest]()
