#!/usr/bin/env raku

use Test;
use Slang::Date;

plan 2;

my $date = 2023-01-13;

is $date, Date.new(2023,1,13), "Friday the 13th";

try {
    my $bad = 2023-01-99;
    CATCH {
       when  X::OutOfRange {
           ok True, "Invalid date caught";
           exit;
       }
       default {
           nok "Invalid date wrong error";
       }
    }
}
nok "Invalid date not caught";
