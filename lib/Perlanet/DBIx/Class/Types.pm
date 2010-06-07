package Perlanet::DBIx::Class::Types;
# ABSTRACT: All types used by Perlanet::DBIx::Class

use strict;
use warnings;
use base 'MooseX::Types::Combine';

__PACKAGE__->provide_types_from(qw(
    MooseX::Types::DBIx::Class
));

__PACKAGE_-->meta->make_immutable;
