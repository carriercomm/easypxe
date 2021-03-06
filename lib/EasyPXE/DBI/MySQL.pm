#!/usr/bin/perl -w

# Copyright (c) 2010 Jeremy Cole <jeremy@jcole.us>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

package EasyPXE::DBI::MySQL;

use strict;
use warnings;

use base qw( EasyPXE::Plugin );
our $VERSION = 1.00;

use DBI;

sub initialize_priority()
{
  return 1;
}

sub initialize($)
{
  my ($self) = @_;

  $self->connect;

  return $EasyPXE::Plugin::PLUGIN_STATUS_OK;
}

sub shutdown($)
{
  my ($self) = @_;

  #$self->disconnect;
}

sub dbh($)
{
  my ($self) = @_;

  return $self->{'DBH'};
}

sub connect
{
  my ($self) = @_;

  $self->{'DBH'} = DBI->connect(
    sprintf(
      "DBI:mysql:database=%s;host=%s;mysql_port=%s;mysql_socket=%s",
      $self->config->get('database'),
      $self->config->get('host'),
      $self->config->get('port'),
      $self->config->get('socket')
    ),
    $self->config->get('user'), $self->config->get('password')
  );
  
  unless($self->{'DBH'}) {
    print STDERR "Couldn't connect to MySQL server: ".$DBI::err."\n";
    return;
  }

  return $self->{'DBH'};
}

sub reconnect {
  my ($self) = @_;

  print STDERR "Oops, got disconnected from MySQL, reconnecting...\n";
  return $self->dbi_connect;
}
