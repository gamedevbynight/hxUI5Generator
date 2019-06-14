package apimodel;

class Overview
{
    public var version:String;
    public var library:String;
    public var symbols:Array<Symbol>;

    public function new(version:String,library:String,symbols:Array<Symbol>)
    {
        this.version = version;
        this.library = library;
        this.symbols = symbols;
    }


}