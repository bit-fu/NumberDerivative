# Derivatives of Numbers

Yes, there actually exists an idea how to derive a number.

In 1961, [this paper](http://cms.math.ca/cmb/v4/cmb1961v04.0117-0122.pdf) was published by Edward Barbeau.

[This article](http://rjlipton.wordpress.com/2014/08/19/the-derivative-of-a-number/) over at ***Gödel’s Lost Letter and P=NP*** explores it further.

The [on-line encyclopedia of integer sequences](http://oeis.org/A003415) has data and many references.

This is an implementation in a few lines of OCaml that produces a command line tool.  It prints the derivative of all its arguments.

Here's a shell session with the `numder` command:

```sh

$ ./numder 10 12 14 15 16 
7
16
9
8
32

```
