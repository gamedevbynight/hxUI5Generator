package builder;

import apimodel.Symbol;

class ArgsBuilder implements IBuilder {
	public function new() {}

	public function build(symbol:Symbol):String {
		var args:String = '';
		args += 'typedef ' + symbol.basename + 'Args = {\n';
		args += addExtending(symbol);
		args += addSpecialFields(symbol);
		args += addProperties(symbol);
		args += addAggregations(symbol);
		args += addAssociations(symbol);
		args += addEvents(symbol);
		args += '}\n';

		return args;
	}

	function addSpecialFields(symbol:Symbol):String
	{
		var args:String = '';
		if(symbol.basename == 'ManagedObject')
		{
			args += '@:optional var id : sap.ui.core.ID;';
		}
		return args;
	}

	function addExtending(symbol:Symbol):String {
		var extending:String = '';
		if (symbol.extending != null && symbol.basename != 'ManagedObject') {
			extending += '	> ' + symbol.extending + symbol.extending.substring(symbol.extending.lastIndexOf('.')) + 'Args ,\n';
		}

		return extending;
	}

	function addProperties(symbol:Symbol):String {
		var properties:String = '';
		if (symbol.ui5metadata != null) {
			if (symbol.ui5metadata.properties != null) {
				for (property in symbol.ui5metadata.properties) {
					if (property.deprecated == null) {
						properties += Tools.buildComment('	', property.description);
						properties += '	@:optional var ' + property.name + ':' + Tools.determineType(property.type) + ';\n';
					}
				}
			}
		}
		return properties;
	}

	function addAggregations(symbol:Symbol):String {
		var aggregations:String = '';
		if (symbol.ui5metadata != null && symbol.ui5metadata.aggregations != null) {
			for (aggregation in symbol.ui5metadata.aggregations) {
				if (aggregation.deprecated == null) {
					aggregations += Tools.buildComment('    ', aggregation.description);
					if (aggregation.cardinality != '0..n') {
						aggregations += '	@:optional var ' + aggregation.name + ':' + Tools.determineType(aggregation.type) + ';\n';
					} else {
						aggregations += '	@:optional var ' + aggregation.name + ':' + Tools.determineType(aggregation.type + '[]') + ';\n';
					}
				}
			}
		}
		return aggregations;
	}

	// TODO werden keine Arrays zum Beispiel columns bei sap.m.Table
	function addAssociations(symbol:Symbol):String {
		var associations:String = '';
		if (symbol.ui5metadata != null && symbol.ui5metadata.associations != null) {
			for (assosication in symbol.ui5metadata.associations) {
				if (assosication.deprecated == null) {
					associations += Tools.buildComment('	', assosication.description);
					if (assosication.cardinality != '0..n') {
						associations += '	@:optional var ' + assosication.name + ':' + Tools.determineType(assosication.type) + ';\n';
					} else {
						associations += '	@:optional var ' + assosication.name + ':' + Tools.determineType(assosication.type + '[]') + ';\n';
					}
				}
			}
		}
		return associations;
	}

	function addEvents(symbol:Symbol):String {
		var events:String = '';
		if (symbol.events != null) {
			for (event in symbol.events) {
				if (event.deprecated == null) {
					events += Tools.buildComment('	', event.description);
					events += '	@:optional var ' + event.name + ':(';
					for (param in event.parameters) {
						events += param.name + ':' + Tools.determineType(param.type);
						if (event.parameters.indexOf(param) != event.parameters.length - 1) {
							events += ',';
						}
					}
					events += ')->Void;\n';
				}
			}
		}
		return events;
	}
}
