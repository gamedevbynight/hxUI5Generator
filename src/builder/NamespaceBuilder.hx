package builder;

import apimodel.Symbol;

class NamespaceBuilder implements IBuilder {
	var methodBuilder:MethodBuilder;

	public function new() {
		methodBuilder = new MethodBuilder();
	}

	public function build(symbol:Symbol):String {
		var fileContent:String = '';
		if (symbol.methods != null || symbol.ui5metadata != null || symbol.properties != null) {
			if (symbol.ui5metadata != null && symbol.ui5metadata.stereotype == 'datatype') {
				fileContent = buildFileForDatatypeNamespace(symbol);
			}
			if (symbol.methods != null || symbol.properties != null) {
				fileContent = buildFileForNamespace(symbol);
			}
		}
		return fileContent;
	}

	function buildFileForDatatypeNamespace(symbol:Symbol):String {
		Tools.setPathForSymbol(symbol);

		var file = Tools.fileForSymbol(symbol);
		var fileContent = new StringBuf();
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

	function buildFileForNamespace(symbol:Symbol):String {
		Tools.setPathForSymbol(symbol);

		var nativeName = false;
		if (symbol.originalName != null) {
			nativeName = true;
		}

		if (symbol.basename == 'browser') {
			trace("hier bin ich");
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
		if (symbol.properties != null) {
			fileContent.add(buildProperties(symbol));
			fileContent.add('\n\n');
		}
		if (symbol.methods != null) {
			fileContent.add(methodBuilder.build(symbol));
		}
		fileContent.add('}\n\n');

		file.writeString(fileContent.toString());

		return fileContent.toString();
	}

	function buildProperties(symbol:Symbol):String {
		var propertiesContent:String = "";
		for (property in symbol.properties) {
			if (property.visibility == "public") {
				propertiesContent += (Tools.buildComment('	', property.description));
				propertiesContent += '	 public static var ' + property.name + ':' + Tools.determineType(property.type) + ';\n';
			}
		}

		return propertiesContent;
	}
}
