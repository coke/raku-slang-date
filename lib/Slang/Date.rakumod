my role Grammar {
    # Patch the <value> rule to add a date literal type.
    token value:sym<date> {
        [ \d ** 4 ] '-' [ \d ** 2 ] '-' [ \d ** 2 ]
    }
}

my role Actions {
    method value:sym<date>(Mu $/) {
        CATCH { OUTER::<$/>.panic: .message }
        my $string := $/.Str;

        # Running under the Raku grammar
        if self.^name.starts-with('Raku::') {
            use experimental :rakuast;
            # XXX fix this when we have anonymous constants in RakuAST
            # XXX for now codegen as $string.Date
            make RakuAST::ApplyPostfix.new(
              operand => RakuAST::StrLiteral.new($string),
              postfix => RakuAST::Call::Method.new(
                name => RakuAST::Name.from-identifier("Date")
              )
            );
        }

        # running under legacy grammar
        else {
            my $value := $string.Date;
            $*W.add_object_if_no_sc($value);
            use QAST:from<NQP>;
            make QAST::WVal.new(:$value);
        }
    }
}

use Slangify Grammar, Actions
