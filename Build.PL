#!/usr/bin/env perl

# Credits to http://damien.krotkine.com/the-player-of-games/
use strict;
use warnings;
use utf8;
use Module::Build;

my $builder = Module::Build->new(
     module_name => 'dIngle::I18nEditor',
     dist_version => '0.1.00',
     dist_author => [
	     'Mike Würfel <sknpp@cpan.org>'
     ],
     license => 'perl',
     dist_abstract => 'a software generator',
     requires => {
                  'perl' => '5.12.0',
	          'OpenFrame' => '3.05'
                 },
);

$builder->create_build_script();
