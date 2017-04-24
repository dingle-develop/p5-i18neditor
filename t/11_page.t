; use lib 'lib/'
; use Sub::Uplevel
; use Test::More 'no_plan' #tests => 1
; use strict; use warnings

; use dIngle::Library
; use dIngle::Library ('config','.')
; use I18nEditor::Project
; use dIngle::Waypoint
    
; my $prj = I18nEditor::Project->new
; dIngle::Waypoint::Init->project( $prj,{config => $prj->config})

; dIngle->init('I18nEditor')

; my $obj = dIngle->new    
     ( VisStyle     => 'sw'
     , VisFormatdir => ''
     , VisFile      => 'page'
     , VisModul     => 'I18nEditor'
     )
					    
; $obj->file_init()
						    
; ok(length( $obj->take("I18e Page") ) > 1024)

