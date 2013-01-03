package Attic::Hub::Page;

use strict;
use warnings;

use base 'Attic::Hub::None';

use File::Spec;
use Plack::Request;
use XML::LibXML;
use Attic::Template;
use URI::QueryParam;
use Data::Dumper;

my $log = Log::Log4perl->get_logger();

sub prepare_app {
	my $self = shift;
	my $html_doc = XML::LibXML->load_html(location => $self->{page}->path, recover => 2);
	if (my $date = $html_doc->findvalue('/html/head/meta[@name="Date" or @name="date" or @name="DATE"]/@content')) {
		$self->{date} = $date;
	}
	
	if (my $h1 = $html_doc->findvalue('/html/body/h1')) {
		$self->{title} = $h1;
	}
	elsif (my $title = $html_doc->findvalue('/html/head/title')) {
		$self->{title} = $title;
	}

	foreach my $directory_node ($html_doc->findnodes('//directories')) {
		my $dir = $directory_node->getAttribute('href') eq '.' ? $self->{hub}->{dir} : $self->{hub}->{dir}->{router}->directory(URI->new($directory_node->getAttribute('href')));
		$directory_node->parentNode->replaceChild($dir->directories_feed, $directory_node);
	}
	
	my $body = XML::LibXML::Element->new('body');
	foreach my $node ($html_doc->findnodes('/html/body/*')) {
		next if $node->nodeName eq 'h1';
		$body->appendChild($node);
	}

	$self->{body} = $body if $body->childNodes();
}

sub title {
	my $self = shift;
	if (exists $self->{title}) {
		return $self->{title};
	}
	else {
		if ($self->{hub}->name eq 'index') {
			return $self->{hub}->{dir}->name;
		}
		else {
			return $self->{hub}->name;
		}
	}
}

sub modification_time {
	shift->{page}->{status}->[9];
}

sub populate_entry {
	my $self = shift;
	my ($entry, $request) = @_;
	my $category = XML::Atom::Category->new();
	$category->term('page');
	$category->scheme('http://dp-net.com/2009/Atom/EntryType');
	$entry->category($category);
}

sub call {
	my $self = shift;
	my ($env) = @_;
	my $request = Plack::Request->new($env);
	my $entry = XML::Atom::Entry->new();

	$self->populate_entry($entry, $request);
	
	my ($day, $mon, $year) = (localtime $self->{page}->modification_time)[3..5];
	$entry->updated(sprintf "%04d-%02d-%02d", 1900 + $year, 1 + $mon, $day);
	
	$entry->title($self->title);
	
	$entry->content(XML::Atom::Content->new());
	foreach my $node ($self->{body}->childNodes) {
		$entry->content->elem->appendChild($node);
	}

	$self->{hub}->{dir}->populate_siblings($entry, $self->{hub}->name);
	$entry->add_link($self->{hub}->parent_link);
	
	if ($request->param('type') and $request->param('type') eq 'atom') {
		return [200, ['Content-type', 'text/xml'], [$entry->as_xml]];
	}
	else {
		return [200, ['Content-type', 'text/html'], [Attic::Template->transform('page', $entry->elem->ownerDocument)]];
	}
}

1;
