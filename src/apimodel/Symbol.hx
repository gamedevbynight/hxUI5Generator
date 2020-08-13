package apimodel;

import apimodel.ReturnValue;

// class Symbol {
// 	public var kind:String;
// 	public var name:String;
// 	public var basename:String;
// 	public var visibility:String;
// 	public var description:String;
// 	public var extend:String;
// 	public var properties:Array<Property>;
// 	public var methods:Array<Method>;
// 	public var constructor:Constructor;
// 	public var events:Array<Event>;
// 	public var implement:Array<String>;
// 	public var ui5metadata:UI5MetaData;

// 	public function new(kind:String, name:String, basename:String, visibility:String, description:String, extend:String, properties:Array<Property>,
// 			methods:Array<Method>, constructor:Constructor, events:Array<Event>, implement:Array<String>, ui5metadata:UI5MetaData) {
// 		MyMacros.initLocals();
// 	}
// }

typedef Symbol = {
	public var kind:String;
	public var name:String;
	public var basename:String;
	public var visibility:String;
	public var description:String;
	public var module:String;
	@:alias("extends") public var extending:String;
	public var properties:Array<Property>;
	public var methods:Array<Method>;
	public var constructor:Constructor;
	public var events:Array<Event>;
	public var originalName:String;
	public var returnValue:ReturnValue;
	public var parameters:Array<MethodParameter>;
	@:alias("implements")public var implementing:Array<String>;
	@:alias("ui5-metadata")public var ui5metadata:UI5MetaData;
}
