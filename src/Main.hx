import apimodel.Symbol;
import hx.files.*;
import apimodel.Overview;
import json2object.JsonParser;
import sys.Http;
import builder.*;

using StringTools;

class Main {
	public static var API:String = '/designtime/api.json';

	var url:String;
	var path:String;
	var enumBuilder:EnumBuilder;
	var interfaceBuilder:InterfaceBuilder;
	var namespaceBuilder:NamespaceBuilder;
	var classBuilder:ClassBuilder;
	var sapM:String;
	var sapTnt:String;
	var sapF:String;
	var sapCore:String;
	var sapUxap:String;
	var sapUiCommons:String;
	var sapUiLayout:String;
	var sapUiTable:String;
	var sapUiUnified:String;
	var sapUiIntegration:String;
	var sapUiCodeeditor:String;

	static function main() {
		new Main();
	}

	public function new() {
		enumBuilder = new EnumBuilder();
		namespaceBuilder = new NamespaceBuilder();
		interfaceBuilder = new InterfaceBuilder();
		classBuilder = new ClassBuilder();
		url = Sys.args()[0];
		path = Sys.args()[1];

		sapM = url + 'm' + API;
		sapTnt = url + 'tnt' + API;
		sapF = url + 'f' + API;
		sapCore = url + 'ui/core' + API;
		sapUxap = url + 'uxap' + API;
		sapUiCommons = url + 'ui/commons' + API;
		sapUiLayout = url + 'ui/layout' + API;
		sapUiTable = url + 'ui/table' + API;
		sapUiUnified = url + 'ui/unified' + API;
		sapUiIntegration = url + 'ui/integration' + API;
		sapUiCodeeditor = url + 'ui/codeeditor' + API;

		var parser = new JsonParser<Overview>();

		createMainDirs();

		var version:String = "";


		if (Sys.args()[3] == null || Sys.args()[3] == 'm') {
			var overviewM = parser.fromJson(Http.requestUrl(sapM));
			createExterns(overviewM);
			version = overviewM.version;
		}

		if (Sys.args()[3] == null || Sys.args()[3] == 'tnt') {
			var overviewTnT = parser.fromJson(Http.requestUrl(sapTnt));
			createExterns(overviewTnT);
			version = overviewTnT.version;
		}

		if (Sys.args()[3] == null || Sys.args()[3] == 'f') {
			var overviewF = parser.fromJson(Http.requestUrl(sapF));
			createExterns(overviewF);
			version = overviewF.version;
		}

		if (Sys.args()[3] == null || Sys.args()[3] == 'core') {
			var overviewCore = parser.fromJson(Http.requestUrl(sapCore));
			createExterns(overviewCore);
			createExterns(parser.fromJson(Http.requestUrl(sapUiCodeeditor)));
			createExterns(parser.fromJson(Http.requestUrl(sapUiCommons)));
			createExterns(parser.fromJson(Http.requestUrl(sapUiIntegration)));
			createExterns(parser.fromJson(Http.requestUrl(sapUiLayout)));
			createExterns(parser.fromJson(Http.requestUrl(sapUiTable)));
			createExterns(parser.fromJson(Http.requestUrl(sapUiUnified)));
			version = overviewCore.version;

		}

		if (Sys.args()[3] == null || Sys.args()[3] == 'uxap') {
			var overviewUxap = parser.fromJson(Http.requestUrl(sapUxap));
			createExterns(overviewUxap);
			version = overviewUxap.version;
		}
		createReadme(version);
	}

	function createReadme(version:String):Void
	{
		createMainDirs();
		var readmeBuilder = new ReadMeBuilder();
		readmeBuilder.build(version);
	}

	function createMainDirs() {
		var p = Path.of(path);
		var srcDir = p.toDir();
		if (!p.exists()) {
			srcDir.create();
		}
		srcDir.setCWD();
	}

	function createExterns(overview:Overview) {
		clearSymbols(overview.symbols);
		if (Sys.args()[2] != null) {
			var symbol = overview.symbols[Std.parseInt(Sys.args()[2])];
			trace("Building: " + symbol.name);
			createFileForSymbol(symbol);
			createMainDirs();
		} else {
			for (symbol in overview.symbols) {
				if (symbol.name.indexOf('jQuery') == -1) {
						trace("Building: " + symbol.name);
						createFileForSymbol(symbol);
						createMainDirs();
				}
			}
		}
	}

	function clearSymbols(symbols:Array<Symbol>) {
		for (symbol in symbols) {
			if (symbol.name.indexOf("module:") != -1 || Tools.checkCorrectName(symbol.name)) {
				symbol.originalName = symbol.name;
				symbol.name = Tools.findHaxeName(symbol.name);
				symbol.basename = symbol.name.substring(symbol.name.lastIndexOf('.') + 1);
			}
		}
	}

	function createFileForSymbol(symbol:Symbol) {
		switch (symbol.kind) {
			case 'class':
				classBuilder.build(symbol);
			case 'enum':
				enumBuilder.build(symbol);
			case 'interface':
				interfaceBuilder.build(symbol);
			case 'namespace':
				namespaceBuilder.build(symbol);
			default: // nichts machen
		}
	}
}
