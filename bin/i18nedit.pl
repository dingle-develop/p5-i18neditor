#!/usr/bin/env perl

; use dIngle::Application
# Lokale site-lib laden
; use dIngle::Library ('config','.')
; use I18nEditor::Server
; use I18nEditor::Project
; use dIngle
; use dIngle::Waypoint

; BEGIN 
  { $dIngle::LOGGING    = 'Log::Log4Perl'
  }

; my $project = I18nEditor::Project->new
; dIngle::Waypoint::Init
    ->project($project,{config => $project->config})
#; dIngle->project($project)
; dIngle->module('I18nEditor')

; $dIngle::I18N::ALL_LANGUAGES = 1

; my $serv = create  I18nEditor::Server
; die $! unless $serv

; $serv->load_segments

; if( $Pipeline::VERSION > 3.10 )
    { require Pipeline::Analyser
    ; my $analyser = Pipeline::Analyser->new()
    ; $analyser->analyse( $serv->pipeline )
    }

; $serv->print_listening()
; $serv->run()

; END
    { if(0)
        { require Module::Versions::Report
        ; print Module::Versions::Report::report()
        }
    }

