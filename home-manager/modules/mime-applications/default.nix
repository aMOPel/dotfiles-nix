{
  config,
  lib,
  pkgs,
  pkgs_latest,
  ...
}:
let
  cfg = config.myModules.mime-applications;
in
{
  options.myModules.mime-applications = {
    enable = lib.mkEnableOption "mime-applications";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      zathura
      feh
      vlc
      mpv-unwrapped
    ];

    xdg = {
      enable = true;
      mimeApps = {
        enable = true;
        associations.removed = {
          "application/x-cbr" = [ "org.pwmt.zathura-cb.desktop" ];
          "application/x-rar" = [ "org.pwmt.zathura-cb.desktop" ];
          "application/x-cbz" = [ "org.pwmt.zathura-cb.desktop" ];
          "application/zip" = [ "org.pwmt.zathura-cb.desktop" ];
          "application/x-cb7" = [ "org.pwmt.zathura-cb.desktop" ];
          "application/x-7z-compressed" = [ "org.pwmt.zathura-cb.desktop" ];
          "application/x-cbt" = [ "org.pwmt.zathura-cb.desktop" ];
          "application/x-tar" = [ "org.pwmt.zathura-cb.desktop" ];
          "inode/directory" = [ "org.pwmt.zathura-cb.desktop" ];
        };
        defaultApplications = {
          # mime types extracted from .desktop files in ~/.nix-profile/share/applications
          "image/bmp" = [ "feh.desktop" ];
          "image/gif" = [ "feh.desktop" ];
          "image/jpeg" = [ "feh.desktop" ];
          "image/jpg" = [ "feh.desktop" ];
          "image/pjpeg" = [ "feh.desktop" ];
          "image/png" = [ "feh.desktop" ];
          "image/tiff" = [ "feh.desktop" ];
          "image/webp" = [ "feh.desktop" ];
          "image/x-bmp" = [ "feh.desktop" ];
          "image/x-pcx" = [ "feh.desktop" ];
          "image/x-png" = [ "feh.desktop" ];
          "image/x-portable-anymap" = [ "feh.desktop" ];
          "image/x-portable-bitmap" = [ "feh.desktop" ];
          "image/x-portable-graymap" = [ "feh.desktop" ];
          "image/x-portable-pixmap" = [ "feh.desktop" ];
          "image/x-tga" = [ "feh.desktop" ];
          "image/x-xbitmap" = [ "feh.desktop" ];
          "image/heic" = [ "feh.desktop" ];

          "application/ogg" = [ "mpv.desktop" ];
          "application/x-ogg" = [ "mpv.desktop" ];
          "application/mxf" = [ "mpv.desktop" ];
          "application/sdp" = [ "mpv.desktop" ];
          "application/smil" = [ "mpv.desktop" ];
          "application/x-smil" = [ "mpv.desktop" ];
          "application/streamingmedia" = [ "mpv.desktop" ];
          "application/x-streamingmedia" = [ "mpv.desktop" ];
          "application/vnd.rn-realmedia" = [ "mpv.desktop" ];
          "application/vnd.rn-realmedia-vbr" = [ "mpv.desktop" ];
          "audio/aac" = [ "mpv.desktop" ];
          "audio/x-aac" = [ "mpv.desktop" ];
          "audio/vnd.dolby.heaac.1" = [ "mpv.desktop" ];
          "audio/vnd.dolby.heaac.2" = [ "mpv.desktop" ];
          "audio/aiff" = [ "mpv.desktop" ];
          "audio/x-aiff" = [ "mpv.desktop" ];
          "audio/m4a" = [ "mpv.desktop" ];
          "audio/x-m4a" = [ "mpv.desktop" ];
          "application/x-extension-m4a" = [ "mpv.desktop" ];
          "audio/mp1" = [ "mpv.desktop" ];
          "audio/x-mp1" = [ "mpv.desktop" ];
          "audio/mp2" = [ "mpv.desktop" ];
          "audio/x-mp2" = [ "mpv.desktop" ];
          "audio/mp3" = [ "mpv.desktop" ];
          "audio/x-mp3" = [ "mpv.desktop" ];
          "audio/mpeg" = [ "mpv.desktop" ];
          "audio/mpeg2" = [ "mpv.desktop" ];
          "audio/mpeg3" = [ "mpv.desktop" ];
          "audio/mpegurl" = [ "mpv.desktop" ];
          "audio/x-mpegurl" = [ "mpv.desktop" ];
          "audio/mpg" = [ "mpv.desktop" ];
          "audio/x-mpg" = [ "mpv.desktop" ];
          "audio/rn-mpeg" = [ "mpv.desktop" ];
          "audio/musepack" = [ "mpv.desktop" ];
          "audio/x-musepack" = [ "mpv.desktop" ];
          "audio/ogg" = [ "mpv.desktop" ];
          "audio/scpls" = [ "mpv.desktop" ];
          "audio/x-scpls" = [ "mpv.desktop" ];
          "audio/vnd.rn-realaudio" = [ "mpv.desktop" ];
          "audio/wav" = [ "mpv.desktop" ];
          "audio/x-pn-wav" = [ "mpv.desktop" ];
          "audio/x-pn-windows-pcm" = [ "mpv.desktop" ];
          "audio/x-realaudio" = [ "mpv.desktop" ];
          "audio/x-pn-realaudio" = [ "mpv.desktop" ];
          "audio/x-ms-wma" = [ "mpv.desktop" ];
          "audio/x-pls" = [ "mpv.desktop" ];
          "audio/x-wav" = [ "mpv.desktop" ];
          "video/mpeg" = [ "mpv.desktop" ];
          "video/x-mpeg2" = [ "mpv.desktop" ];
          "video/x-mpeg3" = [ "mpv.desktop" ];
          "video/mp4v-es" = [ "mpv.desktop" ];
          "video/x-m4v" = [ "mpv.desktop" ];
          "video/mp4" = [ "mpv.desktop" ];
          "application/x-extension-mp4" = [ "mpv.desktop" ];
          "video/divx" = [ "mpv.desktop" ];
          "video/vnd.divx" = [ "mpv.desktop" ];
          "video/msvideo" = [ "mpv.desktop" ];
          "video/x-msvideo" = [ "mpv.desktop" ];
          "video/ogg" = [ "mpv.desktop" ];
          "video/quicktime" = [ "mpv.desktop" ];
          "video/vnd.rn-realvideo" = [ "mpv.desktop" ];
          "video/x-ms-afs" = [ "mpv.desktop" ];
          "video/x-ms-asf" = [ "mpv.desktop" ];
          "audio/x-ms-asf" = [ "mpv.desktop" ];
          "application/vnd.ms-asf" = [ "mpv.desktop" ];
          "video/x-ms-wmv" = [ "mpv.desktop" ];
          "video/x-ms-wmx" = [ "mpv.desktop" ];
          "video/x-ms-wvxvideo" = [ "mpv.desktop" ];
          "video/x-avi" = [ "mpv.desktop" ];
          "video/avi" = [ "mpv.desktop" ];
          "video/x-flic" = [ "mpv.desktop" ];
          "video/fli" = [ "mpv.desktop" ];
          "video/x-flc" = [ "mpv.desktop" ];
          "video/flv" = [ "mpv.desktop" ];
          "video/x-flv" = [ "mpv.desktop" ];
          "video/x-theora" = [ "mpv.desktop" ];
          "video/x-theora+ogg" = [ "mpv.desktop" ];
          "video/x-matroska" = [ "mpv.desktop" ];
          "video/mkv" = [ "mpv.desktop" ];
          "audio/x-matroska" = [ "mpv.desktop" ];
          "application/x-matroska" = [ "mpv.desktop" ];
          "video/webm" = [ "mpv.desktop" ];
          "audio/webm" = [ "mpv.desktop" ];
          "audio/vorbis" = [ "mpv.desktop" ];
          "audio/x-vorbis" = [ "mpv.desktop" ];
          "audio/x-vorbis+ogg" = [ "mpv.desktop" ];
          "video/x-ogm" = [ "mpv.desktop" ];
          "video/x-ogm+ogg" = [ "mpv.desktop" ];
          "application/x-ogm" = [ "mpv.desktop" ];
          "application/x-ogm-audio" = [ "mpv.desktop" ];
          "application/x-ogm-video" = [ "mpv.desktop" ];
          "application/x-shorten" = [ "mpv.desktop" ];
          "audio/x-shorten" = [ "mpv.desktop" ];
          "audio/x-ape" = [ "mpv.desktop" ];
          "audio/x-wavpack" = [ "mpv.desktop" ];
          "audio/x-tta" = [ "mpv.desktop" ];
          "audio/AMR" = [ "mpv.desktop" ];
          "audio/ac3" = [ "mpv.desktop" ];
          "audio/eac3" = [ "mpv.desktop" ];
          "audio/amr-wb" = [ "mpv.desktop" ];
          "video/mp2t" = [ "mpv.desktop" ];
          "audio/flac" = [ "mpv.desktop" ];
          "audio/mp4" = [ "mpv.desktop" ];
          "application/x-mpegurl" = [ "mpv.desktop" ];
          "video/vnd.mpegurl" = [ "mpv.desktop" ];
          "application/vnd.apple.mpegurl" = [ "mpv.desktop" ];
          "audio/x-pn-au" = [ "mpv.desktop" ];
          "video/3gp" = [ "mpv.desktop" ];
          "video/3gpp" = [ "mpv.desktop" ];
          "video/3gpp2" = [ "mpv.desktop" ];
          "audio/3gpp" = [ "mpv.desktop" ];
          "audio/3gpp2" = [ "mpv.desktop" ];
          "video/dv" = [ "mpv.desktop" ];
          "audio/dv" = [ "mpv.desktop" ];
          "audio/opus" = [ "mpv.desktop" ];
          "audio/vnd.dts" = [ "mpv.desktop" ];
          "audio/vnd.dts.hd" = [ "mpv.desktop" ];
          "audio/x-adpcm" = [ "mpv.desktop" ];
          "application/x-cue" = [ "mpv.desktop" ];
          "audio/m3u" = [ "mpv.desktop" ];

          "audio/x-speex" = [ "vlc.desktop" ];
          "application/x-flac" = [ "vlc.desktop" ];
          "audio/x-flac" = [ "vlc.desktop" ];
          "audio/x-ms-asx" = [ "vlc.desktop" ];
          "audio/x-ms-wax" = [ "vlc.desktop" ];
          "video/x-ms-asf-plugin" = [ "vlc.desktop" ];
          "video/x-ms-asx" = [ "vlc.desktop" ];
          "video/x-ms-wm" = [ "vlc.desktop" ];
          "video/x-ms-wvx" = [ "vlc.desktop" ];
          "audio/x-pn-windows-acm" = [ "vlc.desktop" ];
          "audio/x-pn-realaudio-plugin" = [ "vlc.desktop" ];
          "audio/x-mpeg" = [ "vlc.desktop" ];
          "video/mpeg-system" = [ "vlc.desktop" ];
          "application/mpeg4-iod" = [ "vlc.desktop" ];
          "application/x-quicktimeplayer" = [ "vlc.desktop" ];
          "audio/AMR-WB" = [ "vlc.desktop" ];
          "x-scheme-handler/mmsh" = [ "vlc.desktop" ];
          "x-scheme-handler/rtp" = [ "vlc.desktop" ];
          "x-scheme-handler/icy" = [ "vlc.desktop" ];
          "application/x-cd-image" = [ "vlc.desktop" ];
          "x-content/video-svcd" = [ "vlc.desktop" ];
          "x-content/audio-cdda" = [ "vlc.desktop" ];
          "application/ram" = [ "vlc.desktop" ];
          "text/google-video-pointer" = [ "vlc.desktop" ];
          "audio/x-pn-aiff" = [ "vlc.desktop" ];
          "video/x-nsv" = [ "vlc.desktop" ];
          "video/x-fli" = [ "vlc.desktop" ];
          "audio/vnd.dolby.mlp" = [ "vlc.desktop" ];
          "audio/basic" = [ "vlc.desktop" ];
          "audio/midi" = [ "vlc.desktop" ];
          "audio/x-gsm" = [ "vlc.desktop" ];
          "application/x-shockwave-flash" = [ "vlc.desktop" ];
          "application/x-flash-video" = [ "vlc.desktop" ];
          "misc/ultravox" = [ "vlc.desktop" ];
          "audio/x-it" = [ "vlc.desktop" ];
          "audio/x-s3m" = [ "vlc.desktop" ];

          "application/pdf" = [ "org.pwmt.zathura-pdf-mupdf.desktop" ];
          "application/oxps" = [ "org.pwmt.zathura-pdf-mupdf.desktop" ];
          "application/epub+zip" = [ "org.pwmt.zathura-pdf-mupdf.desktop" ];
          "application/x-fictionbook" = [ "org.pwmt.zathura-pdf-mupdf.desktop" ];

          "application/rdf+xml" = [ "brave-browser.desktop" ];
          "application/rss+xml" = [ "brave-browser.desktop" ];
          "application/xhtml+xml" = [ "brave-browser.desktop" ];
          "application/xhtml_xml" = [ "brave-browser.desktop" ];
          "application/xml" = [ "brave-browser.desktop" ];
          "text/html" = [ "brave-browser.desktop" ];
          "text/xml" = [ "brave-browser.desktop" ];
          "x-scheme-handler/http" = [ "brave-browser.desktop" ];
          "x-scheme-handler/https" = [ "brave-browser.desktop" ];

        };
      };
    };
  };
}
