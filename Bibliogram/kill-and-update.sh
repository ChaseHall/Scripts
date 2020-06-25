#!/bin/bash
screen -S Bibliogram -X quit
/usr/bin/screen -S Bibliogram -d -m /opt/bibliogram/bibliogram.sh

