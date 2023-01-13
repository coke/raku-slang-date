# Slang::Date

A Slang for Raku that adds support for literal dates in ISO-8601 style.

## Examples

Replaces the ISO String with a QAST node that generates a call to Date.new...; 

    my $a = 2023-01-13;
    say "Happy Friday the 13th" if  $a.day-of-week == 5;

Invalid dates will error out as expected:

    my $b = 2023-01-99;

```
Day out of range. Is: 99, should be in 1..31
  in block <unit> at -e line 1
```

## Notes

Requires a 4 digit year, 2 digit month, and 2 digit day.
