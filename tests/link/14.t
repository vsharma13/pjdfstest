#!/bin/sh
# $FreeBSD: src/tools/regression/fstest/tests/link/14.t,v 1.1 2007/01/17 01:42:09 pjd Exp $

desc="link returns EXDEV if the source and the destination files are on different file systems"

dir=`dirname $0`
. ${dir}/../misc.sh

case "${os}" in
FreeBSD)
	echo "1..8"

	n0=`namegen`
	n1=`namegen`
	n2=`namegen`

	expect 0 mkdir ${n0} 0755
	n=`mdconfig -a -n -t malloc -s 1m`
	newfs /dev/md${n} >/dev/null
	mount /dev/md${n} ${n0}
	expect 0 create ${n0}/${n1} 0644
	expect EXDEV link ${n0}/${n1} ${n2}
	expect 0 unlink ${n0}/${n1}
	expect 0 create ${n1} 0644
	expect EXDEV link ${n1} ${n0}/${n2}
	expect 0 unlink ${n1}
	umount /dev/md${n}
	mdconfig -d -u ${n}
	expect 0 rmdir ${n0}
	;;
*)
	quick_exit_ok
	;;
esac
