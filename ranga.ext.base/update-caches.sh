#!/bin/sh

if [ -z "$1" ]; then
	echo 'Re-building extensions cache...'
	cat /dev/null > /tmp/ranga-ext-hook
	for ext in `ls /extensions` ; do
		file="/extensions/${ext}/ranga-hook.lua"
		[ -f "$file" ] && echo "$ext" >> /tmp/ranga-ext-hook
	done
	echo "Done."
else
	echo "Updating cache for '${1}'..."
	file="/extensions/${1}/ranga-hook.lua"
	[ -f "$file" ] && echo "$1" >> /tmp/ranga-ext-hook
fi

exit 0
