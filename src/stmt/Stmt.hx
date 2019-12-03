package stmt;

class Stmt {
	var raw:StmtRaw;

	public var type(get, never):String;

	function get_type() {
		return raw.type;
	}

	public var location(get, never):Location;

	function get_location() {
		return raw.location;
	}

	public var parent:Stmt;

	var children:List<Stmt>;

	public function getSubs(type:String = null):List<Stmt> {
		return (type == null) ? children : children.filter(function(ch) {
			return ch.type == type;
		});
	}

	public function addSub(sub:Stmt) {
		sub.parent = this;
		children.add(sub);
	}

	public function new(r:StmtRaw) {
		raw = r;
		parent = null;
		children = new List();
	}

	static public function buildStmt(raw:StmtRaw):Stmt {
		switch raw.type {
			case "grammer":
				{
					var stmt = new GrammerStmt(r);
					if (raw.initializer != null)
						stmt.initializer = buildStmt(raw.initializer);
					for (s in raw.rules) {
						stmt.addSub(buildStmt(s));
					}
					return stmt;
				}
			case "initializer":
				{
					var stmt = new InitializerStmt(r);
					if (raw.code != null)
						stmt.code = raw.code;
					return stmt;
				}
			case "rule":
				{
					var stmt = new RuleStmt(r);
					if (raw.name != null)
						stmt.name = raw.name;
					if (raw.expression != null)
						stmt.addSub(buildStmt(raw.expression));
					return stmt;
				}
			case "named":
				{
					var stmt = new NamedStmt(r);
					if (raw.name != null)
						stmt.name = raw.name;
					if (raw.expression != null)
						stmt.addSub(buildStmt(raw.expression));
					return stmt;
				}
			case "action":
				{
					var stmt = new ActionStmt(r);
					if (raw.code != null)
						stmt.code = raw.code;
					if (raw.expression != null)
						stmt.addSub(buildStmt(raw.expression));
					return stmt;
				}
			case "choice":
				{
					var stmt = new Stmt(r);
					for (s in raw.alternatives) {
						stmt.addSub(buildStmt(s));
					}
					return stmt;
				}
			case "sequence":
				{
					var stmt = new Stmt(r);
					for (s in raw.elements) {
						stmt.addSub(buildStmt(s));
					}
					return stmt;
				}
			case "labeled":
				{
					var stmt = new LabeledStmt(r);
					if (raw.label != null)
						stmt.label = raw.label;
					return stmt;
				}
			case "literal":
				{
					var stmt = new LiteralStmt(r);
					if (raw.value != null)
						stmt.value = raw.value;
					if (raw.ignoreCase != null)
						stmt.ignoreCase = raw.ignoreCase;
					return stmt;
				}
			case "rule_ref":
				{
					var stmt = new RuleRefStmt(r);
					if (raw.name != null)
						stmt.name = raw.name;
					return stmt;
				}
			case "class":
				{
					var stmt = new ClassStmt(r);
					if (raw.ignoreCase != null)
						stmt.ignoreCase = raw.ignoreCase;
					if (raw.inverted != null)
						stmt.inverted = raw.inverted;
					if (raw.parts != null)
						stmt.parts = raw.parts;
					return stmt;
				}
			case "group" | "optional" | "zero_or_more" | "one_or_more" | "text" | "simple_and" | "simple_not":
				{
					var stmt = new Stmt(r);
					if (raw.expression != null)
						stmt.addSub(buildStmt(raw.expression));
					return stmt;
				}
			default:
				throw 'unknown ${raw.type} statement';
		}
	}
}
