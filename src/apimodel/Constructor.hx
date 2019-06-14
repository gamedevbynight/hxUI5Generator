package apimodel;

// class Constructor {
// 	public var visibility:String;
// 	public var parameters:Array<MethodParameter>;
// 	public var description:String;

// 	public function new(visibility:String, parameters:Array<MethodParameter>, description:String) {
// 		MyMacros.initLocals();
// 	}
// }

typedef Constructor = {
	public var visibility:String;
	public var parameters:Array<MethodParameter>;
	public var description:String;
}
