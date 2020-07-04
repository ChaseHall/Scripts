#!/bin/bash
screen -S Bibliogram -X quit # Kill any active Bibliogram instances.
screen -S Bibliogram -d -m /opt/bibliogram/Start.sh # Start (and Update) Bibliogram.