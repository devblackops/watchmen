---
external help file: Watchmen-help.xml
online version: https://github.com/devblackops/watchmen/blob/master/docs/functions/Help-InfluxDB.md
schema: 2.0.0
---

# InfluxDB
## SYNOPSIS
Specifies an InfluxDB notifier.

## SYNTAX

```
InfluxDB [-Options] <Hashtable> [-When <String>]
```

## DESCRIPTION
Specifies an InfluxDB notifier.

This is not intended to be used anywhere but inside a 'Notifies' block inside a Watchmen file. Directly calling the 'InfluxDB' function outside of a
'Notifies' block will throw an error.

## EXAMPLES

### Example 1
```
WatchmenTest MyAppOVF {
    Notifies {
        InfluxDB {
            url 'http://influxdb.mydomain.tld'
            port 8086
            Database watchmen
            MeasurementName watchmen_test
            tags @{
                prop1 = 'asdf'
                prop2 = 'qwerty'
                prop3 = 42
            }
        } -when 'always'
    }
}
```

Add an InfluxDB notifier to a WatchmenTest block.

## PARAMETERS

### -Options
Hashtable of values needed to send a metric to InfluxDB.

[string]Url                 - REQUIRED - URL of InfluxDB
[string[]]Database          - REQUIRED - InfluxDB database to insert into
[int]Port                   - OPTIONAL - Port of InfluxDB
[string]MeasurementName     - OPTIONAL - The measurement name to store in InfluxDB
[hashtable]Tags             - OPTIONAL - Tags to append to metric
[string]RetentionPolicy     - OPTIONAL - InfluxDB database retention policy to use
[int]Timeout                - OPTIONAL - HTTP timeout
[pscredential]Credential    - OPTIONAL - Credential to authenticate to InfluxDB with
[bool]SkipSSLVerification   - OPTIONAL - Skip SSL verification when connecting to InfluxDB

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value:
Accept pipeline input: False
Accept wildcard characters: False
```

### -When
Specifies when notifier should be executed.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: Always, OnSuccess, OnFailure

Required: False
Position: Named
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

