import haxe.macro.Context;
import haxe.macro.Expr;
using Lambda;

class MyMacros {
   macro static public function initLocals():Expr {
    // Grab the variables accessible in the context the macro was called.
    var locals = Context.getLocalVars();
    var fields = Context.getLocalClass().get().fields.get();

    var exprs:Array<Expr> = [];
    for (local in locals.keys()) {
      if (fields.exists(function(field) return field.name == local)) {
        exprs.push(macro this.$local = $i{local});
      } else {
        throw new Error(Context.getLocalClass() + " has no field " + local, Context.currentPos());
      }
    }
    // Generates a block expression from the given expression array 
    return macro $b{exprs};
  }
}