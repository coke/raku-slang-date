use nqp;
use QAST:from<NQP>;

sub EXPORT(|) {

    role DateLiteral::Grammar {
        # Patch the <value> rule to add a date literal type.
        rule value:sym<date> { <literaldate> }

        # Can't use the named captures below but they do prettify the expr
        token literaldate {
            $<year>=[ \d ** 4 ] '-' $<month>=[ \d ** 2 ] '-' $<day>=[ \d ** 2 ]
        }
    }

    role DateLiteral::Actions {
        method value:sym<date>(Mu $/) {
            # Utility to lookup our match info, h/t to Slang::Roman
            sub lk(Mu \h, \k) {
                nqp::atkey(nqp::findmethod(h, 'hash')(h), k)
            }
    
            # Ideally, we want to extract the already parsed Y/M/D, but we have to cheat:
            my ($y, $m, $d) = lk($/, 'literaldate').Str.split('-', :skip-empty);

            # Replace with Date.new(...)
            my $qast := QAST::Op.new(
                :op('callmethod'),
                :name('new'),
                QAST::WVal.new(:value(Date)),
                QAST::IVal.new( :value(+$y) ),
                QAST::IVal.new( :value(+$m) ),
                QAST::IVal.new( :value(+$d) )
            );

            $/.make($qast);
        }
    }

    # Patch the running grammar with our Grammar and Actions roles.
    $*LANG.define_slang(
        'MAIN',
        $*LANG.slang_grammar('MAIN').^mixin(DateLiteral::Grammar),
        $*LANG.slang_actions('MAIN').^mixin(DateLiteral::Actions),
    );

   {}
}
