#!/bin/sh
# $FreeBSD: src/tools/regression/fstest/tests/mkdir/11.t,v 1.1 2007/01/17 01:42:09 pjd Exp $

desc="mkdir returns ENOSPC if there are no free inodes on the file system on which the directory is being created"

dir=`dirname $0`
. ${dir}/../misc.sh

case "${os}:${fs}" in
FreeBSD:UFS)
	echo "1..3"

	n0=`namegen`
	n1=`namegen`

	expect 0 mkdir ${n0} 0755
	n=`mdconfig -a -n -t malloc -s 256k`
	newfs /dev/md${n} >/dev/null
	mount /dev/md${n} ${n0}
	i=0
	while :; do
		mkdir ${n0}/${i} >/dev/null 2>&1
		if [ $? -ne 0 ]; then
			break
		fi
		i=`expr $i + 1`
	done
	expect ENOSPC mkdir ${n0}/${n1} 0755
	umount /dev/md${n}
	mdconfig -d -u ${n}
	expect 0 rmdir ${n0}
	;;
*)
	quick_exit_ok
	;;
esac
