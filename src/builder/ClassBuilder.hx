package builder;

import apimodel.Symbol;

/**
 * Builds the ClassFiles
**/
class ClassBuilder implements IBuilder {
	var argsBuilder:ArgsBuilder;
	var methodBuilder:MethodBuilder;

	public function new() {
		argsBuilder = new ArgsBuilder();
		methodBuilder = new MethodBuilder();
	}

	public function build(symbol:Symbol):String {
		Tools.setPathForSymbol(symbol);

		var file = Tools.fileForSymbol(symbol);
		var fileContent:StringBuf = new StringBuf();
		fileContent.add(Tools.buildPackageNameForSymbol(symbol));

		fileContent.add(Tools.addNativeName(symbol));
		fileContent.add(Tools.buildDescription(symbol));
		fileContent.add('extern class ' + symbol.basename);
		fileContent.add(addExtends(symbol));
		fileContent.add(addImplements(symbol));
		fileContent.add('\n{\n');
		fileContent.add(generateConstructor(symbol));
		fileContent.add(methodBuilder.build(symbol));
		fileContent.add('}\n\n');

		if (checkArgsConstructor(symbol) || symbol.basename == 'ManagedObject') {
			fileContent.add(argsBuilder.build(symbol));
		}

		file.writeString(fileContent.toString());

		return fileContent.toString();
	}

	function addExtends(symbol:Symbol):String {
		var extending:String = '';
		if (symbol.extending != null && symbol.extending != 'Object') {
			extending = ' extends ' + Tools.determineType(symbol.extending);
		}

		return extending;
	}

	function addImplements(symbol:Symbol):String {
		var implementing:String = '';
		if (symbol.implementing != null) {
			for (i in symbol.implementing) {
				if (i == 'sap.m.IHyphenation' || i == 'sap.ui.core.IDScope')
					continue;
				implementing += ' implements ' + i;
			}
		}

		return implementing;
	}

	function generateConstructor(symbol:Symbol):String {
		var constructor:String = '';
		if (symbol.constructor == null)
			return constructor;

		if (symbol.constructor.visibility == 'public') {
			if (checkArgsConstructor(symbol)) {
				constructor = buildConstructorWithArgsTypedef(symbol);
			} else {
				if (symbol.constructor.parameters != null) {
					constructor = buildMethodStyleConstructor(symbol);
				} else {
					constructor = buildEmptyConstructor();
				}
			}
		}
		return constructor;
	}

	// TODO 'ArgsConstuctor can have more than 2 parameter
	function buildConstructorWithArgsTypedef(symbol:Symbol):String {
		var argsName:String = symbol.basename + 'Args';
		var constructor = new StringBuf();
		constructor.add('');
		constructor.add('	@:overload(function(?sId:String, ?mSettings:$argsName):Void {})\n');
		constructor.add('	public function new(?mSettings:$argsName):Void;\n');
		return constructor.toString();
	}

	function buildMethodStyleConstructor(symbol:Symbol):String {
		var constructor = new StringBuf();
		constructor.add('');
		for (p in symbol.constructor.parameters) {
			p.optional = true;
		}
		constructor.add(methodBuilder.buildFunctionWithOverloads({
			name: 'new',
			returnValue: {type: 'Void', description: 'Object'},
			visibility: symbol.constructor.visibility,
			parameters: symbol.constructor.parameters,
			isStatic: false,
			description: '',
			deprecated: null
		}));

		return constructor.toString();
	}

	function buildEmptyConstructor():String {
		var constructor = 'public function new():Void;\n';
		return constructor;
	}

	function checkArgsConstructor(symbol:Symbol):Bool {
		if (symbol.constructor == null)
			return false;

		if (symbol.constructor.parameters != null
			&& symbol.constructor.parameters.length >= 2
			&& symbol.constructor.parameters[0].name == 'sId'
			&& symbol.constructor.parameters[1].name == 'mSettings') {
			return true;
		}

		return false;
	}
}
