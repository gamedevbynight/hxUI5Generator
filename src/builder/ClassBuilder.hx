package builder;

import apimodel.ReturnValue;
import apimodel.Method;
import apimodel.MethodParameter;
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
		var fileContent:String = Tools.buildPackageNameForSymbol(symbol);

		fileContent += Tools.addNativeName(symbol);
		fileContent += Tools.buildDescription(symbol);
		fileContent += 'extern class ' + symbol.basename;
		fileContent += addExtends(symbol);
		fileContent += addImplements(symbol);
		fileContent += '\n{\n';
		fileContent += generateConstructor(symbol);
		fileContent += methodBuilder.build(symbol);
		fileContent += '}\n\n';

		if (checkArgsConstructor(symbol) || symbol.basename == 'ManagedObject') {
			fileContent += argsBuilder.build(symbol);
		}

		file.writeString(fileContent);

		return fileContent;
	}

	function addExtends(symbol:Symbol):String {
		var extending:String = '';
		if (symbol.extending != null && symbol.extending != 'Object') {
			extending += ' extends ' + Tools.determineType(symbol.extending);
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

	// TODO Constructor kann auch mehr als 2 Parameter haben
	function buildConstructorWithArgsTypedef(symbol:Symbol):String {
		var argsName:String = symbol.basename + 'Args';
		var constructor:String = '';
		constructor += '	@:overload(function(?sId:String, ?mSettings:$argsName):Void {})\n';
		constructor += '	public function new(?mSettings:$argsName):Void;\n';
		return constructor;
	}

	function buildMethodStyleConstructor(symbol:Symbol):String {
		var constructor:String = '';
		for (p in symbol.constructor.parameters) {
			p.optional = true;
		}
		constructor += methodBuilder.buildFunctionWithOverloads({
			name: 'new',
			returnValue: {type: 'Void', description: 'Object'},
			visibility: symbol.constructor.visibility,
			parameters: symbol.constructor.parameters,
			isStatic: false,
			description: '',
			deprecated: null
		});

		return constructor;
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
