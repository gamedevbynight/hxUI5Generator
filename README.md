# Haxe extern generator for openUI5

[OpenUI5](https://openui5.org/ OpenUI5) is a javascript application framework maintained by SAP SE available under apache 2 license.

How to generate the externs:
Use the created Neko file creator.n with
`neko creator.n {UI5 URL} {Path} {?Number} {?Lib}`

For example:
`neko creator.n https://openui5.hana.ondemand.com/test-resources/sap/ C:\\hxUI5\\src\\ 101 m `
for sap.m.LightBoxItem 

or 
`neko creator.n https://openui5.hana.ondemand.com/test-resources/sap/ C:\\hxUI5\\src\\`

for everything.

The URLs to the JSONS are:
* https://openui5.hana.ondemand.com/1.66.0/test-resources/sap/m/designtime/api.json --> m-Lib
* https://openui5.hana.ondemand.com/1.66.0/test-resources/sap/tnt/designtime/api.json --> tnt-Lib
* https://openui5.hana.ondemand.com/1.66.0/test-resources/sap/f/designtime/api.json --> f-lib
* https://openui5.hana.ondemand.com/1.66.0/test-resources/sap/ui/core/designtime/api.json --> ui-Lib
* https://openui5.hana.ondemand.com/1.66.0/test-resources/sap/uxap/designtime/api.json --> uxap-Lib

ToDos: 
* Change String to StringBuffer
* FunctionParameter "null" should be integrated as ?paramName = null for overload functions
* 'ArgsConstuctor can have more than 2 parameter
* there are some Problem with sap.m.Title
