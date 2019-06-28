package builder;

import apimodel.Symbol;

class ArgsBuilder implements IBuilder {
	public function new() {}

	public function build(symbol:Symbol):String {
		var args = new StringBuf();
		args.add('');
		args.add('typedef ' + symbol.basename + 'Args = '); 
		args.add(addExtending(symbol));
		args.add('{\n');
		args.add(addSpecialFields(symbol));
		args.add(addProperties(symbol));
		args.add(addAggregations(symbol));
		args.add(addAssociations(symbol));
		args.add(addEvents(symbol));
		args.add('}\n');

		return args.toString();
	}

	function addSpecialFields(symbol:Symbol):String {
		var args:String = '';
		if (symbol.basename == 'ManagedObject') {
			args = '@:optional var id : sap.ui.core.ID;';
		}
		return args;
	}

	function addExtending(symbol:Symbol):String {
		var extending:String = '';
		if (symbol.extending != null && symbol.basename != 'ManagedObject') {
			extending = symbol.extending + symbol.extending.substring(symbol.extending.lastIndexOf('.')) + 'Args & ';
		}

		return extending;
	}

	function addProperties(symbol:Symbol):String {
		var properties = new StringBuf();
		if (symbol.ui5metadata != null) {
			if (symbol.ui5metadata.properties != null) {
				for (property in symbol.ui5metadata.properties) {
					if (property.deprecated == null) {
						properties.add(Tools.buildComment('	', property.description));
						properties.add('	@:optional var ' + property.name + ':' + Tools.determineType(property.type, true) + ';\n');
					}
				}
			}
		}
		return properties.toString();
	}

	function addAggregations(symbol:Symbol):String {
		var aggregations= new StringBuf();
		if (symbol.ui5metadata != null && symbol.ui5metadata.aggregations != null) {
			for (aggregation in symbol.ui5metadata.aggregations) {
				if (aggregation.deprecated == null) {
					aggregations.add(Tools.buildComment('    ', aggregation.description));
					if (aggregation.cardinality != '0..n') {
						aggregations.add('	@:optional var ' + aggregation.name + ':' + Tools.determineType(aggregation.type,true) + ';\n');
					} else {
						aggregations.add('	@:optional var ' + aggregation.name + ':' + Tools.determineType(aggregation.type + '[]',true) + ';\n');
					}
				}
			}
		}
		return aggregations.toString();
	}

	function addAssociations(symbol:Symbol):String {
		var associations = new StringBuf();
		if (symbol.ui5metadata != null && symbol.ui5metadata.associations != null) {
			for (assosication in symbol.ui5metadata.associations) {
				if (assosication.deprecated == null) {
					associations.add(Tools.buildComment('	', assosication.description));
					if (assosication.cardinality != '0..n') {
						associations.add('	@:optional var ' + assosication.name + ':' + Tools.determineType(assosication.type,true) + ';\n');
					} else {
						associations.add('	@:optional var ' + assosication.name + ':' + Tools.determineType(assosication.type + '[]',true) + ';\n');
					}
				}
			}
		}
		return associations.toString();
	}

	function addEvents(symbol:Symbol):String {
		var events = new StringBuf();
		if (symbol.events != null) {
			for (event in symbol.events) {
				if (event.deprecated == null) {
					events.add(Tools.buildComment('	', event.description));
					events.add('	@:optional var ' + event.name + ':(');
					for (param in event.parameters) {
						events.add(param.name + ':' + Tools.determineType(param.type,true));
						if (event.parameters.indexOf(param) != event.parameters.length - 1) {
							events.add(',');
						}
					}
					events.add(')->Void;\n');
				}
			}
		}
		return events.toString();
	}
}
