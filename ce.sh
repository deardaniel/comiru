#!/bin/sh
cd "$(dirname "$0")"
ruby ce.rb > ../public_html/ce.ical
