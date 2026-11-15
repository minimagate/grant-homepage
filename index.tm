<TeXmacs|2.1.5>

<style|generic>

<\body>
  <\hide-preamble>
    <assign|sectional-normal-bold|<macro|name|<sectional-normal|<arg|name>>>>

    <assign|sectional-short-bold|<macro|name|<sectional-short|<with|font-shape|italic|<arg|name>>>>>

    <assign|doc-title-name|<macro|x|<arg|x>>>

    <assign|theorem-name|<macro|name|<with|font-shape|small-caps|<arg|name>>>>

    <assign|figure-name|<macro|name|<with|font-shape|small-caps|<arg|name>>>>
  </hide-preamble>

  <\center>
    <image|grant-mark.svg|2.4cm|||>
  </center>

  <doc-data|<doc-title|THE GRANT PROGRAMMING LANGUAGE>>

  <\abstract>
    A <em|world> is a finite relational structure, a state of data rather than a physical place: kinds of things, the things themselves, the facts that relate them, and the rules that make further facts follow. Grant is a small language in which every line states something about a world: a fact, a change, a definition or a question. Worlds are built on other worlds, and worlds are themselves things, so that one world can hold others and reason about them. This page gives the mathematical structure of Grant, explains how the language works, and collects what is needed to use its interpreter.
  </abstract>

  <section|Introduction>

  Grant rests on one act: <em|stating>. A world is made of what has been stated in it, and nothing else; its state is exactly its statements. Here is a small world.

  <\verbatim-code>
    from numbers

    \ 

    kind team

    kind feeling

    kind person [

    \ \ age: \ \ \ \ \ \ one number

    \ \ works_in: \ one team

    \ \ knows: \ \ \ \ person

    \ \ feels: \ \ \ \ feeling

    ]

    \ 

    team design

    team engineering

    feeling happy

    \ 

    person liz \ \ \ [ age: 27 \| works_in: design ]

    person laurie [ age: 30 \| works_in: engineering ]

    person harbor [ age: 24 \| works_in: design \| knows: liz, laurie ]

    harbor feels happy

    \ 

    rule mutual: person a knows person b if b knows a

    \ 

    ? liz.knows \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ -- harbor

    ? person p works_in design \ \ \ \ \ \ \ \ -- liz, harbor

    ? sum harbor.knows.age \ \ \ \ \ \ \ \ \ \ -- 57
  </verbatim-code>

  The first block declares three <em|kinds> and the <em|shape> of a person: every relation a person can have, how many values it holds, and of what kind. The second creates <em|objects> and states <em|facts> about them. The rule <verbatim|mutual> makes further facts follow: nobody stated that liz knows harbor, and yet she does. The last three lines are <em|questions>; they change nothing and show what holds. Figure <reference|fig-world> draws this world.

  <\big-figure|<with|gr-mode|<tuple|edit|line>|gr-frame|<tuple|scale|1cm|<tuple|0.5gw|0.5gh>>|gr-geometry|<tuple|geometry|13.2cm|6.9cm|center>|<graphics||<with|dash-style|10|color|black|<line|<point|-6.050|-0.800>|<point|-4.750|-0.800>>>|<with|dash-style|10|color|black|<line|<point|-4.500|-0.550>|<point|-4.500|0.550>>>|<with|dash-style|10|color|black|<line|<point|-4.750|0.800>|<point|-6.050|0.800>>>|<with|dash-style|10|color|black|<line|<point|-6.300|0.550>|<point|-6.300|-0.550>>>|<with|dash-style|10|color|black|<arc|<point|-4.750|-0.800>|<point|-4.573|-0.727>|<point|-4.500|-0.550>>>|<with|dash-style|10|color|black|<arc|<point|-4.500|0.550>|<point|-4.573|0.727>|<point|-4.750|0.800>>>|<with|dash-style|10|color|black|<arc|<point|-6.050|0.800>|<point|-6.227|0.727>|<point|-6.300|0.550>>>|<with|dash-style|10|color|black|<arc|<point|-6.300|-0.550>|<point|-6.227|-0.727>|<point|-6.050|-0.800>>>|<with|text-at-halign|center|text-at-valign|center|<text-at|<with|font-size|0.84|<with|font-shape|italic|feeling>>|<point|-5.400|1.080>>>|<with|dash-style|10|color|black|<line|<point|-3.450|-2.150>|<point|0.350|-2.150>>>|<with|dash-style|10|color|black|<line|<point|0.600|-1.900>|<point|0.600|1.900>>>|<with|dash-style|10|color|black|<line|<point|0.350|2.150>|<point|-3.450|2.150>>>|<with|dash-style|10|color|black|<line|<point|-3.700|1.900>|<point|-3.700|-1.900>>>|<with|dash-style|10|color|black|<arc|<point|0.350|-2.150>|<point|0.527|-2.077>|<point|0.600|-1.900>>>|<with|dash-style|10|color|black|<arc|<point|0.600|1.900>|<point|0.527|2.077>|<point|0.350|2.150>>>|<with|dash-style|10|color|black|<arc|<point|-3.450|2.150>|<point|-3.627|2.077>|<point|-3.700|1.900>>>|<with|dash-style|10|color|black|<arc|<point|-3.700|-1.900>|<point|-3.627|-2.077>|<point|-3.450|-2.150>>>|<with|text-at-halign|center|text-at-valign|center|<text-at|<with|font-size|0.84|<with|font-shape|italic|person>>|<point|-1.550|2.430>>>|<with|dash-style|10|color|black|<line|<point|2.450|-2.150>|<point|3.750|-2.150>>>|<with|dash-style|10|color|black|<line|<point|4.000|-1.900>|<point|4.000|1.900>>>|<with|dash-style|10|color|black|<line|<point|3.750|2.150>|<point|2.450|2.150>>>|<with|dash-style|10|color|black|<line|<point|2.200|1.900>|<point|2.200|-1.900>>>|<with|dash-style|10|color|black|<arc|<point|3.750|-2.150>|<point|3.927|-2.077>|<point|4.000|-1.900>>>|<with|dash-style|10|color|black|<arc|<point|4.000|1.900>|<point|3.927|2.077>|<point|3.750|2.150>>>|<with|dash-style|10|color|black|<arc|<point|2.450|2.150>|<point|2.273|2.077>|<point|2.200|1.900>>>|<with|dash-style|10|color|black|<arc|<point|2.200|-1.900>|<point|2.273|-2.077>|<point|2.450|-2.150>>>|<with|text-at-halign|center|text-at-valign|center|<text-at|<with|font-size|0.84|<with|font-shape|italic|team>>|<point|3.100|2.430>>>|<with|point-size|2.2ln|<point|-5.400|0.000>>|<with|point-size|2.2ln|<point|-2.700|0.000>>|<with|point-size|2.2ln|<point|-0.400|1.400>>|<with|point-size|2.2ln|<point|-0.400|-1.400>>|<with|point-size|2.2ln|<point|3.100|0.550>>|<with|point-size|2.2ln|<point|3.100|-1.400>>|<with|text-at-halign|center|text-at-valign|center|<text-at|<with|font-size|0.84|<verbatim|happy>>|<point|-5.400|-0.340>>>|<with|text-at-halign|center|text-at-valign|center|<text-at|<with|font-size|0.84|<verbatim|harbor>>|<point|-2.950|-0.360>>>|<with|text-at-halign|center|text-at-valign|center|<text-at|<with|font-size|0.84|<verbatim|liz>>|<point|-0.400|1.730>>>|<with|text-at-halign|center|text-at-valign|center|<text-at|<with|font-size|0.84|<verbatim|laurie>>|<point|-0.400|-1.750>>>|<with|text-at-halign|center|text-at-valign|center|<text-at|<with|font-size|0.84|<verbatim|design>>|<point|3.450|0.830>>>|<with|text-at-halign|center|text-at-valign|center|<text-at|<with|font-size|0.84|<verbatim|engineering>>|<point|3.100|-1.750>>>|<with|arrow-end|<tuple|<with|dash-style|none|<line|<tuple|-10ln|6ln>|<tuple|0ln|0ln>|<tuple|-10ln|-6ln>>>>|<line|<point|-2.860|0.000>|<point|-5.240|0.000>>>|<with|text-at-halign|center|text-at-valign|center|<text-at|<with|font-size|0.84|<with|font-shape|italic|feels>>|<point|-4.080|0.220>>>|<with|arrow-end|<tuple|<with|dash-style|none|<line|<tuple|-10ln|6ln>|<tuple|0ln|0ln>|<tuple|-10ln|-6ln>>>>|<line|<point|-2.600|0.143>|<point|-0.573|1.377>>>|<with|arrow-end|<tuple|<with|dash-style|none|<line|<tuple|-10ln|6ln>|<tuple|0ln|0ln>|<tuple|-10ln|-6ln>>>>|dash-style|11100|<line|<point|-0.500|1.257>|<point|-2.527|0.023>>>|<with|arrow-end|<tuple|<with|dash-style|none|<line|<tuple|-10ln|6ln>|<tuple|0ln|0ln>|<tuple|-10ln|-6ln>>>>|<line|<point|-2.600|-0.143>|<point|-0.573|-1.377>>>|<with|arrow-end|<tuple|<with|dash-style|none|<line|<tuple|-10ln|6ln>|<tuple|0ln|0ln>|<tuple|-10ln|-6ln>>>>|dash-style|11100|<line|<point|-0.500|-1.257>|<point|-2.527|-0.023>>>|<with|text-at-halign|center|text-at-valign|center|<text-at|<with|font-size|0.84|<with|font-shape|italic|knows>>|<point|-2.000|1.020>>>|<with|text-at-halign|center|text-at-valign|center|<text-at|<with|font-size|0.84|<with|font-shape|italic|knows>>|<point|-2.000|-1.020>>>|<with|arrow-end|<tuple|<with|dash-style|none|<line|<tuple|-10ln|6ln>|<tuple|0ln|0ln>|<tuple|-10ln|-6ln>>>>|<line|<point|-0.245|1.362>|<point|2.945|0.588>>>|<with|text-at-halign|center|text-at-valign|center|<text-at|<with|font-size|0.84|<with|font-shape|italic|works_in>>|<point|1.550|1.270>>>|<with|arrow-end|<tuple|<with|dash-style|none|<line|<tuple|-10ln|6ln>|<tuple|0ln|0ln>|<tuple|-10ln|-6ln>>>>|<line|<point|-0.240|-1.400>|<point|2.940|-1.400>>>|<with|text-at-halign|center|text-at-valign|center|<text-at|<with|font-size|0.84|<with|font-shape|italic|works_in>>|<point|1.350|-1.180>>>|<with|arrow-end|<tuple|<with|dash-style|none|<line|<tuple|-10ln|6ln>|<tuple|0ln|0ln>|<tuple|-10ln|-6ln>>>>|<line|<point|-2.541|0.015>|<point|2.941|0.535>>>|<with|text-at-halign|center|text-at-valign|center|<text-at|<with|font-size|0.84|<with|font-shape|italic|works_in>>|<point|0.750|0.080>>>|<with|arrow-end|<tuple|<with|dash-style|none|<line|<tuple|-10ln|6ln>|<tuple|0ln|0ln>|<tuple|-10ln|-6ln>>>>|<line|<point|-5.600|-3.000>|<point|-4.500|-3.000>>>|<with|text-at-halign|left|text-at-valign|center|<text-at|<with|font-size|0.84|stated: in <math|F>>|<point|-4.300|-3.000>>>|<with|arrow-end|<tuple|<with|dash-style|none|<line|<tuple|-10ln|6ln>|<tuple|0ln|0ln>|<tuple|-10ln|-6ln>>>>|dash-style|11100|<line|<point|-0.900|-3.000>|<point|0.200|-3.000>>>|<with|text-at-halign|left|text-at-valign|center|<text-at|<with|font-size|0.84|derived by <verbatim|mutual>: in <math|D>>|<point|0.400|-3.000>>>>>>
    <label|fig-world>The world above. Dots are objects, dashed regions are kinds, arrows are facts. The two dashed arrows were never stated: they follow from the rule <verbatim|mutual>.
  </big-figure>

  Six principles follow from taking the act of stating seriously.

  <\enumerate>
    <item><em|Nothing exists unless it is stated.> A world starts empty. Kinds, relations and objects come into being only when they are stated, and even numbers and text must be brought in.

    <item><em|If it can be built, build it.> The language gives only what cannot be stated from inside a world. Mutual relations, averages, time, ordered collections and merge strategies are built with the same statements as any world.

    <item><em|What isn't stated isn't true.> A fact holds because it was stated or because a rule states that it follows; absence is falsity. Grant needs no booleans and no null.

    <item><em|Each world is one state.> A world is its parents plus its own statements. Building on a world, or holding it, starts another world and never changes the first.

    <item><em|A name is not an identity.> An object is what it is because of where it was stated into being. Names point at it and its index numbers it, but neither is it.

    <item><em|Every line is a statement.> Each line reads as a sentence, and symbols appear only where they carry meaning: <verbatim|[ \| ]>, <verbatim|:>, <verbatim|.>, <verbatim|?>, <verbatim|+>, <verbatim|->.
  </enumerate>

  <section|The mathematical structure><label|structure>

  <subsection|Worlds>

  <\definition>
    A <em|world> is a quadruple <math|<with|math-display|true|\<cal-W\>=<around|(|K,O,F,R|)>>> of finite sets: the <em|kinds> <math|K>, the <em|objects> <math|O>, the <em|facts> <math|F> and the <em|rules> <math|R>.
  </definition>

  <tabular|<tformat|<twith|table-width|1par>|<twith|table-hmode|min>|<cwith|1|1|1|-1|cell-bborder|1ln>|<cwith|1|1|1|-1|cell-tborder|1ln>|<cwith|-1|-1|1|-1|cell-bborder|1ln>|<cwith|1|-1|1|-1|cell-hyphen|t>|<cwith|1|-1|1|-1|cell-halign|l>|<table|<row|<\cell>
      Part
    </cell>|<\cell>
      Holds
    </cell>|<\cell>
      Each element is
    </cell>>|<row|<\cell>
      <math|K>, kinds
    </cell>|<\cell>
      the sorts of things that exist
    </cell>|<\cell>
      a name with a <em|shape>: for each relation, how many values it holds and of what kind
    </cell>>|<row|<\cell>
      <math|O>, objects
    </cell>|<\cell>
      the things themselves
    </cell>|<\cell>
      an identity with a kind, a handle and an index
    </cell>>|<row|<\cell>
      <math|F>, facts
    </cell>|<\cell>
      what is stated about things
    </cell>|<\cell>
      a triple <math|<around|(|s,r,v|)>>: subject, relation, value
    </cell>>|<row|<\cell>
      <math|R>, rules
    </cell>|<\cell>
      what follows, and what must never hold
    </cell>|<\cell>
      a name with a head and a condition, or a name with a forbidden pattern
    </cell>>>>>

  The subject <math|s> of a fact is an object, and its value <math|v> is an object or a primitive value, such as <verbatim|24> or <verbatim|"Linear Algebra">. Write <math|D<rsub|k>> for the objects of kind <math|k>. A shape entry <verbatim|r: one k> on a kind <math|k<rprime|'>> says that <math|r> is a relation from <math|D<rsub|k<rprime|'>>> to <math|D<rsub|k>> and that each object has exactly one value of it. Shapes are <em|closed>: a fact whose relation is not in the shape of its subject's kind cannot be stated, and neither can a value of the wrong kind.

  Facts form a set: stating the same fact twice is stating it once, and the order of statements is lost. Only the structure remains.

  <\remark>
    <em|Identity.> The identity of an object is its <em|origin>: the world that created it and its place in that world's order of creation. It is never written and never seen. Kinds, relations and rules are identified by their names; objects are identified by their origin. Two objects can share a handle, but two kinds cannot share a name.
  </remark>

  <subsection|What follows>

  A rule <verbatim|rule n: h if c> has a head <math|h>, which is one fact pattern, and a condition <math|c>; write it <math|h\<leftarrow\>c>. A set of rules <math|R> defines an operator on sets of facts,

  <\equation*>
    T<rsub|R><around|(|X|)>=X\<cup\><around|{|h*\<sigma\><space|0.4em>:<space|0.4em><around|(|h\<leftarrow\>c|)>\<in\>R,<space|0.6em>X\<models\>c*\<sigma\>|}>,
  </equation*>

  where <math|\<sigma\>> ranges over the assignments of objects and values to the variables of the rule. The <em|derived facts> <math|D<around|(|F,R|)>> are what the rules add to <math|F>, and questions see stated and derived facts together:

  <\equation*>
    M=F\<cup\>D<around|(|F,R|)>,<space|2em>M=<big|cup><rsub|n\<geqslant\>0>T<rsub|R><rsup|n><around|(|F|)>.
  </equation*>

  Derived facts are not stored. They are recomputed whenever <math|F> or <math|R> changes, so a question halfway through a world sees it as it stands there. Conditions join fact patterns and comparisons with <verbatim|and>, <verbatim|or> and <verbatim|not>. Recursion is allowed, and the iteration above reaches its limit after finitely many steps because the world is finite.

  Negation and aggregates are not monotone, so they need care. Grant orders the rules in <em|strata>: a rule that reads a relation under <verbatim|not>, or under <verbatim|count>, <verbatim|sum>, <verbatim|min> or <verbatim|max>, is evaluated only after every rule producing that relation has reached its fixed point. A rule that would depend on its own negation, or on an aggregate of itself, has no well-defined answer and is refused.

  <\verbatim-code>
    rule reach: \ \ person a can_reach person b if

    \ \ a knows b or (a knows person m and m can_reach b)

    rule lonely: \ person p is lonely if not p knows person q

    rule popular: person p is popular if count (person q knows p) \<gtr\> 10
  </verbatim-code>

  <subsection|What must never hold>

  A <em|constraint> <verbatim|never n: k x where c> names a pattern that must have no matches. The words in a shape are constraints too: <verbatim|one> says <math|<around|\||r<around|(|x|)>|\|>=1>, <verbatim|maybe> says <math|<around|\||r<around|(|x|)>|\|>\<leqslant\>1>, and <verbatim|some> says <math|<around|\||r<around|(|x|)>|\|>\<geqslant\>1>. Constraints are checked once, on the finished structure: a world is <em|valid> when, for every one of its constraints <math|c>,

  <\equation*>
    <around|{|\<sigma\>:M\<models\>c*\<sigma\>|}>=\<varnothing\>.
  </equation*>

  Completion of the file is the checkpoint. A world may pass through states that break a constraint, as long as it does not end in one. That structure, and not the order of lines, is the world.

  <subsection|Building worlds on worlds>

  A world is written as a list of lines <math|\<ell\><rsub|1>,\<ldots\>,\<ell\><rsub|m>>, each of which is a function from worlds to worlds. A world with parents <math|\<cal-W\><rsub|1>,\<ldots\>,\<cal-W\><rsub|p>> starts from their union and then runs its own lines:

  <\equation*>
    \<cal-W\>=<around|(|\<ell\><rsub|m>\<circ\>\<cdots\>\<circ\>\<ell\><rsub|1>|)><around|(|\<cal-W\><rsub|1>\<cup\>\<cdots\>\<cup\>\<cal-W\><rsub|p>|)>,<space|2em>\<cal-W\><rsub|i>\<cup\>\<cal-W\><rsub|j>=<around|(|K<rsub|i>\<cup\>K<rsub|j>,<space|0.3em>O<rsub|i>\<cup\>O<rsub|j>,<space|0.3em>F<rsub|i>\<cup\>F<rsub|j>,<space|0.3em>R<rsub|i>\<cup\>R<rsub|j>|)>.
  </equation*>

  The union is taken by identity: objects with the same origin are the same object, and kinds and rules with the same name are the same kind or rule. The union is commutative and associative, so the order of parents does not matter. A child is not a copy of its parent plus a difference: it is <em|a set of instructions applied to whatever its parent is>. When a parent changes, every world built on it is run again.

  <\big-figure|<with|gr-mode|<tuple|edit|line>|gr-frame|<tuple|scale|1cm|<tuple|0.5gw|0.5gh>>|gr-geometry|<tuple|geometry|13.5cm|7.4cm|center>|<graphics||<with|text-at-halign|center|text-at-valign|center|<text-at|<with|font-size|0.95|<verbatim|roster>>|<point|0.000|2.700>>>|<with|text-at-halign|center|text-at-valign|center|<text-at|<with|font-size|0.95|<verbatim|assign_engineering>>|<point|-3.400|0.250>>>|<with|text-at-halign|center|text-at-valign|center|<text-at|<with|font-size|0.95|<verbatim|assign_research>>|<point|3.400|0.250>>>|<with|text-at-halign|center|text-at-valign|center|<text-at|<with|font-size|0.95|<verbatim|both>>|<point|0.000|-2.700>>>|<with|arrow-end|<tuple|<with|dash-style|none|<line|<tuple|-10ln|6ln>|<tuple|0ln|0ln>|<tuple|-10ln|-6ln>>>>|<line|<point|-0.365|2.437>|<point|-2.994|0.542>>>|<with|arrow-end|<tuple|<with|dash-style|none|<line|<tuple|-10ln|6ln>|<tuple|0ln|0ln>|<tuple|-10ln|-6ln>>>>|<line|<point|0.365|2.437>|<point|2.994|0.542>>>|<with|arrow-end|<tuple|<with|dash-style|none|<line|<tuple|-10ln|6ln>|<tuple|0ln|0ln>|<tuple|-10ln|-6ln>>>>|<line|<point|-2.607|-0.438>|<point|-0.340|-2.405>>>|<with|arrow-end|<tuple|<with|dash-style|none|<line|<tuple|-10ln|6ln>|<tuple|0ln|0ln>|<tuple|-10ln|-6ln>>>>|<line|<point|2.607|-0.438>|<point|0.340|-2.405>>>|<with|text-at-halign|center|text-at-valign|center|<text-at|<with|font-size|0.75|<with|font-shape|italic|from>>|<point|-2.150|1.750>>>|<with|text-at-halign|center|text-at-valign|center|<text-at|<with|font-size|0.75|<with|font-shape|italic|from>>|<point|2.150|1.750>>>|<with|text-at-halign|center|text-at-valign|center|<text-at|<with|font-size|0.75|<with|font-shape|italic|from>>|<point|-2.200|-1.750>>>|<with|text-at-halign|center|text-at-valign|center|<text-at|<with|font-size|0.75|<with|font-shape|italic|from>>|<point|2.200|-1.750>>>|<with|text-at-halign|center|text-at-valign|center|<text-at|<with|font-size|0.75|<verbatim|harbor works_in design>>|<point|0.000|3.250>>>|<with|text-at-halign|center|text-at-valign|center|<text-at|<with|font-size|0.75|<verbatim|harbor [ works_in: engineering ]>>|<point|-3.400|-0.250>>>|<with|text-at-halign|center|text-at-valign|center|<text-at|<with|font-size|0.75|<verbatim|harbor [ works_in: research ]>>|<point|3.400|-0.250>>>|<with|text-at-halign|center|text-at-valign|center|<text-at|<with|font-size|0.75|union: <verbatim|engineering> and <verbatim|research>;<space|0.6em>then <verbatim|harbor [ works_in: engineering ]>>|<point|0.000|-3.250>>>>>>
    Two worlds built on <verbatim|roster> move harbor to different teams. Their union has harbor assigned to both, which the shape <verbatim|works_in: one team> forbids at the end. The child settles it the way anything is settled in Grant: by stating what is true.
  </big-figure>

  A merge never fails on its own line. Parents can disagree in three ways: their facts together break a constraint, a rule has two definitions, or a relation is declared two ways. All three are settled by the child's own lines and checked at the end of the world. Until a disputed rule is restated, it produces nothing.

  <subsection|Worlds as objects>

  Worlds are also things. Write <math|H<around|(|\<cal-W\>|)>> for the set of worlds that a world <math|\<cal-W\>> holds. Worlds that hold no other worlds form the first level, and each level can hold the worlds of the levels below it:

  <\equation*>
    \<cal-S\><rsub|0>=<around|{|\<cal-W\>:H<around|(|\<cal-W\>|)>=\<varnothing\>|}>,<space|2em>\<cal-S\><rsub|n+1>=<around|{|\<cal-W\>:H<around|(|\<cal-W\>|)>\<subseteq\>\<cal-S\><rsub|0>\<cup\>\<cdots\>\<cup\>\<cal-S\><rsub|n>|}>,<space|2em>\<cal-S\>=<big|cup><rsub|n\<geqslant\>0>\<cal-S\><rsub|n>.
  </equation*>

  In a world of level <math|n+1> the kind <verbatim|world> is one more kind of thing, whose objects are the worlds it holds, all from the levels below. A relation between worlds is then an ordinary fact, and rules can produce it like any other. To look inside a held world <math|w>, Grant evaluates there: for every condition <math|\<varphi\>>, the condition <verbatim|in w:> <math|\<varphi\>> holds in <math|\<cal-W\>> exactly when <math|\<varphi\>> holds in <math|w>,

  <\equation*>
    \<cal-W\>\<models\><around|(|<math-up|in><space|0.3em>w:\<varphi\>|)><space|0.6em>\<Longleftrightarrow\><space|0.6em>w\<models\>\<varphi\>.
  </equation*>

  <\big-figure|<with|gr-mode|<tuple|edit|line>|gr-frame|<tuple|scale|1cm|<tuple|0.5gw|0.5gh>>|gr-geometry|<tuple|geometry|15.0cm|9.4cm|center>|<graphics||<with|text-at-halign|center|text-at-valign|center|<math-at|<with|font-size|1|\<cal-S\><rsub|0>>|<point|-7.000|-3.300>>>|<with|text-at-halign|center|text-at-valign|center|<math-at|<with|font-size|1|\<cal-S\><rsub|1>>|<point|-7.000|0.000>>>|<with|text-at-halign|center|text-at-valign|center|<math-at|<with|font-size|1|\<cal-S\><rsub|2>>|<point|-7.000|3.100>>>|<with|dash-style|101010|color|grey|<line|<point|-7.400|-1.750>|<point|7.200|-1.750>>>|<with|dash-style|101010|color|grey|<line|<point|-7.400|1.750>|<point|7.200|1.750>>>|<carc|<point|-5.450|-3.300>|<point|-4.600|-2.450>|<point|-3.750|-3.300>>|<with|point-size|1.6ln|<point|-5.050|-3.150>>|<with|point-size|1.6ln|<point|-4.550|-3.550>>|<with|point-size|1.6ln|<point|-4.150|-3.100>>|<with|line-width|0.6ln|arrow-end|<tuple|<with|dash-style|none|<line|<tuple|-10ln|6ln>|<tuple|0ln|0ln>|<tuple|-10ln|-6ln>>>>|<line|<point|-4.972|-3.212>|<point|-4.628|-3.488>>>|<with|line-width|0.6ln|arrow-end|<tuple|<with|dash-style|none|<line|<tuple|-10ln|6ln>|<tuple|0ln|0ln>|<tuple|-10ln|-6ln>>>>|<line|<point|-4.484|-3.475>|<point|-4.216|-3.175>>>|<with|text-at-halign|center|text-at-valign|center|<text-at|<with|font-size|0.84|<verbatim|roster_a>>|<point|-4.600|-4.450>>>|<carc|<point|-2.850|-3.300>|<point|-2.000|-2.450>|<point|-1.150|-3.300>>|<with|point-size|1.6ln|<point|-2.400|-3.500>>|<with|point-size|1.6ln|<point|-2.000|-3.000>>|<with|point-size|1.6ln|<point|-1.580|-3.450>>|<with|line-width|0.6ln|arrow-end|<tuple|<with|dash-style|none|<line|<tuple|-10ln|6ln>|<tuple|0ln|0ln>|<tuple|-10ln|-6ln>>>>|<line|<point|-2.338|-3.422>|<point|-2.062|-3.078>>>|<with|line-width|0.6ln|arrow-end|<tuple|<with|dash-style|none|<line|<tuple|-10ln|6ln>|<tuple|0ln|0ln>|<tuple|-10ln|-6ln>>>>|<line|<point|-1.648|-3.377>|<point|-1.932|-3.073>>>|<with|text-at-halign|center|text-at-valign|center|<text-at|<with|font-size|0.84|<verbatim|roster_b>>|<point|-2.000|-4.450>>>|<carc|<point|0.550|-3.300>|<point|1.400|-2.450>|<point|2.250|-3.300>>|<with|point-size|1.6ln|<point|1.100|-3.300>>|<with|point-size|1.6ln|<point|1.700|-3.200>>|<with|line-width|0.6ln|arrow-end|<tuple|<with|dash-style|none|<line|<tuple|-10ln|6ln>|<tuple|0ln|0ln>|<tuple|-10ln|-6ln>>>>|<line|<point|1.199|-3.284>|<point|1.601|-3.216>>>|<with|text-at-halign|center|text-at-valign|center|<text-at|<with|font-size|0.84|<verbatim|roster_c>>|<point|1.400|-4.450>>>|<carc|<point|3.550|-3.300>|<point|4.400|-2.450>|<point|5.250|-3.300>>|<with|point-size|1.6ln|<point|4.000|-3.500>>|<with|point-size|1.6ln|<point|4.800|-3.500>>|<with|point-size|1.6ln|<point|4.400|-2.950>>|<with|line-width|0.6ln|arrow-end|<tuple|<with|dash-style|none|<line|<tuple|-10ln|6ln>|<tuple|0ln|0ln>|<tuple|-10ln|-6ln>>>>|<line|<point|4.100|-3.500>|<point|4.700|-3.500>>>|<with|line-width|0.6ln|arrow-end|<tuple|<with|dash-style|none|<line|<tuple|-10ln|6ln>|<tuple|0ln|0ln>|<tuple|-10ln|-6ln>>>>|<line|<point|4.741|-3.419>|<point|4.459|-3.031>>>|<with|line-width|0.6ln|arrow-end|<tuple|<with|dash-style|none|<line|<tuple|-10ln|6ln>|<tuple|0ln|0ln>|<tuple|-10ln|-6ln>>>>|<line|<point|4.341|-3.031>|<point|4.059|-3.419>>>|<with|text-at-halign|center|text-at-valign|center|<text-at|<with|font-size|0.84|<verbatim|roster_d>>|<point|4.400|-4.450>>>|<line|<point|-4.750|-0.750>|<point|-1.850|-0.750>>|<line|<point|-1.550|-0.450>|<point|-1.550|0.450>>|<line|<point|-1.850|0.750>|<point|-4.750|0.750>>|<line|<point|-5.050|0.450>|<point|-5.050|-0.450>>|<arc|<point|-1.850|-0.750>|<point|-1.638|-0.662>|<point|-1.550|-0.450>>|<arc|<point|-1.550|0.450>|<point|-1.638|0.662>|<point|-1.850|0.750>>|<arc|<point|-4.750|0.750>|<point|-4.962|0.662>|<point|-5.050|0.450>>|<arc|<point|-5.050|-0.450>|<point|-4.962|-0.662>|<point|-4.750|-0.750>>|<with|text-at-halign|center|text-at-valign|center|<text-at|<with|font-size|0.84|<verbatim|batch_a>>|<point|-5.900|0.000>>>|<with|point-size|2.2ln|<point|-4.250|0.000>>|<with|point-size|2.2ln|<point|-2.350|0.000>>|<with|arrow-end|<tuple|<with|dash-style|none|<line|<tuple|-10ln|6ln>|<tuple|0ln|0ln>|<tuple|-10ln|-6ln>>>>|<line|<point|-4.090|0.000>|<point|-2.510|0.000>>>|<with|text-at-halign|center|text-at-valign|center|<text-at|<with|font-size|0.7|<with|font-shape|italic|is_happier_than>>|<point|-3.300|0.300>>>|<with|dash-style|10|color|black|<line|<point|-4.250|-0.150>|<point|-4.600|-2.380>>>|<with|dash-style|10|color|black|<line|<point|-2.350|-0.150>|<point|-2.000|-2.380>>>|<line|<point|1.450|-0.750>|<point|4.350|-0.750>>|<line|<point|4.650|-0.450>|<point|4.650|0.450>>|<line|<point|4.350|0.750>|<point|1.450|0.750>>|<line|<point|1.150|0.450>|<point|1.150|-0.450>>|<arc|<point|4.350|-0.750>|<point|4.562|-0.662>|<point|4.650|-0.450>>|<arc|<point|4.650|0.450>|<point|4.562|0.662>|<point|4.350|0.750>>|<arc|<point|1.450|0.750>|<point|1.238|0.662>|<point|1.150|0.450>>|<arc|<point|1.150|-0.450>|<point|1.238|-0.662>|<point|1.450|-0.750>>|<with|text-at-halign|center|text-at-valign|center|<text-at|<with|font-size|0.84|<verbatim|batch_b>>|<point|5.400|0.000>>>|<with|point-size|2.2ln|<point|1.950|0.000>>|<with|point-size|2.2ln|<point|3.850|0.000>>|<with|arrow-end|<tuple|<with|dash-style|none|<line|<tuple|-10ln|6ln>|<tuple|0ln|0ln>|<tuple|-10ln|-6ln>>>>|<line|<point|2.110|0.000>|<point|3.690|0.000>>>|<with|text-at-halign|center|text-at-valign|center|<text-at|<with|font-size|0.7|<with|font-shape|italic|is_happier_than>>|<point|2.900|0.300>>>|<with|dash-style|10|color|black|<line|<point|1.950|-0.150>|<point|1.400|-2.380>>>|<with|dash-style|10|color|black|<line|<point|3.850|-0.150>|<point|4.400|-2.380>>>|<line|<point|-1.700|2.400>|<point|1.700|2.400>>|<line|<point|2.000|2.700>|<point|2.000|3.500>>|<line|<point|1.700|3.800>|<point|-1.700|3.800>>|<line|<point|-2.000|3.500>|<point|-2.000|2.700>>|<arc|<point|1.700|2.400>|<point|1.912|2.488>|<point|2.000|2.700>>|<arc|<point|2.000|3.500>|<point|1.912|3.712>|<point|1.700|3.800>>|<arc|<point|-1.700|3.800>|<point|-1.912|3.712>|<point|-2.000|3.500>>|<arc|<point|-2.000|2.700>|<point|-1.912|2.488>|<point|-1.700|2.400>>|<with|text-at-halign|center|text-at-valign|center|<text-at|<with|font-size|0.84|<verbatim|review>>|<point|2.750|3.100>>>|<with|point-size|2.2ln|<point|-1.100|3.100>>|<with|point-size|2.2ln|<point|1.100|3.100>>|<with|arrow-end|<tuple|<with|dash-style|none|<line|<tuple|-10ln|6ln>|<tuple|0ln|0ln>|<tuple|-10ln|-6ln>>>>|<line|<point|-0.940|3.100>|<point|0.940|3.100>>>|<with|text-at-halign|center|text-at-valign|center|<text-at|<with|font-size|0.7|<with|font-shape|italic|is_calmer_than>>|<point|0.000|3.400>>>|<with|dash-style|10|color|black|<line|<point|-1.100|2.950>|<point|-3.300|0.820>>>|<with|dash-style|10|color|black|<line|<point|1.100|2.950>|<point|2.900|0.820>>>|<with|text-at-halign|right|text-at-valign|center|<text-at|<with|font-size|0.7|<with|font-shape|italic|holds>>|<point|-2.100|2.200>>>|<with|text-at-halign|right|text-at-valign|center|<text-at|<with|font-size|0.7|<with|font-shape|italic|holds>>|<point|-4.550|-1.150>>>>>>
    Three levels of data. Each roster records people and their team assignments. <verbatim|batch_a> and <verbatim|batch_b> compare alternative rosters; <verbatim|review> compares those batches. Holding a world means referring to its data, not containing a physical place. A dashed line joins a reference to the structure it denotes.
  </big-figure>

  Because a world only holds worlds from lower levels, no world can hold itself, and worlds about worlds form a well-founded tower. The relationships between rosters become things to count by lifting the world they live in; no other mechanism is needed to treat relationships as objects. Branch a world, change something, compare: this is the basic move of simulation and search, and every branch is its own world.

  <subsection|Equality>

  <\definition>
    Two worlds <math|\<cal-W\><rsub|1>> and <math|\<cal-W\><rsub|2>> are <em|equal> when they have the same kinds, rules and constraints, and there is a bijection <math|\<varphi\>:O<rsub|1>\<rightarrow\>O<rsub|2>> that preserves kinds and facts: <math|<around|(|s,r,v|)>\<in\>F<rsub|1>> if and only if <math|<around|(|\<varphi\><around|(|s|)>,r,\<varphi\><around|(|v|)>|)>\<in\>F<rsub|2>>, where <math|\<varphi\>> fixes numbers and text.
  </definition>

  Handles, identities and indexes do not matter: equality compares <em|shape>. A world with june in place of harbor, and everything else the same, is equal. In the language, <verbatim|=> between two worlds is this equality.

  <\big-figure|<with|gr-mode|<tuple|edit|line>|gr-frame|<tuple|scale|1cm|<tuple|0.5gw|0.5gh>>|gr-geometry|<tuple|geometry|13.0cm|5.6cm|center>|<graphics||<with|color|black|dash-style|10|<carc|<point|-6.050|0.000>|<point|-4.000|2.050>|<point|-1.950|0.000>>>|<with|point-size|2.2ln|<point|-4.950|-0.750>>|<with|point-size|2.2ln|<point|-3.050|-0.750>>|<with|point-size|2.2ln|<point|-4.000|0.900>>|<with|arrow-end|<tuple|<with|dash-style|none|<line|<tuple|-10ln|6ln>|<tuple|0ln|0ln>|<tuple|-10ln|-6ln>>>>|<line|<point|-4.080|0.761>|<point|-4.870|-0.611>>>|<with|arrow-end|<tuple|<with|dash-style|none|<line|<tuple|-10ln|6ln>|<tuple|0ln|0ln>|<tuple|-10ln|-6ln>>>>|<line|<point|-3.920|0.761>|<point|-3.130|-0.611>>>|<with|arrow-end|<tuple|<with|dash-style|none|<line|<tuple|-10ln|6ln>|<tuple|0ln|0ln>|<tuple|-10ln|-6ln>>>>|<line|<point|-4.790|-0.750>|<point|-3.210|-0.750>>>|<with|text-at-halign|center|text-at-valign|center|<text-at|<with|font-size|0.84|<verbatim|harbor>>|<point|-4.000|1.230>>>|<with|text-at-halign|center|text-at-valign|center|<text-at|<with|font-size|0.84|<verbatim|liz>>|<point|-5.000|-1.080>>>|<with|text-at-halign|center|text-at-valign|center|<text-at|<with|font-size|0.84|<verbatim|laurie>>|<point|-3.000|-1.080>>>|<with|text-at-halign|center|text-at-valign|center|<text-at|<with|font-size|0.72|<with|font-shape|italic|knows>>|<point|-4.980|0.180>>>|<with|text-at-halign|center|text-at-valign|center|<text-at|<with|font-size|0.72|<with|font-shape|italic|knows>>|<point|-3.020|0.180>>>|<with|text-at-halign|center|text-at-valign|center|<text-at|<with|font-size|0.72|<with|font-shape|italic|likes>>|<point|-4.000|-0.550>>>|<with|color|black|dash-style|10|<carc|<point|1.950|0.000>|<point|4.000|2.050>|<point|6.050|0.000>>>|<with|point-size|2.2ln|<point|3.050|-0.750>>|<with|point-size|2.2ln|<point|4.950|-0.750>>|<with|point-size|2.2ln|<point|4.000|0.900>>|<with|arrow-end|<tuple|<with|dash-style|none|<line|<tuple|-10ln|6ln>|<tuple|0ln|0ln>|<tuple|-10ln|-6ln>>>>|<line|<point|3.920|0.761>|<point|3.130|-0.611>>>|<with|arrow-end|<tuple|<with|dash-style|none|<line|<tuple|-10ln|6ln>|<tuple|0ln|0ln>|<tuple|-10ln|-6ln>>>>|<line|<point|4.080|0.761>|<point|4.870|-0.611>>>|<with|arrow-end|<tuple|<with|dash-style|none|<line|<tuple|-10ln|6ln>|<tuple|0ln|0ln>|<tuple|-10ln|-6ln>>>>|<line|<point|3.210|-0.750>|<point|4.790|-0.750>>>|<with|text-at-halign|center|text-at-valign|center|<text-at|<with|font-size|0.84|<verbatim|june>>|<point|4.000|1.230>>>|<with|text-at-halign|center|text-at-valign|center|<text-at|<with|font-size|0.84|<verbatim|kate>>|<point|3.000|-1.080>>>|<with|text-at-halign|center|text-at-valign|center|<text-at|<with|font-size|0.84|<verbatim|cora>>|<point|5.000|-1.080>>>|<with|text-at-halign|center|text-at-valign|center|<text-at|<with|font-size|0.72|<with|font-shape|italic|knows>>|<point|3.020|0.180>>>|<with|text-at-halign|center|text-at-valign|center|<text-at|<with|font-size|0.72|<with|font-shape|italic|knows>>|<point|4.980|0.180>>>|<with|text-at-halign|center|text-at-valign|center|<text-at|<with|font-size|0.72|<with|font-shape|italic|likes>>|<point|4.000|-0.550>>>|<with|arrow-end|<tuple|<with|dash-style|none|<line|<tuple|-10ln|6ln>|<tuple|0ln|0ln>|<tuple|-10ln|-6ln>>>>|<line|<point|-1.700|0.900>|<point|1.700|0.900>>>|<with|text-at-halign|center|text-at-valign|center|<math-at|<with|font-size|1|\<varphi\>>|<point|0.000|1.200>>>|<with|text-at-halign|center|text-at-valign|center|<text-at|<with|font-size|0.84|<verbatim|harbor><space|0.4em><math|\<mapsto\>><space|0.4em><verbatim|june>>|<point|0.000|0.300>>>|<with|text-at-halign|center|text-at-valign|center|<text-at|<with|font-size|0.84|<verbatim|liz><space|0.4em><math|\<mapsto\>><space|0.4em><verbatim|kate>>|<point|0.000|-0.180>>>|<with|text-at-halign|center|text-at-valign|center|<text-at|<with|font-size|0.84|<verbatim|laurie><space|0.4em><math|\<mapsto\>><space|0.4em><verbatim|cora>>|<point|0.000|-0.660>>>|<with|text-at-halign|center|text-at-valign|center|<math-at|<with|font-size|1|\<cal-W\><rsub|1>>|<point|-4.000|2.450>>>|<with|text-at-halign|center|text-at-valign|center|<math-at|<with|font-size|1|\<cal-W\><rsub|2>>|<point|4.000|2.450>>>>>>
    Equal worlds. The names differ, but <math|\<varphi\>> matches the objects so that every fact corresponds.
  </big-figure>

  <section|How it works><label|language>

  This section goes through the language in the order in which a world is usually written. Three habits of reading help: <em|spaces state, dots refer, <verbatim|@> picks, <verbatim|?> shows>. The line <verbatim|harbor knows liz> adds a fact; <verbatim|harbor.knows> <em|is> liz and laurie, wherever it is written; <verbatim|? harbor.knows> prints them.

  <subsection|Primitive worlds>

  Something is a primitive only if it cannot be created inside a finite world. Primitives live in built-in worlds, and a world gets them only by building on them: a world without <verbatim|from numbers> has no numbers.

  <tabular|<tformat|<twith|table-width|1par>|<twith|table-hmode|min>|<cwith|1|1|1|-1|cell-bborder|1ln>|<cwith|1|1|1|-1|cell-tborder|1ln>|<cwith|-1|-1|1|-1|cell-bborder|1ln>|<cwith|1|-1|1|-1|cell-hyphen|t>|<cwith|1|-1|1|-1|cell-halign|l>|<table|<row|<\cell>
      World
    </cell>|<\cell>
      Kind
    </cell>|<\cell>
      Holds
    </cell>>|<row|<\cell>
      <verbatim|numbers>
    </cell>|<\cell>
      <verbatim|number>
    </cell>|<\cell>
      exact numbers such as <verbatim|24>, <verbatim|3.5>, <verbatim|-2>, with <verbatim|+ - * / div mod> and <verbatim|\<less\> \<gtr\> \<less\>= \<gtr\>=>
    </cell>>|<row|<\cell>
      <verbatim|text>
    </cell>|<\cell>
      <verbatim|text>
    </cell>|<\cell>
      written content such as <verbatim|"Linear Algebra">, with <verbatim|+> to join and <verbatim|\<less\> \<gtr\> \<less\>= \<gtr\>=>
    </cell>>|<row|<\cell>
      <verbatim|id>
    </cell>|<\cell>
      <verbatim|id>
    </cell>|<\cell>
      the index of every object: <verbatim|harbor.id> is its number within its kind, and <verbatim|id.1> is every object numbered 1
    </cell>>>>>

  Numbers are exact: <verbatim|1 / 3> stays a third. Time is not a primitive; a date is a number of days, and a calendar is a world built on <verbatim|numbers>. The kind <verbatim|world> is built into the language. There are no booleans (truth is whether a fact exists), no null (a missing value is a missing fact) and no lists (a relation can hold any number of values).

  <subsection|Kinds and shapes>

  <\verbatim-code>
    kind team

    kind person [ age: one number \| works_in: one team \| knows: person ]

    \ 

    never sensible_age: person p where p.age \<less\> 0 or p.age \<gtr\> 150
  </verbatim-code>

  <tabular|<tformat|<twith|table-width|1par>|<twith|table-hmode|min>|<cwith|1|1|1|-1|cell-bborder|1ln>|<cwith|1|1|1|-1|cell-tborder|1ln>|<cwith|-1|-1|1|-1|cell-bborder|1ln>|<cwith|1|-1|1|-1|cell-hyphen|t>|<cwith|1|-1|1|-1|cell-halign|l>|<table|<row|<\cell>
      Word
    </cell>|<\cell>
      Means
    </cell>|<\cell>
      The same constraint written out
    </cell>>|<row|<\cell>
      <verbatim|one>
    </cell>|<\cell>
      exactly one
    </cell>|<\cell>
      <verbatim|never n: person p where count p.r != 1>
    </cell>>|<row|<\cell>
      <verbatim|maybe>
    </cell>|<\cell>
      zero or one
    </cell>|<\cell>
      <verbatim|never n: person p where count p.r \<gtr\> 1>
    </cell>>|<row|<\cell>
      <verbatim|some>
    </cell>|<\cell>
      at least one
    </cell>|<\cell>
      <verbatim|never n: person p where count p.r = 0>
    </cell>>|<row|<\cell>
      <verbatim|many>, or no word
    </cell>|<\cell>
      any number
    </cell>|<\cell>
      none
    </cell>>>>>

  Inside brackets a new line works like <verbatim|\|>. Stated and derived facts share a shape: a relation that a rule produces must be declared like any other.

  <subsection|Objects and facts>

  An object is created with its kind and a handle. A fact is <verbatim|subject relation value>. Brackets are a compact way to state several facts, so the two blocks below are the same world.

  <\verbatim-code>
    person harbor [ age: 24 \| works_in: design \| knows: liz, laurie ]

    \ 

    person harbor

    harbor age 24

    harbor works_in design

    harbor knows liz

    harbor knows laurie
  </verbatim-code>

  Things must exist before they are mentioned. Names are written in small letters, with <verbatim|_> between words; capitals belong inside text.

  What things share is a thing, not a text. A name is an object, so one person has one name and a name can have many people. A fact is stated from one end and read from both: <verbatim|by> declares a relation that reads another one backwards. It is never stated, so nothing is stored twice, and the relation it reads cannot be removed or given another kind while it is read.

  <\verbatim-code>
    kind name

    kind person [ name: one name ]

    kind name [ person: person by name ]

    name emmy

    person noether [ name: emmy ]

    \ 

    ? name@emmy.person \ \ \ \ \ \ \ \ \ \ \ \ \ -- noether
  </verbatim-code>

  Numbers and text hold no facts of their own, but they are read from the same way: after <verbatim|kind number [ aged: person by age ]>, <verbatim|24.aged> is everyone aged 24.

  A bare handle works when exactly one object has it, or when the place settles which: a value takes the kind of its relation, also in a description after <verbatim|the>; a handle compared with a value takes that value's kind, as in <verbatim|p.lives_in = york>; and a subject is the object that has the relations its line uses. Otherwise, when objects of different kinds share it, the kind comes first and <verbatim|@> picks the object: <verbatim|@> goes from a kind to one of its objects, <verbatim|.> from an object along a relation. <verbatim|person@york> is exactly <verbatim|the person york [ ]>, and Grant shows a shared handle the same way. When objects of one kind share a handle, <verbatim|the> describes the one that is meant, and it is an error if none or several fit.

  <\verbatim-code>
    the harbor [ works_in: engineering ] knows liz

    the person harbor [ works_in: design ] feels happy
  </verbatim-code>

  <subsection|Values>

  A dot gives every value of a relation: none, one or several. Dots chain, so <verbatim|harbor.knows.works_in> is the teams in which everyone harbor knows works.

  <tabular|<tformat|<twith|table-width|1par>|<twith|table-hmode|min>|<cwith|1|1|1|-1|cell-bborder|1ln>|<cwith|1|1|1|-1|cell-tborder|1ln>|<cwith|-1|-1|1|-1|cell-bborder|1ln>|<cwith|1|-1|1|-1|cell-hyphen|t>|<cwith|1|-1|1|-1|cell-halign|l>|<table|<row|<\cell>
      Operator
    </cell>|<\cell>
      Comes with
    </cell>|<\cell>
      Example
    </cell>>|<row|<\cell>
      <verbatim|=>, <verbatim|!=>
    </cell>|<\cell>
      every kind
    </cell>|<\cell>
      <verbatim|harbor.works_in = design>
    </cell>>|<row|<\cell>
      <verbatim|+ - * />, <verbatim|( )>
    </cell>|<\cell>
      <verbatim|numbers>
    </cell>|<\cell>
      <verbatim|(harbor.age + 1) * 2>
    </cell>>|<row|<\cell>
      <verbatim|div>, <verbatim|mod>
    </cell>|<\cell>
      <verbatim|numbers>
    </cell>|<\cell>
      <verbatim|17 div 5> is 3, <verbatim|17 mod 5> is 2
    </cell>>|<row|<\cell>
      <verbatim|\<less\> \<gtr\> \<less\>= \<gtr\>=>
    </cell>|<\cell>
      <verbatim|numbers>, <verbatim|text>
    </cell>|<\cell>
      <verbatim|harbor.age \<gtr\>= 18>
    </cell>>|<row|<\cell>
      <verbatim|+>
    </cell>|<\cell>
      <verbatim|text>
    </cell>|<\cell>
      <verbatim|"linear " + "algebra">
    </cell>>|<row|<\cell>
      <verbatim|count>
    </cell>|<\cell>
      everything
    </cell>|<\cell>
      <verbatim|count harbor.knows>, <verbatim|count (person p feels happy)>
    </cell>>|<row|<\cell>
      <verbatim|sum>, <verbatim|min>, <verbatim|max>
    </cell>|<\cell>
      <verbatim|numbers>
    </cell>|<\cell>
      <verbatim|sum harbor.knows.age / count harbor.knows>
    </cell>>>>>

  <verbatim|* / div mod> come before <verbatim|+ ->, then comparisons, then <verbatim|not>, then <verbatim|and>, then <verbatim|or>. A value alone is not a line: every line states, changes, defines or shows. Missing values do not compute: <verbatim|harbor.age + 1> is an error if harbor has no age, while inside a condition a comparison with a missing value simply does not hold. A <verbatim|-> written directly before a digit is a negative number, as in <verbatim|[ balance: -5 ]>.

  <subsection|Rules>

  <\verbatim-code>
    rule calm: \ \ \ \ \ \ person p is_at peace if p feels happy

    rule adult: \ \ \ \ \ person p is adult if p.age \<gtr\>= 18

    rule neighbours: person a is_neighbour_of person b if a.works_in = b.works_in and a != b

    rule lonely: \ \ \ \ person p is lonely if not p knows person q
  </verbatim-code>

  Variables are introduced with a kind (<verbatim|person p>) and reused by name inside the same rule. A variable first introduced inside <verbatim|not> means <verbatim|>there is none'': <verbatim|not p knows person q> reads <verbatim|>p knows nobody''. Several rules can produce the same relation, and a fact holds if any of them produces it. Flags are values: create <verbatim|condition adult>, and then <verbatim|harbor is adult> is a fact like any other. A long statement continues on indented lines.

  <subsection|Questions>

  <tabular|<tformat|<twith|table-width|1par>|<twith|table-hmode|min>|<cwith|1|1|1|-1|cell-bborder|1ln>|<cwith|1|1|1|-1|cell-tborder|1ln>|<cwith|-1|-1|1|-1|cell-bborder|1ln>|<cwith|1|-1|1|-1|cell-hyphen|t>|<cwith|1|-1|1|-1|cell-halign|l>|<table|<row|<\cell>
      Question
    </cell>|<\cell>
      Shows
    </cell>>|<row|<\cell>
      <verbatim|? harbor.age + 1>
    </cell>|<\cell>
      the value: 25
    </cell>>|<row|<\cell>
      <verbatim|? harbor.knows>
    </cell>|<\cell>
      the values: liz, laurie
    </cell>>|<row|<\cell>
      <verbatim|? harbor is_at peace>
    </cell>|<\cell>
      yes or no
    </cell>>|<row|<\cell>
      <verbatim|? person p is_at peace>
    </cell>|<\cell>
      every p that fits
    </cell>>|<row|<\cell>
      <verbatim|? person p works_in design and not p feels happy>
    </cell>|<\cell>
      every p that fits
    </cell>>|<row|<\cell>
      <verbatim|? person a knows person b>
    </cell>|<\cell>
      every pair that fits
    </cell>>|<row|<\cell>
      <verbatim|? in roster_a: harbor feels happy>
    </cell>|<\cell>
      yes or no, inside <verbatim|roster_a>
    </cell>>>>>

  <subsection|Changing a world>

  A <verbatim|+> at the start of a line adds and a <verbatim|-> removes; the <verbatim|+> is optional. Sentences add, brackets set: <verbatim|+ harbor works_in engineering> would give harbor two team assignments, while <verbatim|harbor [ works_in: engineering ]> replaces every value. Inside brackets, <verbatim|+> and <verbatim|-> add and remove single values.

  <\verbatim-code>
    + harbor knows robin \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ -- adds a fact

    harbor [ works_in: engineering ] \ \ \ \ \ \ \ \ \ \ \ \ -- sets: engineering replaces design

    harbor [ knows: + robin, - liz ] \ \ \ \ \ -- adds one value, removes another

    harbor [ age: harbor.age + 1 ] \ \ \ \ \ \ \ -- computed once, on this line

    - harbor knows liz \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ -- removes one fact

    - harbor knows \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ -- removes every knows from harbor

    - harbor \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ -- removes harbor and every fact touching it

    \ 

    each person p [ age: p.age + 1 ] \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ -- a year passes

    each person p where p.works_in = design [ age: p.age + 1 ]

    - each person p where p.age \<less\> 18 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ -- removes those people

    \ 

    kind person [ + email: maybe text ] \ \ -- declares a relation, or sets how many and its kind

    kind person [ - email ] \ \ \ \ \ \ \ \ \ \ \ \ \ \ -- refused while any person has one

    - rule calm

    - never sensible_age
  </verbatim-code>

  Removing only removes what was stated. If the fact still follows from a rule it stays true, and Grant says so: <verbatim|>removed, but it still follows from rule mutual''. Removing what is not there does nothing; stating something about what is not there is an error. Rules and constraints have unique names, so writing one with an existing name replaces it. A kind cannot be removed while anything still uses it.

  <subsection|Building on worlds>

  Each world is written in one file and is named by it: <verbatim|roster.grant> is the world <verbatim|roster>. The line <verbatim|from> comes first and lists every parent; names resolve from the world's own folder, as in <verbatim|from rosters/roster_a>.

  <\verbatim-code>
    -- assign_engineering.grant

    from roster

    harbor [ works_in: engineering ]

    \ 

    -- both.grant

    from assign_engineering, assign_research

    harbor [ works_in: engineering ] \ \ \ \ \ \ \ -- settles the two assignments of the merge

    ? harbor.works_in \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ -- engineering
  </verbatim-code>

  A child inherits everything and can change any of it, including removing an inherited rule. Nothing it does reaches back into its parent. If a parent removes something a child's line points at, the child fails with an error that names the cause: <verbatim|>harbor doesn't exist (removed in roster)''. Grant never guesses what a broken line meant. Running a world shows its own questions only.

  <subsection|Holding worlds>

  A world relates to another world in one of two ways: it builds on it (<verbatim|from roster_a>), or it holds it (<verbatim|world roster_a>). Holding makes an object of kind <verbatim|world>, the way <verbatim|team design> makes a team. A held world cannot be changed from outside.

  <\verbatim-code>
    from numbers

    \ 

    world roster_a

    world roster_b

    \ 

    kind world [ + is_happier_than: world ]

    \ 

    rule happier: world a is_happier_than world b if

    \ \ count (in a: person p feels happy) \<gtr\> count (in b: person p feels happy)

    \ 

    ? roster_a is_happier_than roster_b

    ? in roster_a: harbor.knows

    ? roster_a = roster_b

    ? (in roster_a: harbor feels happy) and not (in roster_b: harbor feels happy)
  </verbatim-code>

  Inside <verbatim|in w:> the names are those of <math|w>. Objects keep their identity in every world built from the one that created them, so the last question asks what changed for the same harbor.

  <section|Reference><label|reference>

  <subsection|What each line does>

  Every statement changes <math|K>, <math|O>, <math|F> or <math|R> of its world, and derived facts follow after each line.

  <tabular|<tformat|<twith|table-width|1par>|<twith|table-hmode|min>|<cwith|1|1|1|-1|cell-bborder|1ln>|<cwith|1|1|1|-1|cell-tborder|1ln>|<cwith|-1|-1|1|-1|cell-bborder|1ln>|<cwith|1|-1|1|-1|cell-hyphen|t>|<cwith|1|-1|1|-1|cell-halign|l>|<table|<row|<\cell>
      Statement
    </cell>|<\cell>
      Changes
    </cell>|<\cell>
      Effect
    </cell>>|<row|<\cell>
      <verbatim|from a, b>
    </cell>|<\cell>
      <math|K,O,F,R>
    </cell>|<\cell>
      starts the world as the union of its parents
    </cell>>|<row|<\cell>
      <verbatim|kind person [ r: one k ]>
    </cell>|<\cell>
      <math|K>
    </cell>|<\cell>
      adds the kind and declares its relations; stated again, adds the relations it lacks
    </cell>>|<row|<\cell>
      <verbatim|kind city [ r: k by s ]>
    </cell>|<\cell>
      <math|K>
    </cell>|<\cell>
      declares <math|r> as the relation <math|s> of kind <math|k>, read from the other end; nothing is stored for it
    </cell>>|<row|<\cell>
      <verbatim|kind person [ + r: k \| - s ]>
    </cell>|<\cell>
      <math|K>
    </cell>|<\cell>
      declares or redeclares a relation; removes one, unless facts use it
    </cell>>|<row|<\cell>
      <verbatim|- kind person>
    </cell>|<\cell>
      <math|K>
    </cell>|<\cell>
      removes the kind, unless anything uses it
    </cell>>|<row|<\cell>
      <verbatim|person harbor [ r: v ]>
    </cell>|<\cell>
      <math|O,F>
    </cell>|<\cell>
      a new object with its origin, kind, handle and index; one fact per value
    </cell>>|<row|<\cell>
      <verbatim|harbor r v>
    </cell>|<\cell>
      <math|F>
    </cell>|<\cell>
      adds the fact <math|<around|(|h,r,v|)>>, where <math|h> is harbor
    </cell>>|<row|<\cell>
      <verbatim|harbor [ r: v ]>
    </cell>|<\cell>
      <math|F>
    </cell>|<\cell>
      removes every stated <math|<around|(|h,r,\<cdot\>|)>>, then adds <math|<around|(|h,r,v|)>>
    </cell>>|<row|<\cell>
      <verbatim|harbor [ r: + v, - w ]>
    </cell>|<\cell>
      <math|F>
    </cell>|<\cell>
      adds <math|v>, removes <math|w>
    </cell>>|<row|<\cell>
      <verbatim|each person p where c [ r: v ]>
    </cell>|<\cell>
      <math|F>
    </cell>|<\cell>
      the same change on every match
    </cell>>|<row|<\cell>
      <verbatim|- harbor r v>, <verbatim|- harbor r>
    </cell>|<\cell>
      <math|F>
    </cell>|<\cell>
      removes the stated fact, or every stated value of <math|r>
    </cell>>|<row|<\cell>
      <verbatim|- harbor>, <verbatim|- each person p where c>
    </cell>|<\cell>
      <math|O,F>
    </cell>|<\cell>
      removes the objects and every fact with them as subject or value
    </cell>>|<row|<\cell>
      <verbatim|rule n: h if c>, <verbatim|never n: k x where c>
    </cell>|<\cell>
      <math|R>
    </cell>|<\cell>
      adds, or replaces the one named <math|n>
    </cell>>|<row|<\cell>
      <verbatim|- rule n>, <verbatim|- never n>
    </cell>|<\cell>
      <math|R>
    </cell>|<\cell>
      removes it
    </cell>>|<row|<\cell>
      <verbatim|world roster_a>
    </cell>|<\cell>
      <math|O>
    </cell>|<\cell>
      an object of kind <verbatim|world> holding the world <verbatim|roster_a>
    </cell>>|<row|<\cell>
      <verbatim|? q>
    </cell>|<\cell>
      nothing
    </cell>|<\cell>
      evaluates against <math|M=F\<cup\>D> and shows the result
    </cell>>>>>

  <subsection|Grammar>

  An informal summary. Lowercase words are names; what a name means (kind, handle, relation, variable, world) comes from where it stands and what has been declared. There is one statement per line; an indented line continues the statement above it; <verbatim|-<space|0spc>-> starts a comment.

  <\verbatim-code>
    world \ \ \ \ \ = [ "from" world_name { "," world_name } ] { statement }

    \ 

    statement \ = kind_decl \| kind_edit \| "-" "kind" kind

    \ \ \ \ \ \ \ \ \ \ \ \| object \| fact \| set \| removal \| each

    \ \ \ \ \ \ \ \ \ \ \ \| rule \| never \| "-" "rule" name \| "-" "never" name

    \ \ \ \ \ \ \ \ \ \ \ \| "world" world_name

    \ \ \ \ \ \ \ \ \ \ \ \| "?" ( condition \| expr )

    \ 

    kind_decl \ = "kind" kind [ "[" field { sep field } "]" ]

    kind_edit \ = "kind" kind "[" edit { sep edit } "]"

    edit \ \ \ \ \ \ = "+" field \| "-" relation

    field \ \ \ \ \ = relation ":" [ "one" \| "maybe" \| "some" \| "many" ] kind [ "by" relation ]

    \ 

    object \ \ \ \ = kind handle [ values ]

    fact \ \ \ \ \ \ = [ "+" ] ref relation expr

    set \ \ \ \ \ \ \ = ref values

    removal \ \ \ = "-" ref [ relation [ expr ] ]

    each \ \ \ \ \ \ = [ "-" ] "each" kind var [ "where" condition ] [ values \| relation ]

    values \ \ \ \ = "[" assign { sep assign } "]"

    assign \ \ \ \ = relation ":" ( expr { "," expr } \| change { "," change } )

    change \ \ \ \ = ( "+" \| "-" ) expr

    \ 

    rule \ \ \ \ \ \ = "rule" name ":" kind var relation term "if" condition

    never \ \ \ \ \ = "never" name ":" kind var "where" condition

    \ 

    ref \ \ \ \ \ \ \ = handle \| kind "@" handle \| "the" [ kind ] handle values

    condition \ = item { ( "and" \| "or" ) item }

    item \ \ \ \ \ \ = "not" item \| "(" condition ")" \| "in" world_name ":" condition

    \ \ \ \ \ \ \ \ \ \ \ \| kind var

    \ \ \ \ \ \ \ \ \ \ \ \| term relation term

    \ \ \ \ \ \ \ \ \ \ \ \| expr ( "=" \| "!=" \| "\<less\>" \| "\<gtr\>" \| "\<less\>=" \| "\<gtr\>=" ) expr

    term \ \ \ \ \ \ = kind var \| var \| ref \| expr

    expr \ \ \ \ \ \ = number \| text \| ref \| var \| "id" "." number

    \ \ \ \ \ \ \ \ \ \ \ \| expr "." relation

    \ \ \ \ \ \ \ \ \ \ \ \| expr ( "+" \| "-" \| "*" \| "/" \| "div" \| "mod" ) expr

    \ \ \ \ \ \ \ \ \ \ \ \| "count" ( expr \| "(" condition ")" ) \| ( "sum" \| "min" \| "max" ) expr

    \ \ \ \ \ \ \ \ \ \ \ \| "in" world_name ":" expr \| "(" expr ")"

    sep \ \ \ \ \ \ \ = "\|" \| newline
  </verbatim-code>

  <subsection|Errors>

  Grant stops at the first line that cannot be stated, and names the cause.

  <tabular|<tformat|<twith|table-width|1par>|<twith|table-hmode|min>|<cwith|1|1|1|-1|cell-bborder|1ln>|<cwith|1|1|1|-1|cell-tborder|1ln>|<cwith|-1|-1|1|-1|cell-bborder|1ln>|<cwith|1|-1|1|-1|cell-hyphen|t>|<cwith|1|-1|1|-1|cell-halign|l>|<table|<row|<\cell>
      When
    </cell>|<\cell>
      Grant says
    </cell>>|<row|<\cell>
      a world name does not resolve
    </cell>|<\cell>
      no world called <verbatim|roster_x> here
    </cell>>|<row|<\cell>
      a parent has errors
    </cell>|<\cell>
      <verbatim|roster> has errors; fix it first
    </cell>>|<row|<\cell>
      a name is used before it is created
    </cell>|<\cell>
      <verbatim|design> doesn't exist yet
    </cell>>|<row|<\cell>
      a name points at something a parent removed
    </cell>|<\cell>
      harbor doesn't exist (removed in roster)
    </cell>>|<row|<\cell>
      a bare handle fits objects of several kinds, and the place doesn't settle which
    </cell>|<\cell>
      2 objects called york; write <verbatim|city@york> or <verbatim|person@york>
    </cell>>|<row|<\cell>
      a <verbatim|by> relation is stated
    </cell>|<\cell>
      <verbatim|home_of> is read from <verbatim|lives_in>; state <verbatim|lives_in> on the other end
    </cell>>|<row|<\cell>
      a bare handle fits several objects of one kind
    </cell>|<\cell>
      2 objects called harbor; use <verbatim|the>
    </cell>>|<row|<\cell>
      <verbatim|the> fits none or several
    </cell>|<\cell>
      no people match this description
    </cell>>|<row|<\cell>
      a relation is not in the kind's shape
    </cell>|<\cell>
      person has no relation <verbatim|favourite_colour>
    </cell>>|<row|<\cell>
      a value is the wrong kind
    </cell>|<\cell>
      <verbatim|works_in> takes a team, not a feeling
    </cell>>|<row|<\cell>
      a rule produces an undeclared relation
    </cell>|<\cell>
      person doesn't declare <verbatim|is_at>
    </cell>>|<row|<\cell>
      a rule variable shares an object's name
    </cell>|<\cell>
      <verbatim|harbor> is already an object
    </cell>>|<row|<\cell>
      a rule depends on its own negation or aggregate
    </cell>|<\cell>
      rule <verbatim|popular> counts itself
    </cell>>|<row|<\cell>
      a line is only a value
    </cell>|<\cell>
      this value isn't used
    </cell>>|<row|<\cell>
      a missing value is computed with
    </cell>|<\cell>
      harbor has no <verbatim|age>
    </cell>>|<row|<\cell>
      a constraint is broken at the end of the world
    </cell>|<\cell>
      harbor has 2 <verbatim|works_in> (person: <verbatim|works_in: one team>)
    </cell>>|<row|<\cell>
      a merge disagreement is left at the end
    </cell>|<\cell>
      rule <verbatim|calm> differs between assign_engineering and assign_research; restate it
    </cell>>|<row|<\cell>
      a kind is removed while still in use
    </cell>|<\cell>
      3 people still use <verbatim|person>
    </cell>>|<row|<\cell>
      a held world is changed
    </cell>|<\cell>
      roster_a is held, not built on; write a world <verbatim|from roster_a>
    </cell>>|<row|<\cell>
      a world builds on or holds itself
    </cell>|<\cell>
      roster_a \<rightarrow\> batch_a \<rightarrow\> roster_a
    </cell>>>>>

  <section|The interpreter><label|interpreter>

  Grant is implemented in Rust, with no dependencies. From the folder of its source, <verbatim|cargo install -<space|0spc>-path .> builds it and installs the command <verbatim|grant>.

  <tabular|<tformat|<twith|table-width|1par>|<twith|table-hmode|min>|<cwith|1|1|1|-1|cell-bborder|1ln>|<cwith|1|1|1|-1|cell-tborder|1ln>|<cwith|-1|-1|1|-1|cell-bborder|1ln>|<cwith|1|-1|1|-1|cell-hyphen|t>|<cwith|1|-1|1|-1|cell-halign|l>|<table|<row|<\cell>
      Command
    </cell>|<\cell>
      Does
    </cell>>|<row|<\cell>
      <verbatim|grant roster>
    </cell>|<\cell>
      runs the world <verbatim|roster.grant> and shows its questions
    </cell>>|<row|<\cell>
      <verbatim|grant check roster move>
    </cell>|<\cell>
      runs worlds quietly and reports only errors
    </cell>>|<row|<\cell>
      <verbatim|grant show roster>
    </cell>|<\cell>
      prints everything stated in a world, parents included
    </cell>>|<row|<\cell>
      <verbatim|grant watch roster>
    </cell>|<\cell>
      runs the world again whenever it, or anything it builds on, changes
    </cell>>|<row|<\cell>
      <verbatim|grant repl roster>
    </cell>|<\cell>
      states lines one at a time, on a world or from nothing
    </cell>>>>>

  Each question is shown with its answer beneath it.

  <\verbatim-code>
    $ grant harbor

    ? harbor is_at peace

    \ \ yes

    ? liz.knows

    \ \ harbor

    ? person p is_neighbour_of harbor

    \ \ liz
  </verbatim-code>

  An error names the world, the line and the cause. When a parent fails, the child reports it together with the parent's own error.

  <\verbatim-code>
    error in child (child.grant, line 1): \<#60\>roster\<#60\> has errors; fix it first

    \ \ \ \ 1 \| from roster

    error in roster (roster.grant, line 11): \<#60\>durham\<#60\> doesn't exist yet

    \ \ \ 11 \| harbor works_in durham
  </verbatim-code>

  <verbatim|grant watch> is how edits flow forward while writing: a child is a set of instructions, and it is run again on whatever its parents are now. In the REPL every line is a statement, as in a file; <verbatim|:check> runs the end-of-world checks, <verbatim|:show> prints what has been stated, and <verbatim|:save name> writes the lines to <verbatim|name.grant>.

  <subsection|Beyond the foundation>

  Foundation 1 fixes the primitives. What comes next is written in Grant itself: standard worlds for time and calendars, for ordered collections, and for common constraints. They are ordinary worlds, built only from the primitives.
</body>

<\initial>
  <\collection>
    <associate|html-css|grant.css>
    <associate|html-head-favicon|favicon.svg>
    <associate|html-title|The Grant Programming Language>
    <associate|page-medium|paper>
  </collection>
</initial>
