; use dIngle::Application
# Lokale site-lib laden
; use dIngle::Library ('config','.')
; use dIngle::Server::I18nEditor
; use dIngle

; $dIngle::I18N::ALL_LANGUAGES = 1

; my $serv = create  dIngle::Server::I18nEditor
; die $! unless $serv

; $serv->load_segments

; if( $Pipeline::VERSION > 3.10 )
    { require Pipeline::Analyser
    ; my $analyser = Pipeline::Analyser->new()
    ; $analyser->analyse( $serv->pipeline )
    }

; $serv->print_listening()
; $serv->run()

