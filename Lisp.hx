package ;

import moon.peg.grammar.Rule;
import moon.peg.grammar.Stream;
import moon.peg.grammar.ParseTree;

/**
 * Lisp
 * Auto-generated from ParserBuilder
 * 
 * @author Munir Hussin
 */
class Lisp
{
    public var rules:Map<String, Rule>;
    
    public function new()
    {
        rules =
        [
            "#start" => Anon(Id("start")),
            "int" => Rx("(-?[0-9]+)", ""),
            "expr" => Anon(Or(Transform(Seq(Id("expr1"), Seq(Hide(Str(":")), Id("expr"))), Id("cons")), Id("expr1"))),
            "objdef" => Anon(Transform(Seq(Id("__"), Seq(Or(Id("string"), Transform(Id("symbol"), Id("quote"))), Seq(Id("__"), Seq(Hide(Str(":")), Seq(Id("__"), Seq(Id("expr"), Id("__"))))))), Id("cons"))),
            "_" => Anon(Hide(Rx("[ \\t\\n\\r]*", ""))),
            "hex" => Rx("0x[0-9A-F]+", "i"),
            "null" => Str("null"),
            "__" => Anon(ZeroOrMore(Hide(Or(Id("comment"), Id("_"))))),
            "float" => Rx("([-+]?((\\d*\\.\\d+)([eE][-+]?\\d+)?|(\\d+)([eE][-+]?\\d+)))", ""),
            "true" => Str("true"),
            "symbol" => Rx("((?!\\/\\/|\\/\\*)[^\\s\\n\\r\\t\\(\\)\\[\\]{}'`,@.:])+", ""),
            "false" => Str("false"),
            "string" => Transform(Seq(Hide(Str("\"")), Seq(Transform(Rx("^([^\"\\\\]*(?:\\\\.[^\"\\\\]*)*)\"", ""), Num(1)), Hide(Str("\"")))), Num(1)),
            "object" => Seq(Hide(Str("{")), Seq(ZeroOrMore(Id("objdef")), Hide(Str("}")))),
            "comment" => Anon(Or(Id("block_comment"), Id("inline_comment"))),
            "inline_comment" => Anon(Rx("(\\/\\/.*)$", "m")),
            "expr1" => Anon(Or(Seq(Ahead(Id("float")), Id("float")), Or(Transform(Seq(Id("expr1"), Seq(Hide(Str(".")), Id("expr2"))), Id("field")), Id("expr2")))),
            "block_comment" => Anon(Rx("(\\/\\*([\\d\\D]*?)\\*\\/)", "")),
            "start" => Anon(ZeroOrMore(Id("expr"))),
            "list" => Seq(Hide(Str("(")), Seq(ZeroOrMore(Id("expr")), Hide(Str(")")))),
            "array" => Seq(Hide(Str("[")), Seq(ZeroOrMore(Id("expr")), Hide(Str("]")))),
            "expr2" => Anon(Transform(Seq(Id("__"), Seq(Id("primary"), Id("__"))), Num(1))),
            "primary" => Anon(Or(Transform(Transform(Seq(Hide(Str("'")), Id("expr")), Num(1)), Id("quote")), Or(Transform(Transform(Seq(Hide(Str("`")), Id("expr")), Num(1)), Id("backquote")), Or(Transform(Transform(Seq(Hide(Str(",@")), Id("expr")), Num(1)), Id("expand")), Or(Transform(Transform(Seq(Hide(Str(",")), Id("expr")), Num(1)), Id("unquote")), Or(Id("true"), Or(Id("false"), Or(Id("null"), Or(Id("int"), Or(Id("float"), Or(Id("string"), Or(Id("list"), Or(Id("array"), Or(Id("object"), Id("symbol")))))))))))))))
        ];
        initCache();
    }
    
    
    public function parse(text:String, ?id:String):ParseTree
    {
        if (id == null) id = "#start";
        var stream:Stream = new Stream(text, rules);
        return stream.match(id);
    }
}