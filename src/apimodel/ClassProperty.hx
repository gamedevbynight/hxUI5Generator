package apimodel;

// class ClassProperty {
// 	public var name:String;
// 	public var type:String;
// 	public var defaultValue:String;
// 	public var group:String;
// 	public var visibility:String;
// 	public var description:String;
// 	public var deprecated:Deprecated;

// 	public function new(name:String, type:String, defaultValue:String, group:String, visibility:String, description:String, deprecated:Deprecated) {
// 		MyMacros.initLocals();
// 	}
// }

typedef ClassProperty = {
	public var name:String;
	public var type:String;
	public var defaultValue:String;
	public var group:String;
	public var visibility:String;
	public var description:String;
	public var deprecated:Deprecated;
}
