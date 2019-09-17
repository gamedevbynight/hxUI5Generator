package;

import hx.files.File;
import hx.files.Path;
import apimodel.Symbol;

using StringTools;

class Tools {
	public static function setPathForSymbol(symbol:Symbol):Void {
		var pathName:String = symbol.name.substring(0, symbol.name.lastIndexOf('.'));
		pathName = pathName.replace('.', '/');

		pathName = pathName.toLowerCase();
		var path = Path.of(pathName);
		if (pathName == null) {
			path = Path.of(Sys.args()[1]);
		}

		var dir = path.toDir();
		if (!path.exists()) {
			dir.create();
		}
		dir.setCWD();
	}

	public static function findHaxeName(name:String):String {
		var newName:String = name.replace('module:', '');
		newName = newName.replace('/', '.');
		newName = fixNamePath(newName);

		return newName;
	}

	public static function checkCorrectName(name:String):Bool {
		var splits = name.split('.');
		if (splits.length > 1) {
			return isLowerCase(splits[splits.length - 2].charAt(0));
		}
		return false;
	}

	public static function fixNamePath(name:String):String {
		var subPaths = name.split('.');

		for (i in 0...subPaths.length - 1) {
			subPaths[i] = subPaths[i].toLowerCase();
		}

		name = '';
		for (subPath in subPaths) {
			name += subPath;
			if (subPath != subPaths[subPaths.length - 1]) {
				name += '.';
			}
		}

		return name;
	}

	public static function addNativeName(symbol:Symbol):String {
		var native:String = '';
		if (symbol.originalName != null) {
			native = '@:native("' + symbol.originalName + '")\n';
		}
		return native;
	}

	public static function fileForSymbol(symbol:Symbol):File {
		var filename:String = symbol.basename + '.hx';
		return Path.of(filename).toFile();
	}

	public static function buildPackageNameForSymbol(symbol:Symbol):String {
		return 'package ' + symbol.name.substring(0, symbol.name.lastIndexOf('.')).toLowerCase() + ';\n\n';
	}

	public static function buildDescription(symbol:Symbol):String {
		var description:String = buildComment('', symbol.description);
		return description;
	}

	public static function buildComment(gaps:String, description:String):String {
		var comment = new StringBuf();
		comment.add('\n');
		comment.add('$gaps/**\n');
		comment.add('$gaps* ' + description + '\n');
		comment.add('$gaps*/\n');

		return comment.toString();
	}

	public static function determineType(type:String, ?isArgsFunction = false):String {
		var t:String = type;

		// SAP changed map to Object.<string,value>
		if(t.contains("Object.<") || t.contains("object.<"))
		{
			var types = t.split("<");
			types = types[1].split(",");

			var firstType = determineType(types[0]);
			var secondType = determineType(types[1].replace(">",""));

			t = 'Map<$firstType,$secondType>';
		}

		var isArray:Bool = false;
		if (t.indexOf('[') != -1) {
			isArray = true;
			t = t.replace('[]', '');
		}

		if (t.indexOf('module:') != -1 || checkCorrectName(t)) {
			t = findHaxeName(t);
		}

		if (t.indexOf('Promise.') != -1 || t.indexOf('promise.') != -1) {
			var promiseType = t.substring(t.indexOf('<') + 1, t.indexOf('>'));
			t = 'js.lib.Promise<' + determineType(promiseType) + '>';
		}

		var start = '';
		var end = '';
		if (isArgsFunction) {
			start = 'haxe.extern.EitherType<String,';
			end = '>';
		}

		switch (t) {
			case 'boolean' | 'Boolean':
				t = start + 'Bool' + end;
			case 'string' | 'String' | 'number':
				t = 'String';
			case 'int' | 'Int':
				t = start + 'Int' + end;
			case 'float' | 'Float':
				t = start + 'Float' + end;
			case 'object' | 'Object':
				t = start + 'Dynamic' + end;
			case 'function' | 'Function' | 'function()':
				t = '()->Void';
			case 'Promise':
				t = 'js.lib.Promise<>';
			case 'any' | 'Any' | 'map' | 'Map' | 'undefined' | 'null' | '*':
				t = 'Dynamic';
			case 'array' | 'Array':
				t = start + 'Array<Dynamic>' + end;
			case 'sap.m.ValueState':
				t = start + 'sap.ui.core.ValueState' + end;
			case 'HTMLElement':
				t = start + 'js.html.HtmlElement' + end;
			case 'Element':
				t = start + 'js.html.Element' + end;
			case 'jQuery':
				t = 'Dynamic';
			case 'sap.ui.core.Configuration.FormatSettings':
				t = start + 'sap.ui.core.configuration.FormatSettings' + end;
			case 'sap.ui.core.Configuration.AnimationMode':
				t = start + 'sap.ui.core.configuration.AnimationMode' + end;

			default:
				if (isArgsFunction)
					t = start + t + end;
		}
		if (isArray) {
			t = 'Array<$t>';
		}

		return t;
	}

	public static function isLowerCase(char:String):Bool {
		var alphabet:String = 'abcdefghijklmnopqrstuvwxyz';
		if (alphabet.indexOf(char) != 1)
			return true;

		return false;
	}
}
