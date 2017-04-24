; use lib 'lib/'
; use Sub::Uplevel
; use Test::More 'no_plan'
; use strict; use warnings

; use dIngle::Library
; use dIngle::Library ('config','.')

; BEGIN
    { use_ok("I18nEditor::Project")
    }
    
; my $prj = I18nEditor::Project->new
; dIngle::Waypoint::Init->project($prj,{config => $prj->config})

; dIngle->init('I18nEditor')

; is_deeply([dIngle::I18N->all_languages],['de','en'])
