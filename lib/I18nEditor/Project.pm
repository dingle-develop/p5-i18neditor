  package I18nEditor::Project;
# ****************************
  our $VERSION='0.02';
# ********************
; use strict; use warnings; use utf8

; use parent 'dIngle::Project'

; sub init
    { my ($self,$name) = @_
    ; $self->set_namespace('I18nEditor')
    ; $self->SUPER::init(@_);
    ; unless(length($name))
        { $self->name('i18n_editor')
        }
    }

; 1

__END__

 
