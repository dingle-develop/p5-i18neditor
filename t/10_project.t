; use lib 'lib/'
; use Sub::Uplevel
; use Test::More tests => 9
; use strict; use warnings

; use dIngle::Library
; use dIngle::Library ('config','.')

; BEGIN
    { use_ok("I18nEditor::Project")
    }
    
; my $prj = I18nEditor::Project->new

; isa_ok($prj,'dIngle::Project')

; my $str = "$prj"
; is( $str,"i18n_editor","name")

; is( $prj->configuration, undef, 'no default configuration')
; is( $prj->basedir, undef,'no default basedir')
; is( $prj->namespace, 'I18nEditor', 'namespace ' . $prj->namespace)

; $prj->basedir(Cwd::getcwd())
; is($prj->basedir, Cwd::getcwd())

; $prj->load_config()
; isa_ok( $prj->configuration, 'dIngle::Project::Configuration',
 'configuration')
; is( $prj->namespace, 'I18nEditor', 'namespace ' . $prj->namespace)

; $prj->load_modules()
; use 5.014; use Data::Dumper
#; say Dumper($prj)
