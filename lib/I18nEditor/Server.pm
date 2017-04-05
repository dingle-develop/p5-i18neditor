  package I18nEditor::Server
# **************************
; our $VERSION='0.02'
# *******************
; use strict; use warnings; use utf8
; use parent 'dIngle::Server::OpenFrame'

; use dIngle::Server::Segment::dIngle
; use dIngle::Server::Segment::Query
; use OpenFrame::Segment::HTTP::Request

; use I18nEditor::Server::Segment::Prepare
; use I18nEditor::Server::Segment::Formular
; use I18nEditor::Server::Segment::Page
        
; sub default_port { 1810 }

; sub request_class { 'OpenFrame::Segment::HTTP::Request' }

; sub load_segments
    { my ($self) = @_
    ; $self->pipeline->add_segment
        ( dIngle::Server::Segment::Query->new(as_cgi => 1)
        , I18nEditor::Server::Segment::Prepare->new()
        , dIngle::Server::Segment::dIngle->new(module => 'I18nEditor')
        , I18nEditor::Server::Segment::Formular->new()
        , I18nEditor::Server::Segment::Page->new()
        )
    }
    
; 1

__END__


