# Haxe extern generator for openUI5

[OpenUI5](https://openui5.org/) is a javascript application framework maintained by SAP SE available under apache 2 license.

How to generate the externs:
Use the created Neko file creator.n with
```neko creator.n {UI5 URL} {Path} {?Number} {?Lib}```

Or use the created Hashlink file creator.hl with
```hl creator.hl {UI5 URL} {Path} {?Number} {?Lib}```

For example:
```neko creator.n https://openui5.hana.ondemand.com/test-resources/sap/ C:\\hxUI5\\src\\ 101 m ```
for sap.m.LightBoxItem 

or 
```neko creator.n https://openui5.hana.ondemand.com/test-resources/sap/ C:\\hxUI5\\src\\```

for everything.

The URLs to the JSONS are:
* https://openui5.hana.ondemand.com/test-resources/sap/m/designtime/api.json --> m-Lib
* https://openui5.hana.ondemand.com/test-resources/sap/tnt/designtime/api.json --> tnt-Lib
* https://openui5.hana.ondemand.com/test-resources/sap/f/designtime/api.json --> f-lib
* https://openui5.hana.ondemand.com/test-resources/sap/ui/core/designtime/api.json --> ui-Lib
* https://openui5.hana.ondemand.com/test-resources/sap/uxap/designtime/api.json --> uxap-Lib

ToDos: 
* FunctionParameter "null" should be generated as ?paramName = null for overload functions
* ArgsConstructor can have more than 2 parameter

