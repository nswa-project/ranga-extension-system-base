#!/bin/sh

. /extensions/ranga.ext.base/lib/extname.sh

_info() {
	echo "[ext-inst] $*"
}

errquit() {
	_info "$1"
	echo "result: install failed."
	rm -rf /tmp/_extinst
	exit 1
}

mkdir -p /tmp/_extinst
cd /tmp/_extinst
[ "$?" != '0' ] && errquit 'Internal error'

_info 'Receiving data...'
cat >ext.zip

_info 'Parsing the manifest file...'
pkgname=`unzip -p ext.zip manifest | head -n 1`
[ "$?" != '0' ] && errquit 'Package invaild'
[ "${pkgname:0:2}" != '@ ' ] && errquit 'Package invaild'

pkgname="${pkgname#@ }"
check_ext_name "$pkgname" || errquit 'Invaild package name'

_info "Installing extension: $pkgname"
dir="/extensions/${pkgname}"
mkdir "$dir"
[ ! -d "$dir" ] && errquit 'Internal error'

_info 'Unpacking package...'
unzip -o -q ext.zip -d "$dir" 2>&1 || errquit 'Unpack failed'

rm -rf /tmp/_extinst

/extensions/ranga.ext.base/update-caches.sh "${pkgname}"

echo "result: success"
exit 0
