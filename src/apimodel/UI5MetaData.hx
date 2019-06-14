package apimodel;

// class UI5MetaData {
// 	public var stereotype:String;
// 	public var properties:Array<ClassProperty>;
// 	public var aggregations:Array<ClassAgregation>;
// 	public var associations:Array<ClassAssociation>;

// 	public function new(stereotype:String, properties:Array<ClassProperty>, aggregations:Array<ClassAgregation>, associations:Array<ClassAssociation>) {
// 		MyMacros.initLocals();
// 	}
// }

typedef UI5MetaData = {
	public var stereotype:String;
	public var properties:Array<ClassProperty>;
	public var aggregations:Array<ClassAgregation>;
	public var associations:Array<ClassAssociation>;
	public var basetype:String;
}
