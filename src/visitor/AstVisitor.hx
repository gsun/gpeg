package visitor;

import stmt.Stmt;

class AstVisitor {
	var stmt:Stmt;

	public function new() {
		stmt = null;
	}

	public function visit(stmt:Stmt, params:Dynamic) {
		this.stmt = stmt;
		var method = Reflect.field(this, stmt.type);
		if (method != null) {
			Reflect.callMethod(this, method, [stmt, params]);
		}

		for (s in stmt.getSubs()) {
			visit(s);
		}
	}

	function assertTrue(b:Bool, msg:String) {
		if (b != true) {
			trace('${msg} in ${stmt}');
		}
	}

	function assertFalse(b:Bool, msg:String) {
		if (b == true) {
			trace('${msg} in ${stmt}');
		}
	}

	function assertEquals<T>(expected:T, actual:T, msg:String) {
		if (expected != actual) {
			trace('${msg} in ${stmt}');
		}
	}
}
