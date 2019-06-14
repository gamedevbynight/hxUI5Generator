package apimodel;

import apimodel.Deprecated;

// class Event {
// 	public var name:String;
// 	public var visibility:String;
// 	public var parameters:Array<ClassParameter>;

// 	public function new(name:String, visibility:String, parameters:Array<ClassParameter>) {
// 		MyMacros.initLocals();
// 	}
// }

typedef Event = {
	public var name:String;
	public var visibility:String;
	public var parameters:Array<EventParameter>;
	public var deprecated:Deprecated;
	public var description:String;
}
