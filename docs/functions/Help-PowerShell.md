---
external help file: Watchmen-help.xml
online version: https://github.com/devblackops/watchmen/blob/master/docs/functions/Help-PowerShell.md
schema: 2.0.0
---

# PowerShell
## SYNOPSIS
Specifies an PowerShell notifier.

## SYNTAX

### ScriptBlock (Default)
```
PowerShell [-ScriptBlock] <ScriptBlock>
```

### Script
```
PowerShell [-Path] <String>
```

## DESCRIPTION
Specifies an PowerShell notifier.

This is not intended to be used anywhere but inside a 'Notifies' block inside a Watchmen file. Directly calling the 'PowerShell' function outside of a
'Notifies' block will throw an error.

The PowerShell notifier accepts either a inline script block to execute, or a path to a PowerShell script file.

When Watchmen execute the inline script block or script file, the OVF test results object will be passed in. When executing an inline script block,
this object will be available as $args[0]. When executing a script file the object will be passed in as an unnamed parameter.

The following properties are available in the OVF test result object:

Error                       - StackTrace message of failing Pester test  
FileName                    - Path to Pester test script withing the OVF module  
Module                      - PowerShell module of the OVF test  
Name                        - Name of the OVF test executed  
RawResult  
    Context                 - Name of context block container test  
    Describe                - Name of describe block containing test  
    ErrorRecord             - Error record of failing test  
    FailureMessage          - Pester failure message  
    Name                    - Name of 'It' test  
    ParameterizedSuiteName  - Test case name  
    Parameters              - Parameters used in test case  
    Passed                  - Passor fail status of test. Values are [True] or [False]  
    Result                  - Pass or fail status of test. Values are [Passed] or [Failed]  
    StackTrace              - StackTrace message of failing Pester test  
    Time                    - Time Pester test took to execute  
Result                      - Pass or fail status of test. Values are [Passed] or [Failed]  
ShortName                   - File name of Pester test  


## EXAMPLES

### Example 1
```
WatchmenOptions {
    powershell {
        Write-Host "Something bad happended! Test [$($args[0]) failed with error [$($args[0].Error)]"
    }
}
```

Adds a PowerShell notifier to a WatchmenOptions block. This PowerShell script block will display a message using values contains withing test result
object.

### Example 2
```
WatchmenTest {
    powershell '\notifier.ps1'
}
``` 

Adds a PowerShell notifier to an individual Watchmen test. This PowerShell notifier will execute the 'notifier.ps1' script.

## PARAMETERS

### -Path
Path to a PowerShell script to execute upon any failing tests.

```yaml
Type: String
Parameter Sets: script
Aliases: 

Required: True
Position: 0
Default value: 
Accept pipeline input: False
Accept wildcard characters: False
```

### -ScriptBlock
Script block to execute upon any failing tests.

```yaml
Type: ScriptBlock
Parameter Sets: ScriptBlock
Aliases: 

Required: True
Position: 0
Default value: 
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

### None


## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

