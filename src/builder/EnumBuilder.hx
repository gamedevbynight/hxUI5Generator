package builder;

import hx.files.Path;
import apimodel.Symbol;

class EnumBuilder implements IBuilder{
	public function new() {}

	public function build(symbol:Symbol):String {
		Tools.setPathForSymbol(symbol);

		var file = Tools.fileForSymbol(symbol);

		var fileContent:String = Tools.buildPackageNameForSymbol(symbol);

		fileContent += Tools.addNativeName(symbol);

		fileContent += '@:enum extern abstract ' + symbol.basename + '(String)\n{\n';

		if (symbol.properties != null) {
			for (property in symbol.properties) {
				fileContent += '    /**\n';
				fileContent += '    * ' + property.description + '\n';
				fileContent += '    */\n';
				fileContent += '    var ' + property.name + '= "' + property.name + '";\n';
			}
		}

		fileContent += '}\n';

		file.writeString(fileContent);

		return fileContent;
	}
}
