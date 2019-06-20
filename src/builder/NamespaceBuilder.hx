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
		var fileContent= new StringBuf();
		fileContent.add(Tools.buildPackageNameForSymbol(symbol));

		fileContent.add(Tools.buildComment('', symbol.description));

		var type = Tools.determineType(symbol.ui5metadata.basetype);

		fileContent.add('abstract ' + symbol.basename + '($type) from $type to $type {\n');
		fileContent.add('    inline function new(i:$type) {\n');
		fileContent.add('        this = i;\n');
		fileContent.add('    }\n');
		fileContent.add('}\n');

		file.writeString(fileContent.toString());
		return fileContent.toString();
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
		var fileContent= new StringBuf();
		fileContent.add(Tools.buildPackageNameForSymbol(symbol));

		if (nativeName) {
			fileContent.add('@:native("' + symbol.originalName + '")\n');
		}

		fileContent.add('extern class ' + symbol.basename);
		fileContent.add('\n{\n');
		fileContent.add(methodBuilder.build(symbol));
		fileContent.add('}\n\n');

		file.writeString(fileContent.toString());

		return fileContent.toString();
	}
}
