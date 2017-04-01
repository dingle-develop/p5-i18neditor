  package I18nEditor::Server::Segment::Prepare;
# *********************************************
  our $VERSION = '0.1';
# *********************
; use strict; use warnings
; use parent 'dIngle::Server::Segment'

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
    
; 1

__END__
