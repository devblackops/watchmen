---
external help file: Watchmen-help.xml
online version: https://github.com/devblackops/watchmen/blob/master/docs/functions/Help-Test.md
schema: 2.0.0
---

# Test

## SYNOPSIS
Specifies the 'Describe' block in a Pester test to execute.

## SYNTAX

```
Test [[-Test] <String>] [<CommonParameters>]
```

## DESCRIPTION
Specifies the 'Describe' block in a Pester test to execute. Pester / OVF tests can include multiple 'Describe' blocks to logically seperate
tests. This parameter allows you to only execute the designated 'Describe' block name.

## EXAMPLES

### Example 1
```
WatchmenTest 'MyAppOVF' {
    Test 'Services'
}
```

Tells Watchmen to only execute tests within the 'Describe' block 'Services' inside the OVF module 'MyAppOVF.'

## PARAMETERS

### -Test
Name of the 'Describe' block in the Pester test.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
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

