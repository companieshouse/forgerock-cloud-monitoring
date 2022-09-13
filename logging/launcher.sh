#!/bin/sh

case $(echo $LOG_SOURCE | tr 'a-z' 'A-Z') in
    "AM")
        ./tail_am
        ;;
    "IDM")
        ./tail_idm
        ;;
    *)
        echo "No valid LOG_SOURCE value found - should be AM or IDM. Found: \"${LOG_SOURCE}\""
        ;;
esac