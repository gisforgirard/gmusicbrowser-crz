# Copyright (C) 2017 chinarulezzz <s.alex08@mail.ru>
#
# This file is part of Gmusicbrowser.
# Gmusicbrowser is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 3, as
# published by the Free Software Foundation

=for gmbplugin MEQUALIZER
name    Mequalizer
title   Set different equalizer settings for each song.
desc    Use Equalizer to (un)append equalizer options for all songs or each song.
=cut

package GMB::Plugin::MEQUALIZER;

use strict;
use warnings;
use constant OPT => 'PLUGIN_MEQUALIZER_';

my $handle;

::SetDefaultOptions(OPT,
    EQU_PRESET   => undef,
    EQU_AVAIL    => 0,
);

sub Save {
    my $is_active = shift;
    my $song_tag  = Songs::Display($::SongID, 'version');

    if ($is_active) {
        # Do not replace/save if current equalizer preset eq file tag
        unless ($song_tag eq $::Options{equalizer_preset})
        {
            warn "mequalizer: add '". $::Options{equalizer_preset} ."' to $::SongID\n";
            Songs::Set($::SongID, version => $::Options{equalizer_preset});
        }
    }
    else
    {
        # Erase tag only if tag exists in equalizer presets, and tag eq
        # current equalizer preset
        if (grep $_ eq $song_tag, ::GetPresets) {
            if ($song_tag eq $::Options{equalizer_preset})
            {
                warn "mequalizer: remove '". $::Options{equalizer_preset} ."' from $::SongID\n";
                Songs::Set($::SongID, version => "");
            }
        }
    }
}

sub Start {
    $handle = {};
    ::Watch($handle, PlayingSong => \&SongChanged);
}

sub Stop {
    ::UnWatch($handle, 'PlayingSong');
}

sub SongChanged {
    return unless defined $::SongID;

    my $preset = Songs::Display($::SongID, 'version');

    if ($preset && exists $::Options{equalizer_presets}{$preset}) {
        ::SetEqualizer(smart  => $preset);
        ::SetEqualizer(active => 1);
    } else {
        ::SetEqualizer(smart  => $::Options{OPT.'EQU_PRESET'});
        ::SetEqualizer(active => $::Options{OPT.'EQU_AVAIL'});
    }
}

sub prefbox {
    my $vbox = Gtk2::VBox->new(0, 2);
    my $desc = Gtk2::Label->new(
        _("!!!ATTENTION TORRENT USERS!!!\n".
          "Plugin write equalizers option into songs Version tag.\n".
          "So, the file hash will change, torrent client will overwrite the file,\n".
          "and equalizer settings will be lost. Be aware!\n")
      );
    $vbox->pack_start($desc, 0, 0, 1);
    return $vbox;
}

1
