# The Derivative of a Number

Yes, there actually exists an idea how to derive a number.

In 1961, [this paper](http://cms.math.ca/cmb/v4/cmb1961v04.0117-0122.pdf) (PDF) was published by Edward Barbeau.

[This article](http://rjlipton.wordpress.com/2014/08/19/the-derivative-of-a-number/) over at ***Gödel’s Lost Letter*** explores it further.

The [On-Line Encyclopedia of Integer Sequences](http://oeis.org/A003415) has data and many references.

This is an implementation in a few lines of [OCaml](http://ocaml.org) that produces a command line tool.  It prints the derivative of all its arguments.

Here's a shell session with the `numder` command:

```sh

$ ./numder 10 12 14 15 16 
10' = 7
12' = 16
14' = 9
15' = 8
16' = 32

```
