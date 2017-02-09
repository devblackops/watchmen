---
external help file: Watchmen-help.xml
online version: https://github.com/devblackops/watchmen/blob/master/docs/functions/Help-WatchmenTest.md
schema: 2.0.0
---

# WatchmenTest

## SYNOPSIS
Specifies an OVF module to execute Pester tests from.

## SYNTAX

### NoName (Default)
```
WatchmenTest [-Script] <ScriptBlock> [<CommonParameters>]
```

### Name
```
WatchmenTest [[-Name] <String>] [-Script] <ScriptBlock> [<CommonParameters>]
```

## DESCRIPTION
Specifies an OVF module to execute Pester tests from. Optional properties are specified to execute a specific OVF module version, test name or type,
override parameters from Pester tests, and to execute notifiers upon any failing tests.

## EXAMPLES

### Example 1
```
WatchmenTest 'MyAppOVF' {
    version 1.0.0 
    type 'Simple'
    test 'Storage.Capacity'
    fromSource 'PSGallery'
    parameters {
        FreeSystemDriveThreshold = 40000
    }
    notifies {
        logfile '//fileserver01.mydomain.tld/monitoringshare/#{computername}.log'
    }
}
```

Execute Pester tests from version 1.0.0 of module 'MyAppOVF.' Also only run the 'Simple' test type named 'Storage.Capacity.' If the specified
module and/or version is not installed on the system, then download the module from the 'PSGallery' PowerShell repository. When the test is executed,
insert the parameter 'FreeSystemDriveThreshold' into the Pester test to override any default value for that parameter. Upon a failing test, execute
the 'Logfile' notifier and write an entry to the log file located on a file share.

## PARAMETERS

### -Name
OVF module name to execute Pester tests from

```yaml
Type: String
Parameter Sets: Name
Aliases: 

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Script
Scriptblock containing commands to define the specific OVF module and/or test(s) to execute and under what conditions.

```yaml
Type: ScriptBlock
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

