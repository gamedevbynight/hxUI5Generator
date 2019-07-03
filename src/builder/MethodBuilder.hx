package builder;

import apimodel.ReturnValue;
import apimodel.MethodParameter;
import apimodel.Method;
import apimodel.Symbol;

using StringTools;

class MethodBuilder implements IBuilder {
	public function new() {}

	public function build(symbol:Symbol):String {
		return generateMethods(symbol);
	}

	function generateMethods(symbol:Symbol):String {
		var methodContent = '';
		if (symbol.methods != null) {
			for (method in symbol.methods) {
				if (method.visibility == 'public' && method.deprecated == null && method.name.indexOf('.') == -1 && !method.name.contains("class")) {
					var isOnlyOverload:Bool = false;
					if (symbol.methods.indexOf(method) < symbol.methods.length - 1
						&& symbol.methods[symbol.methods.indexOf(method) + 1].name == method.name) {
						isOnlyOverload = true;
					}
					if (method.parameters != null) {
						methodContent += buildFunctionWithOverloads(method, isOnlyOverload);
					} else {
						methodContent += buildFunctionWithoutParameters(method, isOnlyOverload);
					}
				}
			}
		}
		var className:String = symbol.basename;
		methodContent = methodContent.replace('js.lib.Promise<>', 'js.lib.Promise<$className>');
		return methodContent;
	}

	public function buildFunctionWithOverloads(method:Method, ?isOnlyOverload:Bool = false):String {
		var overloadContent:String = '';
		var parameterCollection = new Array<Array<MethodParameter>>();
		for (parameter in method.parameters) {
			if (parameter.type.indexOf('|') != -1) {
				var typeCollection = new Array<MethodParameter>();
				var types = parameter.type.split('|');
				for (type in types) {
					typeCollection.push({
						name: parameter.name,
						type: type,
						optional: parameter.optional,
						description: parameter.description
					});
				}

				parameterCollection.push(typeCollection);
			} else {
				var type = new Array<MethodParameter>();
				type.push({
					name: parameter.name,
					type: parameter.type,
					optional: parameter.optional,
					description: parameter.description
				});
				parameterCollection.push(type);
			}
		}

		var parameterContents = new Array<String>();
		overloadContent = addOverloadforParameterCollection(parameterCollection, 0, parameterContents, method, true, isOnlyOverload);

		return overloadContent;
	}

	function addOverloadforParameterCollection(parameterCollection:Array<Array<MethodParameter>>, collectionNumber:Int, parameterContents:Array<String>,
			method:Method, isLast:Bool, isOnlyOverload:Bool):String {
		var content = new StringBuf();
		var last:Bool = false;
		var collection = parameterCollection[collectionNumber];
		if (collection == null)
			return ''; // TODO problems wit sap.m.Title! Should be checked
		for (parameter in collection) {
			// if (parameter.type != collection[collection.length - 1].type) {
			if (isLast && collection.lastIndexOf(parameter) == collection.length - 1) {
				last = true;
			} else {
				last = false;
			}
			if (!isOnlyOverload && collectionNumber == parameterCollection.length - 1) {
				var pc = new Array<String>();
				pc = pc.concat(parameterContents);
				pc.push(textForParameter(parameter));
				if (last && isLast) {
					content.add(buildMethodDescription(method));
					content.add(buildMethodBeginning(method));
					for (i in 0...pc.length) {
						content.add(pc[i]);
						if (i != pc.length - 1 && pc.length > 1) {
							content.add(', ');
						}
					}
					content.add('):' + contentForReturnValue(method.returnValue) + ';\n');
				} else {
					content.add('	@:overload( function(');
					for (i in 0...pc.length) {
						content.add(pc[i]);
						if (i != pc.length - 1 && pc.length > 1) {
							content.add(', ');
						}
					}
					content.add('):' + contentForReturnValue(method.returnValue) + '{ })\n');
				}
			} else {
				var pc = new Array<String>();
				pc = pc.concat(parameterContents);
				pc.push(textForParameter(parameter));
				content.add(addOverloadforParameterCollection(parameterCollection, collectionNumber + 1, pc, method, last, isOnlyOverload));
			}
		}

		return content.toString();
	}

	function buildMethodDescription(method:Method):String {
		var desc = new StringBuf();
		desc.add('\n');
		desc.add('	/**\n');
		desc.add('	* ' + method.description + '\n');
		if (method.parameters != null) {
			for (parameter in method.parameters) {
				desc.add('	* @param	' + parameter.name + ' ' + parameter.description + '\n');
			}
		}

		if (method.returnValue != null) {
			desc.add('	* @return	' + method.returnValue.description + '\n');
		} else {
			desc.add('	* @return	Void\n');
		}

		desc.add('	*/\n');
		return desc.toString();
	}

	function checkDescriptionisType(description:String):Bool {
		switch (description) {
			case 'boolean' | 'string' | 'int' | 'float' | 'object' | 'function':
				return true;
		}

		return false;
	}

	function buildFunctionWithoutParameters(method:Method, ?isOnlyOverload:Bool = false):String {
		var f:String = '';
		if (isOnlyOverload) {
			f = buildOverloadMethod(method);
			return f;
		} else {
			f += buildMethodDescription(method);
			f += buildMethodBeginning(method);
			f += '):' + contentForReturnValue(method.returnValue) + ';\n';
			return f;
		}
	}

	function buildOverloadMethod(method:Method):String {
		var methodContent:String = '';
		methodContent = '@:overload( function():' + contentForReturnValue(method.returnValue) + '{ })\n';
		return methodContent;
	}

	function contentForReturnValue(returnValue:ReturnValue):String {
		if (returnValue == null)
			return 'Void';
		if (returnValue.type == null) {
			if (checkDescriptionisType(returnValue.description)) {
				return Tools.determineType(returnValue.description);
			} else {
				return 'Dynamic';
			}
		}

		if (returnValue.type.indexOf('|') != -1) {
			return 'Dynamic';
		}
		return Tools.determineType(returnValue.type);
	}

	function textForParameter(parameter:MethodParameter):String {
		var parameterContent= new StringBuf();
		if (parameter.optional) {
			parameterContent.add('?');
		}
		parameterContent.add(parameter.name + ':' + Tools.determineType(parameter.type));

		return parameterContent.toString();
	}

	function buildMethodBeginning(method:Method):String {
		var withStatic:String = '';
		if (method.isStatic) {
			withStatic = ' static';
		}

		var beginning:String = '';
		beginning = '	public$withStatic function ' + method.name + '( ';

		return beginning;
	}
}
