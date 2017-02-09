
## 1.2.1 (2017-02-09)

* Fix bug where InfluxDB notifier function was not being exported (via @devblackops)
* Fix all typos for Descibe -> Describe (via @megamorf)
* Remove hardcoded $true for UseSSL value in Email notifier (via @megamorf)
* Fix custom message attribute for Email (via @megamorf)
* Fix variable replacement in LogFile notifier (via @megamorf)

## 1.2.0 (2016-09-08)

* Add InfluxDB notifier type.
* Fix bug where only the first notifier would be called if the OVF module included more than one test.

## 1.1.0 (2016-09-03)

* Allow notifiers to be optionally executed upon successful tests.

## 1.0.0 (2016-08-12)

* Initial release

## 0.2.0 (2016-06-08)

* Implement internal OperationValidation functions temporarily.

## 0.1.0 (2016-06-08)

* Initial commit
