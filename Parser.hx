package;

import tink.cli.*;
import tink.Cli;
import moon.peg.grammar.ParserBuilder;

class Parser {
	static function main() {
		Cli.process(Sys.args(), new Command()).handle(Cli.exit);
	}
}

@:alias(false)
class Command {
	@:flag('in-file')
	public var inflie:String;
	
	@:flag('out-class-name')
	public var outclassname:String;
	
	public function new() {}
	
	@:defaultCommand
	public function run(rest:Rest<String>) {
		ParserBuilder.generate(inflie, outclassname, null);
	}
}