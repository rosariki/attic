#!/usr/bin/env perl

use warnings;
use strict;

use Plack::Handler::FCGI; # HACK: http://www.fastcgi.com/docs/faq.html#Perlfork
use FindBin;
use File::Spec;

my $server = Plack::Handler::FCGI->new();
my $app_path = File::Spec->catfile($FindBin::Bin, 'app.psgi');
my $app = Plack::Util::load_psgi($app_path);
$server->run($app);
