  use Test::dIngle::Light
; use Test::More tests => 6

; BEGIN
    { use_ok("dIngle::Project::I18nEditor")
    }
    
; my $prj = dIngle::Project::I18nEditor->new

; isa_ok($prj,'dIngle::Project')

; my $str = "$prj"
; is( $str,"i18n_editor","name")

; is( $prj->configuration, undef, 'no default configuration')
; is( $prj->basedir, undef,'no default basedir')
; is( $prj->namespace, 'dIngle::I18nEditor', 'namespace ' . $prj->namespace)

#; use 5.014; use Data::Dumper
#; say Dumper($prj)