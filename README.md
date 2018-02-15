gmusicbrowser - Jukebox for large collections of mp3/ogg/flac/mpc files
=======================================================================
URL: http://gmusicbrowser.org


This is my personal fork with some patches:

1) a few patches which is not accepted to mainstream
2) fixes to lyrics plugin & new musixmatch lyrics source
3) mequalizer plugin: save equalizer presets to the file and load them
when the playing startup


Main features
=============

- customizable window layouts
- artist/album lock : easily restrict playlist to current artist/album
- easy access to related songs (same artist/album/title)
- simple mass-tagging and mass-renaming
- support multiple genres for each song
- customizable labels can be set for each song
- filters with unlimited nesting of conditions
- customizable weighted random mode
- uses gstreamer, mpg123/ogg123, mplayer, mpv for playback.


Screenshot
==========
![image (372 KB)][scrshot img]


Requirements
============

- Perl Modules
    - ExtUtils::PkgConfig
    - ExtUtils::Depends
    - Cairo
    - Glib
    - Gtk2
    - Pango

    For plugins like MPRIS, Notify, etc will need these modules:
    - Net::DBus
    - Xml::Twig
    - Gtk2::Notify

    For trayicon support:
    - Gtk2::TrayIcon

    For Gstreamer1 playback support:
    - Glib::Object::Introspection
    - Gstreamer1

- Playback
    - mplayer           _or_
    - mpv               _or_
    - mpg123, ogg123    _or_
    - gstreamer


[scrshot img]:
https://raw.githubusercontent.com/chinarulezzz/gmusicbrowser-crz/master/scrshot.png
