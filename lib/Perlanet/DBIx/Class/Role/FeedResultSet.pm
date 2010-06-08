package Perlanet::DBIx::Class::Role::FeedResultSet;
# ABSTRACT: Role for the ResultSet which contains a list of feeds to aggregate

use strict;
use warnings FATAL => 'all';

use Moose::Role;
use Method::Signatures::Simple;
use namespace::autoclean;

method fetch_feeds {
    return [ map { $self->munge_feed_from_db($_) } $self->all ];
}

method munge_feed_from_db ($feed)
{
    return Perlanet::Feed->new(
        id      => $feed->id,
        url     => $feed->url  || $feed->link,
        website => $feed->link || $feed->url,
        title   => $feed->title,
        author  => $feed->owner,
    )
}

1;
