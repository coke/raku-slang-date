use nqp;
use QAST:from<NQP>;

sub EXPORT(|) {

    role DateLiteral::Grammar {
        # Patch the <value> rule to add a date literal type.
        token value:sym<date> {
            [ \d ** 4 ] '-' [ \d ** 2 ] '-' [ \d ** 2 ]
        }
    }

    role DateLiteral::Actions {
        method value:sym<date>(Mu $/) {
            CATCH { OUTER::<$/>.panic: .message }

            my $value := $/.Str.Date;
            $*W.add_object_if_no_sc($value);
            make QAST::WVal.new(:$value);
        }
    }

    # Patch the running grammar with our Grammar and Actions roles.
    $*LANG.define_slang(
        'MAIN',
        $*LANG.slang_grammar('MAIN').^mixin(DateLiteral::Grammar),
        $*LANG.slang_actions('MAIN').^mixin(DateLiteral::Actions),
    );

   BEGIN Map.new
}
