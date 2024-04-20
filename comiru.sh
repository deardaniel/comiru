#!/bin/sh
cd "$(dirname "$0")"
ruby comiru.rb > ../public_html/comiru.ical
