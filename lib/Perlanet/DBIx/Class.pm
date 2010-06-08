package Perlanet::DBIx::Class;
# ABSTRACT: Aggregate posts in a database using DBIx::Class

use Moose;
use Method::Signatures::Simple;
use namespace::autoclean;

use Carp;
use Devel::Dwarn;
use DateTime;
use Perlanet::DBIx::Class::Types qw( ResultSet );
use TryCatch;

extends 'Perlanet';

has 'post_resultset' => (
    does     => 'Perlanet::DBIx::Class::Role::PostResultSet',
    is       => 'ro',
    required => 1,
);

has 'feed_resultset' => (
    does     => 'Perlanet::DBIx::Class::Role::FeedResultSet',
    is       => 'ro',
    required => 1,
);

has '+feeds' => (
    lazy    => 1,
    default => sub  {
        my $self = shift;
        $self->feed_resultset->fetch_feeds;
    }
);

around 'select_entries' => sub {
    my $orig = shift;
    my ($self, @feeds) = @_;

    return grep {
        ! $self->post_resultset->has_post($_)
    } $self->$orig(@feeds);
};

override 'render' => sub {
    my ($self, $feed) = @_;

    foreach my $post (@{ $feed->entries }) {
        try {
            # Do that whole insert thing...
            $self->insert_post($post);
        }
        catch {
            Carp::cluck("ERROR: $_\n");
            Carp::cluck("ERROR: Post is:\n" . Dumper($post) . "\n");
            Carp::cluck("ERROR: Link URL is '" . $post->_entry->link . "'\n");
        };
    }
};

method insert_post ($post)
{
    $self->post_resultset->create_from_perlanet($post);
}

__PACKAGE__->meta->make_immutable;
