require File.join(File.dirname(__FILE__), 'spec_helper')

describe PHP::Generator do
  context "literals" do
    it "should support null literals" do
      phpize('nil').should == 'NULL'
      phpize{ nil }.should == 'NULL'
    end

    it "should support boolean literals" do
      phpize('false').should == 'FALSE'
      phpize{ false }.should == 'FALSE'
      phpize('true').should  == 'TRUE'
      phpize{ true }.should  == 'TRUE'
    end

    it "should support integer literals" do
      phpize('42').should == '42'
      phpize{ 42 }.should == '42'
    end

    it "should support float literals" do
      phpize('3.1415').should == '3.1415'
      phpize{ 3.1415 }.should == '3.1415'
    end

    it "should support string literals" do
      phpize("''").should == '""'
      phpize{ '' }.should == '""'
      phpize('""').should == '""'
      phpize{ "" }.should == '""'
      phpize("'Hello, world!'").should == '"Hello, world!"'
      phpize{ 'Hello, world!' }.should == '"Hello, world!"'
    end

    it "should support interpolated string literals" do
      phpize('"#{$url}"').should == '$url'
      phpize{ "#{$url}" }.should == '$url'
      phpize('"<#{$url}>"').should == '"<" . $url . ">"'
      phpize{ "<#{$url}>" }.should == '"<" . $url . ">"'
      phpize('"#{$prefix}:#{$body}:#{$suffix}"').should == '$prefix . ":" . $body . ":" . $suffix'
      phpize{ "#{$prefix}:#{$body}:#{$suffix}" }.should == '$prefix . ":" . $body . ":" . $suffix'
    end

    it "should support numeric range literals" do
      phpize('(1..10)').should == 'range(1, 10)'
      phpize{ (1..10) }.should == 'range(1, 10)'
      phpize('(1...10)').should == 'range(1, 9)'
      phpize{ (1...10) }.should == 'range(1, 9)'
    end

    it "should support regular expression literals" do
      phpize('/a-z/').should == "'/a-z/'"
      phpize{ /a-z/ }.should == "'/a-z/'"
      phpize('/\w+/').should == "'/\\w+/'"
      phpize{ /\w+/ }.should == "'/\\w+/'"
    end

    it "should support array literals" do
      phpize('[]').should == 'array()'
      phpize{ [] }.should == 'array()'
      phpize('[1, 2, 3]').should == 'array(1, 2, 3)'
      phpize{ [1, 2, 3] }.should == 'array(1, 2, 3)'
    end

    it "should support associative array literals" do
      phpize('{}').should == 'array()'
      phpize{ {} }.should == 'array()'
      phpize('{"a" => 1, "b" => 2, "c" => 3}').should == 'array("a" => 1, "b" => 2, "c" => 3)'
      phpize{ {"a" => 1, "b" => 2, "c" => 3} }.should == 'array("a" => 1, "b" => 2, "c" => 3)'
    end
  end

  context "identifiers" do
    it "should support identifiers" do
      phpize(':foo').should == 'foo'
      phpize{ :foo }.should == 'foo'
    end
  end

  #context "global variables" do
  #  it "should support global variables" do
  #    phpize('$foo').should == "$GLOBALS['foo']"
  #    phpize{ $foo }.should == "$GLOBALS['foo']"
  #  end
  #
  #  it "should support global variable assignments" do
  #    phpize('$foo = 123').should == "$GLOBALS['foo'] = 123"
  #    phpize{ $foo = 123 }.should == "$GLOBALS['foo'] = 123"
  #  end
  #end

  context "local variables" do
    it "should support local variables" do
      phpize('$foo').should == '$foo'
      phpize{ $foo }.should == '$foo'
    end

    it "should support local variable assignments" do
      phpize('$foo = 123').should == "$foo = 123"
      phpize{ $foo = 123 }.should == "$foo = 123"
    end
  end

  context "anonymous functions" do
    it "should support functions of zero parameters" do
      phpize('lambda {}').should == 'function() {}'
      phpize{ lambda {} }.should == 'function() {}'
    end

    it "should support functions of one parameter" do
      phpize('lambda { |x| }').should == 'function($x) {}'
      phpize{ lambda { |x| } }.should == 'function($x) {}'
      phpize('lambda { |$x| }').should == 'function($x) {}'
      phpize{ lambda { |$x| } }.should == 'function($x) {}'
    end

    it "should support functions of many parameters" do
      phpize('lambda { |x, y| }').should == 'function($x, $y) {}'
      phpize{ lambda { |x, y| } }.should == 'function($x, $y) {}'
      phpize('lambda { |$x, $y| }').should == 'function($x, $y) {}'
      phpize{ lambda { |$x, $y| } }.should == 'function($x, $y) {}'
    end

    #it "should support functions of variable arity" # TODO
  end

  context "named functions" do
    it "should support functions of zero parameters" do
      phpize('def foo; end').should == 'function foo() {}'
      phpize{ def foo; end }.should == 'function foo() {}'
      phpize('def foo(); end').should == 'function foo() {}'
      phpize{ def foo(); end }.should == 'function foo() {}'
    end

    it "should support functions of one parameter" do
      phpize('def foo(x); end').should == 'function foo($x) {}'
      phpize{ def foo(x); end }.should == 'function foo($x) {}'
    end

    it "should support functions of many parameters" do
      phpize('def foo(x, y); end').should == 'function foo($x, $y) {}'
      phpize{ def foo(x, y); end }.should == 'function foo($x, $y) {}'
    end

    #it "should support functions of variable arity" # TODO
  end

  context "function calls" do
    it "should support function calls with zero arguments" do
      phpize('time').should == 'time()'
      phpize{ time }.should == 'time()'
    end

    it "should support function calls with one argument" do
      phpize('inc(1)').should == 'inc(1)'
      phpize{ inc(1) }.should == 'inc(1)'
    end

    it "should support function calls with many arguments" do
      phpize('max(1, 2)').should == 'max(1, 2)'
      phpize{ max(1, 2) }.should == 'max(1, 2)'
    end

    #it "should support function calls with splat arguments" # TODO
  end

  context "interfaces" do
    it "should support interfaces" do
      phpize('module Foo; end').should == 'interface Foo {}'
      phpize{ module Foo; end }.should == 'interface Foo {}'
    end
  end

  context "classes" do
    it "should support classes without a parent class" do
      phpize('class Foo; end').should == 'class Foo {}'
      phpize{ class Foo; end }.should == 'class Foo {}'
    end

    it "should support classes with a parent class" do
      phpize('class Foo < Bar; end').should == 'class Foo extends Bar {}'
      phpize{ class Foo < Bar; end }.should == 'class Foo extends Bar {}'
    end
  end

  context "static method calls" do
    #it "should support static method calls" # TODO
  end

  context "instance method calls" do
    it "should support instance method calls" do
      phpize('$object.method').should == '$object->method()'
      phpize{ $object.method }.should == '$object->method()'
    end
  end

  context "string operators" do
    it "should support the . (concatenation) operator" do
      phpize('"123" << "456"').should == '"123" . "456"'
      phpize{ "123" << "456" }.should == '"123" . "456"'
    end
  end

  context "arithmetic operators" do
    it "should support the - (negation) operator" do
      phpize('-1').should == '-1'
      phpize{ -1 }.should == '-1'
      phpize('-$a').should == '-$a'
      phpize{ -$a }.should == '-$a'
    end

    it "should support the + (addition) operator" do
      phpize('6 + 7').should == '6 + 7'
      phpize{ 6 + 7 }.should == '6 + 7'
      phpize('$a + $b').should == '$a + $b'
      phpize{ $a + $b }.should == '$a + $b'
    end

    it "should support the - (subtraction) operator" do
      phpize('6 - 7').should == '6 - 7'
      phpize{ 6 - 7 }.should == '6 - 7'
      phpize('$a - $b').should == '$a - $b'
      phpize{ $a - $b }.should == '$a - $b'
    end

    it "should support the * (multiplication) operator" do
      phpize('6 * 7').should == '6 * 7'
      phpize{ 6 * 7 }.should == '6 * 7'
      phpize('$a * $b').should == '$a * $b'
      phpize{ $a * $b }.should == '$a * $b'
    end

    it "should support the / (division) operator" do
      phpize('6 / 7').should == '6 / 7'
      phpize{ 6 / 7 }.should == '6 / 7'
      phpize('$a / $b').should == '$a / $b'
      phpize{ $a / $b }.should == '$a / $b'
    end

    it "should support the % (modulus) operator" do
      phpize('6 % 7').should == '6 % 7'
      phpize{ 6 % 7 }.should == '6 % 7'
      phpize('$a % $b').should == '$a % $b'
      phpize{ $a % $b }.should == '$a % $b'
    end
  end

  context "assignment operators" do
    it "should support the = (assignment) operator" do
      phpize('$x = 42').should == '$x = 42'
      phpize{ $x = 42 }.should == '$x = 42'
      phpize('$a = $b').should == '$a = $b'
      phpize{ $a = $b }.should == '$a = $b'
    end
  end

  context "bitwise operators" do
    it "should support the ~ (bitwise not) operator" do
      phpize('~1').should == '~1'
      phpize{ ~1 }.should == '~1'
      phpize('~$x').should == '~$x'
      phpize{ ~$x }.should == '~$x'
    end

    it "should support the & (bitwise and) operator" do
      phpize('1 & 0').should == '1 & 0'
      phpize{ 1 & 0 }.should == '1 & 0'
      phpize('$a & $b').should == '$a & $b'
      phpize{ $a & $b }.should == '$a & $b'
    end

    it "should support the | (bitwise or) operator" do
      phpize('1 | 0').should == '1 | 0'
      phpize{ 1 | 0 }.should == '1 | 0'
      phpize('$a | $b').should == '$a | $b'
      phpize{ $a | $b }.should == '$a | $b'
    end

    it "should support the ^ (bitwise xor) operator" do
      phpize('1 ^ 0').should == '1 ^ 0'
      phpize{ 1 ^ 0 }.should == '1 ^ 0'
      phpize('$a ^ $b').should == '$a ^ $b'
      phpize{ $a ^ $b }.should == '$a ^ $b'
    end

    #it "should support the << (bitwise left shift) operator" # TODO

    it "should support the >> (bitwise right shift) operator" do
      phpize('8 >> 2').should == '8 >> 2'
      phpize{ 8 >> 2 }.should == '8 >> 2'
      phpize('$a >> $b').should == '$a >> $b'
      phpize{ $a >> $b }.should == '$a >> $b'
    end
  end

  context "comparison operators" do
    it "should support the == (equal to) operator" do
      phpize('$a == $b').should == '$a == $b'
      phpize{ $a == $b }.should == '$a == $b'
    end

    it "should support the === (identical to) operator" do
      phpize('$a === $b').should == '$a === $b'
      phpize{ $a === $b }.should == '$a === $b'
    end

    it "should support the != (not equal to) operator" do
      phpize('$a != $b').should == '$a != $b'
      phpize{ $a != $b }.should == '$a != $b'
    end

    it "should support the !== (not identical to) operator" do
      # NOTE: the following is not valid Ruby syntax, unfortunately:
      #phpize('$a !== $b').should == '$a !== $b'
      #phpize{ $a !== $b }.should == '$a !== $b'
    end

    it "should support the < (less than) operator" do
      phpize('$a < $b').should == '$a < $b'
      phpize{ $a < $b }.should == '$a < $b'
    end

    it "should support the > (greater than) operator" do
      phpize('$a > $b').should == '$a > $b'
      phpize{ $a > $b }.should == '$a > $b'
    end

    it "should support the <= (less than or equal to) operator" do
      phpize('$a <= $b').should == '$a <= $b'
      phpize{ $a <= $b }.should == '$a <= $b'
    end

    it "should support the >= (greater than or equal to) operator" do
      phpize('$a >= $b').should == '$a >= $b'
      phpize{ $a >= $b }.should == '$a >= $b'
    end
  end

  context "execution operators" do
    it "should support the `` (backticks) operator" do
      phpize('`hostname`').should == '`hostname`'
      phpize{ `hostname` }.should == '`hostname`'
    end
  end

  context "logical operators" do
    it "should support the ! (logical not) operator" do
      phpize('!true').should == '!TRUE'
      phpize{ !true }.should == '!TRUE'
      phpize('!$a').should == '!$a'
      phpize{ !$a }.should == '!$a'
    end

    it "should support the && (logical and) operator" do
      phpize('true && false').should == 'TRUE && FALSE'
      phpize{ true && false }.should == 'TRUE && FALSE'
      phpize('$a and $b').should == '$a && $b'
      phpize{ $a and $b }.should == '$a && $b'
      phpize('$a && $b').should == '$a && $b'
      phpize{ $a && $b }.should == '$a && $b'
    end

    it "should support the || (logical or) operator" do
      phpize('true || false').should == 'TRUE || FALSE'
      phpize{ true || false }.should == 'TRUE || FALSE'
      phpize('$a or $b').should == '$a || $b'
      phpize{ $a or $b }.should == '$a || $b'
      phpize('$a || $b').should == '$a || $b'
      phpize{ $a || $b }.should == '$a || $b'
    end
  end

  context "control structures" do
    it "should support if statement modifiers" do
      phpize('return if true').should == 'if (TRUE) { return; }'
      phpize{ return if true }.should == 'if (TRUE) { return; }'
    end

    it "should support if statements with an empty then branch" do
      phpize('if true then end').should == 'if (TRUE) {}'
      phpize{ if true then end }.should == 'if (TRUE) {}'
    end

    it "should support if statements with a then branch" do # FIXME
      phpize('if true then 1 end').should == 'if (TRUE) { 1; }'
      phpize{ if true then 1 end }.should == 'if (TRUE) { 1; }'
    end

    it "should support if statements with both then/else branches" do # FIXME
      phpize('if true then 1 else 0 end').should == 'if (TRUE) { 1; } else { 0; }'
      phpize{ if true then 1 else 0 end }.should == 'if (TRUE) { 1; } else { 0; }'
    end

    #it "should support if/elseif statements" # TODO

    it "should support unless statement modifiers" do
      phpize('return unless true').should == 'if (!TRUE) { return; }'
      phpize{ return unless true }.should == 'if (!TRUE) { return; }'
    end

    it "should support unless statements with an empty then branch" do
      # FIXME: the parse tree for this is at present indistinguishable from
      # "if true then end", so there probably is a bug in RubyParser:
      #phpize('unless true then end').should == 'if (!TRUE) {}'
      #phpize{ unless true then end }.should == 'if (!TRUE) {}'
    end

    it "should support unless statements" do
      phpize('unless true  then 0 end').should == 'if (!TRUE) { 0; }'
      phpize{ unless true  then 0 end }.should == 'if (!TRUE) { 0; }'
      phpize('unless false then 1 end').should == 'if (!FALSE) { 1; }'
      phpize{ unless false then 1 end }.should == 'if (!FALSE) { 1; }'
    end

    it "should support unless/else statements" do # FIXME
      phpize('unless false then 1 else 0 end').should == 'if (FALSE) { 0; } else { 1; }'
      phpize{ unless false then 1 else 0 end }.should == 'if (FALSE) { 0; } else { 1; }'
    end

    it "should support while statements" do
      phpize('while true; sleep 1; end').should == 'while (TRUE) { sleep(1); }'
      phpize{ while true; sleep 1; end }.should == 'while (TRUE) { sleep(1); }'
    end

    it "should support until statements" do
      phpize('until true; sleep 1; end').should == 'while (!TRUE) { sleep(1); }'
      phpize{ until true; sleep 1; end }.should == 'while (!TRUE) { sleep(1); }'
    end

    #it "should support do-while statements" # TODO

    it "should support for statements" do
      phpize('for $x in [1, 2, 3]; echo $x; end').should == 'foreach (array(1, 2, 3) as $x) { echo($x); }'
      phpize{ for $x in [1, 2, 3]; echo $x; end }.should == 'foreach (array(1, 2, 3) as $x) { echo($x); }'
      phpize('for $k, $v in {"a" => 1}; echo $k << $v; end').should == 'foreach (array("a" => 1) as $k => $v) { echo($k . $v); }'
      phpize{ for $k, $v in {"a" => 1}; echo $k << $v; end }.should == 'foreach (array("a" => 1) as $k => $v) { echo($k . $v); }'
    end

    #it "should support break statements"    # TODO
    #it "should support continue statements" # TODO

    it "should support return statements" do
      phpize('return').should == 'return'
      phpize{ return }.should == 'return'
      phpize('return nil').should == 'return NULL'
      phpize{ return nil }.should == 'return NULL'
      phpize('return true').should == 'return TRUE'
      phpize{ return true }.should == 'return TRUE'
      phpize('return 42').should == 'return 42'
      phpize{ return 42 }.should == 'return 42'
    end

    #it "should support switch statements"   # TODO
  end

  context "regular expressions" do
    it "should support positive matches" do
      phpize('/^\d+$/ =~ "123"').should == %q(preg_match('/^\d+$/', "123"))
      phpize('"123" =~ /^\d+$/').should == %q(preg_match('/^\d+$/', "123"))
      phpize('$pattern =~ $string').should == %q(preg_match($pattern, $string))
    end

    it "should support negative matches" do
      phpize('/^\d+$/ !~ "123"').should == %q(!preg_match('/^\d+$/', "123"))
      phpize('"123" !~ /^\d+$/').should == %q(!preg_match('/^\d+$/', "123"))
      phpize('$pattern !~ $string').should == %q(!preg_match($pattern, $string))
    end
  end

  def phpize(input = nil, &block)
    if block_given?
      PHP::Generator.process(&block).to_s
    else
      PHP::Generator.process(input).to_s
    end
  end
end
