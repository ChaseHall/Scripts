#!/bin/bash
screen -S Bibliogram -X quit # Kill any active Bibliogram instances.
cd bibliogram
git pull # Actually update Bibliogram.
npm run start # Start it again.