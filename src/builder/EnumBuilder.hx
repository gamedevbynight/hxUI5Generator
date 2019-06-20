package builder;

import hx.files.Path;
import apimodel.Symbol;

class EnumBuilder implements IBuilder{
	public function new() {}

	public function build(symbol:Symbol):String {
		Tools.setPathForSymbol(symbol);

		var file = Tools.fileForSymbol(symbol);

		var fileContent:StringBuf = new StringBuf();
		fileContent.add(Tools.buildPackageNameForSymbol(symbol));

		fileContent.add(Tools.addNativeName(symbol));

		fileContent.add('@:enum extern abstract ' + symbol.basename + '(String)\n{\n');

		if (symbol.properties != null) {
			for (property in symbol.properties) {
				fileContent.add( '    /**\n');
				fileContent.add('    * ' + property.description + '\n');
				fileContent.add('    */\n');
				fileContent.add('    var ' + property.name + '= "' + property.name + '";\n');
			}
		}

		fileContent.add('}\n');

		file.writeString(fileContent.toString());

		return fileContent.toString();
	}
}
