---
external help file: Watchmen-help.xml
schema: 2.0.0
online version:
---

# Email
## SYNOPSIS
Generate an email object in a 'Notifies' block.
## SYNTAX

```
Email [-Options] <Hashtable> [<CommonParameters>]
```

## DESCRIPTION
Generate an email object in a 'Notifies' block.

This is not intended to be used anywhere but inside a 'Notifies' block inside a Watchmen file. Directly calling the 'Email' function outside of a
'Notifies' block will throw an error.

The 'Subject' and Message' fields inside the hashtable for this function support string interpolation. The following keywords can be placed inside
the Subject or Message strings using the convention #{<keyword>}. When the Email notifier is executed these placeholders will be replaced with values
from the test result:

computername     - Computer name test was executed on  
module           - OVF module name  
file             - Path to Pester test executed  
descibe          - Name of 'Describe' block in Pester test  
context          - Name of 'Context' block in Pester test  
test             - Name of 'It' block in Pester test  
result           - Result of test. 'Passed' or 'Failed'  
failureMessage   - Failure message from Pester test  
duration         - Duration of Pester test  
   
Example:  
    subject = 'Watchmen alert - #{computername} - [#{test}] failed!'

## EXAMPLES

### Example 1
```
WatchmenTest MyAppOVF {
    Notifies {
        Email @{
            fromAddress = 'watchmen@mydomain.tld'
            smtpServer = 'smtp.mydomain.tld'
            port = 25
            subject = 'Watchmen alert - #{computername} - [#{test}] failed!'
            to = 'admin@mydomain.tld'
        }
    }
}
```
Add an Email notifier to a WatchmenTest block.

### Example 2
```
WatchmenOptions {
    notifies {
        email @{
            fromAddress = 'watchmen@mydomain.tld'
            smtpServer = 'smtp.mydomain.tld'
            port = 25
            subject = 'Watchmen alert - #{computername} - [#{test}] failed!'
            to = 'admin@mydomain.tld'
        }
    }
}
```

Add an Email notifier to a WatchmenOptions block.

## PARAMETERS

### -Options
Hashtable of values needed to send a SMTP email.

[string]FromAddress         - REQUIRED - From address for email  
[string[]]To                - REQUIRED - Array of email addresses to send to  
[string]SMTPServer          - REQUIRED - SMTP server FQDN or IP address  
[int]Port                   - REQUIRED - SMTP port (usually 25)  
[string]Subject             - OPTIONAL - Subject for email  
[string]Message             - OPTIONAL - Message for email  
[pscredential]Credential    - OPTIONAL - Credential to authenticate to SMTP server with  
[bool]UseSSL                - OPTINOAL - Use SSL when connecting to SMTP server  

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).
## INPUTS

### None

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS
