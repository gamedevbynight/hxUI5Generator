package builder;

import hx.files.Path;
import apimodel.Symbol;

class InterfaceBuilder implements IBuilder{
	public function new() {}

	public function build(symbol:Symbol):String {
		Tools.setPathForSymbol(symbol);

		var file = Tools.fileForSymbol(symbol);

		var fileContent = new StringBuf();
		fileContent.add(Tools.buildPackageNameForSymbol(symbol));

		fileContent.add('extern interface ' + symbol.basename + '{ \n\n}');
		file.writeString(fileContent.toString());

		return fileContent.toString();
	}
}
