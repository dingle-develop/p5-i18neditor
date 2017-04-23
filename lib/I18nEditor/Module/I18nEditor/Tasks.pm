  package I18nEditor::Module::I18nEditor::Tasks
# *********************************************
; our $VERSION='0.01'
# *******************
; use basis 'dIngle::Tasks'

; use dIngle::I18N
; use dIngle::I18N::PO::File
; use dIngle::Tools::CGI

; use dIngle::Widget ('Site')

; use Test::Deep::NoTest
; use Perl6::Junction qw/ one           /
; use File::Basename  qw/ basename      /

; import from vishtml() => qw/Div Form H Pre Span Textarea Table Tr Th Td/
; import from visform() => qw/Hidden/

; use Data::Dumper

; sub setup
    {
; my $title = "I18N Editor"
    
#############################################
# Visible Output
#############################################
; vchestf("I18e Formular Error",sub
    { shift
    ; Div(@_)->style("color: red; background-color: grey;")
    })

#############################################
# Shared Site Attributes
#############################################
; vchestf("SITE TITLE",const($title))
; vchestf("SITE META",sub
    { node ( make("Meta Charset","utf8"))
    })

; vchestf("SITE SCRIPT",sub
    {''
    })

; vchestf("SITE STYLE",sub
    {''
    })

; vchestf("SITE BODY ATTR",sub
    { my ($obj,$body) = @_
    ; $body->stylye("background-color:#f5e000")
    })

; vchestf("SITE BODY",sub
    { my ($obj) = @_
    ; if( $obj->stash->{'pageid'} eq 'frameset' )
        { return make("Struct Use","Content")
        }
      elsif( $obj->stash->{'pageid'} eq 'formular' )
        { return make("I18e Formular",$obj->stash->{'cgi'})
        }
    })
    
#############################################
# Main Page - Frameset
#############################################
; chadd("I18e Page",
    { PERFORM => sub
        { my ($obj) = @_
        ; $obj->stash( pageid => 'frameset' )
        ; $obj << make("Struct Use","Site")
        ; ""
        }
    })

; vchestf("SN Content", const("Std::InlineWindow"))

; vchestf("InlineWindow Navi",sub
    { my ($obj)=@_
    ; my $callback
    ; $callback = sub
        { my @lst=@_
        ; make("Link Std",$lst[$#lst],"?pofile=".join("+",@lst))
            ->target("InlineWindow")
        }
    
    ; make("W2 treelist", delimiter => qr/_/
                        , list      => [make("I18e List .po Files")] 
                        , callback  => $callback)
    })

; vchestf("InlineWindow Src",sub
    { ""
    })

########################
# Editor Formular
########################
; chadd("I18e Formular Page",
    { PERFORM => sub
        { my ($obj,$cgi) = @_
        ; $obj->stash( pageid => 'formular', cgi => $cgi )
        ; $obj << make("dIngle Site")
        }
    })

; vchestf("I18e Formular", sub
    { my ($obj,$cgi)=@_
    ; my $keylang = 'de'
    ; my $domain  = $cgi->param('pofile')

    ; $domain =~ s/ /_/    
    
    ; my %languages = dIngle::I18N::_get_language_source($domain)
    
    # Erzeuge aus dem Formularinhalt die po Objekte in einer hashref
    ; my $poform = make("I18e process Formular"
        , cgi       => $cgi
        , domain    => $domain
        , languages => \%languages       
        )
                
    ; my %po
    ; foreach my $lang (make("I18e all languages"))
        { $po{$lang} = dIngle::I18N::Domain->load_po_file
            ( domain   => $domain
            , language => $lang
            , source   => $languages{$lang}
            )
        }
        
    ; unless($po{$keylang})
        { return make("I18e Formular Error"
            , "Schlüsselsprache ($keylang) ist nicht vorhanden.")
        }

    ; my @langs  = sort keys %po
    ; my $status = node()
    
    # Vergleiche die Datei mit dem Formular
    ; if(keys %$poform)
        { if( my @difflang = make("I18e Diff File <=> Form",\%po,$poform) )
            { foreach my $ln (@difflang)
                { # TODO update header
                ; my $filename = $po{$ln}->filename
                ; my $fh = IO::File->new($filename,'>:encoding(UTF-8)')
                ; unless($fh)
                    { $status << Div("Can't open filehandle for writing: $filename")
                    ; next
                    }
                ; $po{$ln}->write_fh($fh)
                ; $status << Div("File $filename written!")
                }
            }
        }
    
    ; my %lexicon
    ; foreach my $ln (@langs)
        { foreach my $entry ($po{$ln}->get_entries)  
            { $lexicon{$ln}{"$entry"} = $entry
            }
        }
    ; my @entries  = $po{$keylang}->get_entries
    
    ; my $header = make("I18e Formular Header",$domain)
    
    ; my $form = make("I18e Form",$cgi)
    
    ; foreach my $ec (0..$#entries)
        { my $entry = $entries[$ec]
        ; my $msgid = $entry->gettext_msgid()        
        ; my $occur = [$entry->occurrence]
        
        ; $form << make("I18e MsgId",$ec,$msgid) << newline()
                << (my $tab = Table())           << newline()
                
        ; $tab << make("I18e Occurrences",$ec,$occur)
        
        ; foreach my $ln (@langs)
            { my $msgstr = defined($lexicon{$ln}{"$entry"})
            	? $lexicon{$ln}{"$entry"}->gettext_msgstr() : ''
            ; $tab << make("I18e MsgStr",$ec,$ln,$msgstr)
            }
        }
    ; $form << make("I18e New MsgStr",0+@entries,\@langs)
    ; $form << make("I18e Controls")
    
    ; return Div($header,$status,$form)
    })

##################################
# Der Kopfbereich zur Anzeige
# und zum debuggen
##################################
; vchestf("I18e Formular Header",sub
    { my ($obj,$domain) = @_
    ; my $dm = Div("domain: ",Span($domain)->style("font-family: monospace"))
    
    ; my $fl   = make("I18e Show loaded files",$domain)
    
    ; node($dm,$fl)
    })

; import from vishtml() => qw/Dl Dt Dd/
; vchestf("I18e Show loaded files",sub
    { my ($obj,$domain) = @_
    
    ; my %files = dIngle::I18N::_get_language_source($domain)
    ; my $ln = Div("loading source files:")
    ; my $st = Dl()
    ; foreach my $lang (sort keys %files)
        { $st << Dt($lang) << Dd($files{$lang}) << newline()
        }
    ; $ln << $st
    })

##################################
# Das Formobjekt und die
# Eingabefelder
##################################
; vchestf("I18e Form",sub
    { my ($obj,$cgi) = @_
    ; my $form = Form()->name("i18neditor")->method('POST')
    ; $form->set_attribute('accept-charset','utf8')
    ; $form << Hidden()->name('pofile')->value($cgi->param('pofile'))
    })

; vchestf("I18e MsgId",sub
    { my ($obj,$num,$msgid) = @_
    ; my $name = sprintf("msgid%05d",$num)
    
    ; $msgid = make("I18e Form Output Filter",$msgid)    
    
    ; node( newline(), Hidden()->name($name)->value($msgid)
          , newline(), H(3,$msgid)
          )
    })

; vchestf("I18e MsgStr",sub
    { my ($obj,$num,$lang,$msgstr) = @_
    ; $msgstr ||= ''
    ; my $name = sprintf("msgstr%s%05d",$lang,$num)
    
    ; $msgstr = make("I18e Form Output Filter",$msgstr)    
    
    ; my $r = Tr("\n")
    ; $r << Td($lang) << Td
        ( Textarea($msgstr)->name($name)->rows(2)->cols(80) )
    })

; vchestf("I18e Occurrences",sub
    { my ($obj,$num,$pos) = @_
    ; $pos ||= []
    ; my $comment = join newline(),@$pos
    ; my $name = sprintf('occur%05d',$num)
    ; my $r = Tr(newline())
    ; $r << Td('references') << Td
        ( Textarea($comment)->name($name)->rows(2)->cols(80) )
    })

; vchestf("I18e New MsgStr",sub
    { my ($obj,$num,$langs) = @_
    ; my $msgid = sprintf("msgid%05d",$num)
    ; my $occur = sprintf('occur%05d',$num)
    
    ; my $tab = Table()
    ; $tab << Tr( Th("neuer Eintrag")->colspan(2)) << newline()
    
    ; $tab << Tr( Td('msgid') 
                , Td(Textarea("")->name($msgid)->rows(2)->cols(80))
                ) << newline()
           << Tr( Td('references')
                , Td(Textarea("")->name($occur)->rows(2)->cols(80))
                ) << newline()
    ; foreach my $ln ( @$langs )
        { my $msgstr = sprintf("msgstr%s%05d",$ln,$num)
        ; $tab << Tr( Td($ln)
                    , Td(Textarea("")->name($msgstr)->rows(2)->cols(80))
                    ) << newline()
        }
    ; $tab
    })

; vchestf("I18e Controls",alias("CONTROLS COMMON"))

########################
# INPUT & OUTPUT Filter
########################
; vchestf("I18e Form Output Filter",sub
    { my ($self,$str) = @_
    ; $str = dIngle::Tools::CGI::utf8_to_entities($str)
    ; return $str
    })
    
; vchestf("I18e Form Input Filter",sub
    { my ($self,$str) = @_
    ; $str = Encode::decode('UTF-8',$str)
    ; $str = dIngle::Tools::CGI::entities_to_utf8($str)
    ; return $str
    })

########################
# Process Formular
########################
; vchestf("I18e process Formular",sub
    { my ($obj,%args) = @_
    ; my $cgi       = $args{'cgi'}
    ; my $domain    = $args{'domain'}
    ; my %languages = %{$args{'languages'}}    
    
    ; my @param = $cgi->param
    
    ; my $poform = {}
    ; my @sen
    ; my %lang
    
    ; foreach my $p (@param)
        { my $num = substr($p,-5)
        ; $num =~ /^\d{5}$/ or next
        ; $num = int($num)
        
        ; $sen[$num] = { msgstr => {} } unless $sen[$num]
        
        ; if(substr($p,0,5) eq 'msgid' )
            { $sen[$num]->{'msgid'} = 
                make("I18e Form Input Filter",$cgi->param($p))
            }
          elsif(substr($p,0,5) eq 'occur')
            { $sen[$num]->{'occur'} = 
                make("I18e Form Input Filter",$cgi->param($p))
            }
          elsif(substr($p,0,6) eq 'msgstr')
            { my $lang = substr($p,6,2)
            ; $lang{$lang}++
            ; $sen[$num]->{'msgstr'}->{$lang} = 
                make("I18e Form Input Filter",$cgi->param($p))
            }
        }
        
    ; my $newentry = pop @sen
        
    ; foreach my $lang (keys %lang)
        { my $obj = dIngle::I18N::PO::File->new
            ( domain   => $domain
            , filename => $languages{$lang}
            )
        ; $obj->[$obj->_header] = Test::Deep::ignore()
            
        ; foreach my $e (@sen)
            { next unless ref $e
            ; my $entry = dIngle::I18N::PO::Entry->new            
                ( msgid  => [split(/\n/,$e->{'msgid'})]
                , msgstr => [split(/\n/,$e->{'msgstr'}->{$lang})]
                , occurrence => [split(/\n/,$e->{'occur'})]
                )
            ; $obj->entries('<',$entry)
            }
            
        # keep it simple - only msgid counts
        ; if($newentry->{'msgid'})
            { my $entry = dIngle::I18N::PO::Entry->new
            	( msgid  =>  [split(/\n/,$newentry->{'msgid'})]
            	, msgstr =>  [split(/\n/,$newentry->{'msgstr'}->{$lang})]
            	, occurrence => [split(/\n/,$newentry->{'occur'})]
            	)
            ; $obj->entries('<',$entry)
            }
             
        ; $poform->{$lang} = $obj
        }

    ; $poform
    })

; vchestf("I18e Diff File <=> Form",sub
    { my ($obj,$file,$form) = @_
    ; my (%diff)

    #; my $result = Test::Deep::cmp_deeply($file,$form)
    ; LANGUAGE:
      foreach my $lang (keys %$form )
        { my @file = $file->{$lang}->get_entries
        ; my @form = $form->{$lang}->get_entries
        
        ; foreach my $idx (0..$#form)
            { my ($fileentry,$formentry) = ($file[$idx],$form[$idx])
            	
            ; if(!$fileentry)
                { $file->{$lang}->entries('<',$formentry)
                ; $diff{$lang}++
                }
              elsif($formentry->compare($fileentry))
                { $diff{$lang}++
                
                ; foreach my $method (qw/msgid msgstr occurrence/)
                    { $fileentry->$method([$formentry->$method])
                    }
                }
            }
        }
    
    ; return sort keys %diff
    })
  
; vchestf("I18e Write .po Files",sub
    { my ($obj,$pofiles) = @_
    ; my $cgi = $obj->stash->{'cgi'}
    ; (my $pofile = $cgi->param('pofile')) =~ s/ /_/g
    
    ; foreach my $lang ( keys %$pofiles )
        { my $file = dIngle::I18N::Gettext->filename_po($lang,$pofile)
        ; dIngle::I18N::Gettext->write_po($pofiles->{$lang},$file)
        }
    })

################################################################################

# Diese Tasks waren für das erste Interface geplant.
; vchestf("I18e Select MsgId",sub
    { 
    })

; vchestf("I18n Input Comment",sub
    {
    })
     
; vchestf("I18n Input Msgstr",sub
    {
    })

################################################################################

; vchestf("I18e all languages",alias("I18N all languages"))

; chadd("I18e .po dir",
    { REQUIRE => sub 
        { @_ == 2 || return 0
        ; my @l = $_[0]->take("I18e all languages")
        ; $_[1] eq one(@l)
        }
    , PERFORM => sub
        { my ($obj,$lang)=@_
        ; my $dir = $obj->config_entry("development","devroot") 
                   . "locale/$lang/LC_MESSAGES"
        ; $dir
        }
    })
        
; vchestf("I18e List .po Files",sub
    { my ($obj,$lang) = (@_,"en")
    ; my $dir = $obj->take("I18e .po dir",$lang)
    
    ; my @d
    ; eval
        { opendir(DIR, $dir) or die "Can not read dir $dir."
        ; while( my $f=readdir(DIR) )
            { push @d,basename($f,'.po') if $f =~ /\.po$/
            }
        ; close DIR
        }
    ; push @d,$@ if $@ && $obj->debug_mode
    ; @d
    })
    
    } # end setup
    
; 1

__END__

