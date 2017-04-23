  package I18nEditor::Server::Segment::Page;
# ******************************************
  our $VERSION = '0.1';
# *********************
; use parent 'dIngle::Server::Segment'

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

; 1

__END__

