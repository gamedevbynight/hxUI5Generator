package builder;

import apimodel.Symbol;

class TypedefBuilder implements IBuilder {

	public function new() {
	
	}

	public function build(symbol:Symbol):String {
		var fileContent:String = '';
		if (symbol.returnValue != null && symbol.parameters != null) {
			{
				fileContent = buildFileForTypedef(symbol);
			}
		}
		return fileContent;
	}

	function buildFileForTypedef(symbol:Symbol):String {
		Tools.setPathForSymbol(symbol);

		var nativeName = false;
		if (symbol.originalName != null) {
			nativeName = true;
		}

		if (Tools.isLowerCase(symbol.basename.charAt(0)))  {
			nativeName = true;
			var chars = symbol.basename.split('');
			chars[0] = chars[0].toUpperCase();
			symbol.basename = '';
			for (char in chars) {
				symbol.basename += char;
			}
			symbol.originalName = symbol.name;
		}

		var file = Tools.fileForSymbol(symbol);
		var fileContent = new StringBuf();
		fileContent.add(Tools.buildPackageNameForSymbol(symbol));

		if (nativeName) {
			fileContent.add('@:native("' + symbol.originalName + '")\n');
		}

		fileContent.add('extern class ' + symbol.basename);
		fileContent.add('\n{\n');
		if (symbol.parameters != null) {
			fileContent.add(buildParameter(symbol));
			fileContent.add('\n\n');
		}

		fileContent.add('}\n\n');

		file.writeString(fileContent.toString());

		return fileContent.toString();
	}

	function buildParameter(symbol:Symbol):String {
		var parameterContent:String = "";
		for (parameter in symbol.parameters) {
				parameterContent += (Tools.buildComment('	', parameter.description));
				parameterContent += '	 public var ' + parameter.name + ':' + Tools.determineType(parameter.type) + ';\n';
		}

		return parameterContent;
	}
}
