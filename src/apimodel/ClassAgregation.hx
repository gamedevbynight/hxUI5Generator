package apimodel;

// class ClassAgregation
// {
//     public var name:String;
//     public var singularName:String;
//     public var type:String;
//     public var cardinality:String;
//     public var visibility:String;
//     public var description:String;
//     public var deprecated:Deprecated;
//     public function new(name:String,singularName:String,type:String,cardinality:String,description:String,deprecated:Deprecated)
//     {
//         MyMacros.initLocals();
//     }
// }
typedef ClassAgregation = {
	public var name:String;
	public var singularName:String;
	public var type:String;
	public var cardinality:String;
	public var visibility:String;
	public var description:String;
	public var deprecated:Deprecated;
}
