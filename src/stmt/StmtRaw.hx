package stmt;

typedef Loc = {
	var offset:Int;
	var line:Int;
	var column:Int;
}

typedef Location = {
	var start:Loc;
	var end:Loc;
}

typedef StmtRaw = {
	var type:String;
	var location:Location;
	@:optional var initializer:StmtRaw; // grammer
	@:optional var rules:Array<StmtRaw>; // grammer
	@:optional var name:String; // rule,named,rule_ref
	@:optional var value:String; // literal
	@:optional var code:String; // initializer,action,semantic_and,semantic_not
	@:optional var expression:StmtRaw; // rule,named,action,group,optional,zero_or_more,one_or_more,text,simple_and,simple_not
	@:optional var alternatives:Array<StmtRaw>; // choice
	@:optional var elements:Array<StmtRaw>; // sequence
	@:optional var label:String; // labeled
	@:optional var ignoreCase:Bool; // literal,class
	@:optional var inverted:Bool; // class
	@:optional var parts:Dynamic; // class
}
