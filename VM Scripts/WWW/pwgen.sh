#!/bin/bash

pwlength=128
(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-$pwlength};echo;)