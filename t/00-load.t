; use lib 'lib/'
; use strict; use warnings
; use Sub::Uplevel

; use dIngle::Library ('config','.')

; use Test::More tests => 8

###############################################################################
# I18N Editor Server / Basic Tests
###############################################################################

; BEGIN 
    { use_ok('I18nEditor::Server')
    ; use_ok('OpenFrame::Segment::HTTP::Request')
    ; use_ok('dIngle::Server::Segment::Query')
    ; use_ok('dIngle::Server::Segment')
    ; use_ok('I18nEditor::Server::Segment::Prepare')
    ; use_ok('I18nEditor::Server::Segment::Page')
    ; use_ok('I18nEditor::Server::Segment::Formular')
    ; use_ok('I18nEditor::Module::I18nEditor::Tasks')
    }
