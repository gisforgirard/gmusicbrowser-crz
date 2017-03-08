# Copyright (C) 2017 chinarulezzz <s.alex08@mail.ru>
#
# This file is part of Gmusicbrowser.
# Gmusicbrowser is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 3, as
# published by the Free Software Foundation

=for gmbplugin MEQUALIZER
name    Mequalizer
title   Set different equalizer settings for each song.
desc    Use Equalizer (Audio/Use Equalizer/Open Equalizer) to (un)append equalizer options for all songs or each song.
=cut

package GMB::Plugin::MEQUALIZER;

use strict;
use warnings;
use constant OPT => 'PLUGIN_MEQUALIZER_';
use Data::Dumper;

my $handle;

::SetDefaultOptions(OPT,
    EQU_PRESET   => undef,
    EQU_AVAIL    => 0,
);

sub Save {
    my $is_active = shift;
    if ($is_active) {
        # Do not replace/save if current equalizer preset eq file tag
        warn "mequalizer: may be save?\n";
        unless (Songs::Display($::SongID, 'version') eq
                $::Options{equalizer_preset})
        {
            warn "mequalizer: Save tag\n";
            Songs::Set($::SongID, version => $::Options{equalizer_preset});
        }
    }
    else
    {
        # Erase tag only if tag exists in equalizer presets, and tag eq
        # current equalizer preset
        if (grep $_ eq Songs::Display($::SongID, 'version'), ::GetPresets) {
            warn "mequalizer: may be erasing tag?\n";
            if (Songs::Display($::SongID, 'version') eq
                $::Options{equalizer_preset})
            {
                warn "mequalizer: yep, erasing tag\n";
                Songs::Set($::SongID, version => "");
            }
        }
    };
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
          "So, the file hash will change, and torrent client will overwrite the file.\n".
          "Equalizer settings will be lost.\n")
      );
    $vbox->pack_start($desc, 0, 0, 1);
    return $vbox;
}

1
