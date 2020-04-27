#!/bin/sh

check_ext_name() {
	[ -z "$1" ] && return 1
	[ "${#1}" -gt 48 ] && return 1

	case "$1" in
	*/*|*..*|*$'\n'*)
		return 1
		;;
	esac

	echo "$1" | grep "^[a-zA-Z0-9_.]*$" >/dev/null 2>&1 || return 1

	return 0
}
