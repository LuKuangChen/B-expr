# B-expression

The known [S-expression](https://en.wikipedia.org/wiki/S-expression) is a useful format.
Some programming languages (notably Scheme and Racket) use it as a low-level format in the processing of programs.

But this format is different from what can typically be found in computer programs.
Many widely used programming languages use groupers more than `()` and `[]`, and seperators more than white-space
characters. So I am wondering if we can find something like S-expression but more similar to typical computer
programs.

I should mentioned that this idea is inspired by [Shrubberry](https://github.com/mflatt/rhombus-prototype/blob/shrubbery/shrubbery/0000-shrubbery.md).

I also should mentioned that one benefit of having an intermediate format is to define a domain on which macros work on.

## The design

```
B-expr ::= block
         | groupOf("(", ")", ",")
         | groupOf("[", "]", ",")
         | groupOf("{", "}", ",")
block  ::= seq:
```
