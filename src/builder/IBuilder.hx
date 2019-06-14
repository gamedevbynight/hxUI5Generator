package builder;

import apimodel.Symbol;

interface IBuilder {
    public function build(symbol:Symbol):String;
}