#!/usr/bin/env raku

use Test;
use Slang::Date;

plan 2;

my $date = 2023-01-13;

is $date, Date.new(2023,1,13), "Friday the 13th";

{
    "use Slang::Date; 2023-01-99".EVAL;
    CATCH {
       is .message, 'Day out of range. Is: 99, should be in 1..31',
         'invalid date caught';
       exit
    }
}
flunk "Invalid date not caught";
