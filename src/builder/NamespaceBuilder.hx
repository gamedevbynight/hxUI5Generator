package builder;

import apimodel.Symbol;

class NamespaceBuilder implements IBuilder {
	var methodBuilder:MethodBuilder;

	public function new() {
		methodBuilder = new MethodBuilder();
	}

	public function build(symbol:Symbol):String {
		var fileContent:String = '';
		if (symbol.methods != null || symbol.ui5metadata != null) {
			if (symbol.ui5metadata != null && symbol.ui5metadata.stereotype == 'datatype') {
				fileContent = buildFileForDatatypeNamespace(symbol);
			}
			if (symbol.methods != null) {
				fileContent = buildFileForMethodNamespace(symbol);
			}
		}
		return fileContent;
	}

	function buildFileForDatatypeNamespace(symbol:Symbol):String {
		Tools.setPathForSymbol(symbol);

		var file = Tools.fileForSymbol(symbol);
		var fileContent:String = Tools.buildPackageNameForSymbol(symbol);

		fileContent += Tools.buildComment('', symbol.description);

		var type = Tools.determineType(symbol.ui5metadata.basetype);

		fileContent += 'abstract ' + symbol.basename + '($type) from $type to $type {\n';
		fileContent += '    inline function new(i:$type) {\n';
		fileContent += '        this = i;\n';
		fileContent += '    }\n';
		fileContent += '}\n';

		file.writeString(fileContent);
		return fileContent;
	}

	function buildFileForMethodNamespace(symbol:Symbol):String {
		Tools.setPathForSymbol(symbol);

		var nativeName = false;
		if (symbol.originalName != null) {
			nativeName = true;
		}

		if (Tools.isLowerCase(symbol.basename.charAt(0))) {
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
		var fileContent:String = Tools.buildPackageNameForSymbol(symbol);

		if (nativeName) {
			fileContent += '@:native("' + symbol.originalName + '")\n';
		}

		fileContent += 'extern class ' + symbol.basename;
		fileContent += '\n{\n';
		fileContent += methodBuilder.build(symbol);
		fileContent += '}\n\n';

		file.writeString(fileContent);

		return fileContent;
	}
}
