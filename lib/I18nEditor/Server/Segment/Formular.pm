  package I18nEditor::Server::Segment::Formular;
# **********************************************
  our $VERSION = '0.1';
# *********************
; use parent 'dIngle::Server::Segment'

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

