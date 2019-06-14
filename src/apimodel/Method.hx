package apimodel;

import apimodel.Deprecated;

// class Method {
// 	public var name:String;
// 	public var visibility:String;
// 	public var returnValue:ReturnValue;
// 	public var parameters:Array<MethodParameter>;

// 	public function new(name:String, visibility:String, returnValue:ReturnValue, parameters:Array<MethodParameter>) {
// 		MyMacros.initLocals();
// 	}
// }

typedef Method = {
	public var name:String;
	public var visibility:String;
	public var returnValue:ReturnValue;
	public var parameters:Array<MethodParameter>;
	public var description:String;
	@:alias("static") public var isStatic:Bool;
	public var deprecated:Deprecated;
}
