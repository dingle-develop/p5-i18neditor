  package dIngle::I18nEditor::Server
# **********************************
; our $VERSION='0.01'
# ******************
; use strict; use warnings; use utf8
; use parent 'dIngle::Server::OpenFrame'

################################################################
# This is an upload service, so it must use another
# Request class.
; use dIngle::Server::Segment::HTTP::Request

#; use dIngle::Server::Segment::dIngle::Query
#; use dIngle::Server::Segment::dIngle

# Im Grunde muss noch eine Menge gemacht werden bevor das Sinn macht.
; use dIngle::Server::Segment::dIngle

; sub default_port { 1810 }

; sub request_class { 'dIngle::Server::Segment::HTTP::Request' }

; sub load_segments
    { my ($self) = @_
    ; $self->pipeline->add_segment
        ( new dIngle::Server::Segment::dIngle::Query(as_cgi => 1)
        , new dIngle::Server::Segment::I18nEditor::Prepare()
        , new dIngle::Server::Segment::dIngle(module => 'I18nEdit')
        , new dIngle::Server::Segment::I18nEditor::Formular()
        , new dIngle::Server::Segment::I18nEditor::Page()
        )
    }
    
################################################################

; package dIngle::Server::Segment::I18nEditor
; use base 'dIngle::Server::Segment'

################################################################

; package dIngle::Server::Segment::I18nEditor::Prepare
; use base 'dIngle::Server::Segment::I18nEditor'

# set default values for dIngle Object
    
; sub dispatch
    { my ($self,$pipe) = @_
    ; $self->log("debug","Start preparation of i18n editor.")
    
    ; my $store = $pipe->store
    ; my $query = $store->get('dIngle::Query')
    
    ; unless( $query )
        { $self->log("warn","No dIngle::Query in ".ref($self).".")
        ; return undef
        }
        
    ; $query->db('I18nEdit')          if not $query->db   
                                       or $query->db   eq 'DEFAULT_MODULE'
    ; $query->site('i18editor.html')  if not $query->site 
                                       or $query->site eq 'DEFAULT_FORMAT'
                                       
    # Während der Entwicklung kann das nützlich sein.
    ; if(dIngle->debug_mode)
        { dIngle->init_modules('I18nEdit')
        ; $self->log("debug","Reload I18n")
        }
    ; return undef
    }
    
################################################################

; package dIngle::Server::Segment::I18nEditor::Page
; use base 'dIngle::Server::Segment::I18nEditor'

; use OpenFrame::Response
; use URI

; sub dispatch
    { my ($self,$pipe) = @_
    ; (my $place = __PACKAGE__) =~ s/.*Segment::// 
    ; $self->log("debug","Start $place")
        
    ; my $store = $pipe->store()
    ; my $dingle = $store->get('dIngle')

    ; return undef unless $dingle
    
    ; my $site = $dingle->take("I18e Page")
    ; my $response = OpenFrame::Response->new()
    
    ; $response->message("$site")
    ; $response->code( ofOK )
    ; $response->mimetype("text/html")

    ; return $response
    }

################################################################

; package dIngle::Server::Segment::I18nEditor::Formular
; use base 'dIngle::Server::Segment::I18nEditor'

; use OpenFrame::Response
; use URI

; use Data::Dumper

# Der Parameter pofile muss gesetzt sein.
; sub dispatch
    { my ($self,$pipe) = @_
    ; (my $place = __PACKAGE__) =~ s/.*Segment::// 
    ; $self->log("debug","Start $place")
        
    ; my $store    = $pipe->store()
    ; my $dingle = $store->get('dIngle')
    ; my $cgi      = $store->get('CGI')
    
    ; return undef unless $cgi && $dingle
    ; my $pofile = $cgi->param('pofile')
    ; return undef unless $pofile
    
    # Stellt den Inhalt des IFrames dar.
    ; my $site = $dingle->take("I18e Formular Page",$cgi)
    ; my $response = OpenFrame::Response->new()
    
    ; $response->message("$site")
    ; $response->code( ofOK )
    ; $response->mimetype("text/html")

    ; return $response
    }
    
; 1

__END__


