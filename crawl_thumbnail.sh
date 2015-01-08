#! /bin/sh

if [ $# -ne 2 ]; then
  echo "usage: $0 url ID" >&2
  exit 1
fi

case `uname -a` in
  Darwin*)
    BIN=wkhtmltoimage-mac
    TIMEOUT=gtimeout
    RUN=
    OPTIONS=
    ;;
  *)
    BIN=wkhtmltoimage-amd64
    TIMEOUT=timeout
    RUN="xvfb-run --auto-servernum --server-args=\"-screen 0, 1024x768x24\""
    OPTIONS="--use-xserver"
    ;;
esac
ROOT=`dirname "$0"`

make_thumb() {
  convert "$1" -resize "$3^" -gravity North -crop "$3"+0+0 "$2"
}

CMD="($TIMEOUT 60 $RUN \"$ROOT/$BIN\" --height 768 $OPTIONS --javascript-delay 30000 \"$1\" /tmp/$2-orig.png || $TIMEOUT 60 $RUN \"$ROOT/$BIN\" --height 768 $OPTIONS --disable-javascript \"$1\" /tmp/$2.png) && make_thumb /tmp/$2-orig.png /tmp/$2-240x180.png 240x180 && make_thumb /tmp/$2-orig.png /tmp/$2-600x315.png 600x315 && make_thumb /tmp/$2-orig.png /tmp/$2.png 100x100"
eval $CMD
