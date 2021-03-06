# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit transmission-2.76

DESCRIPTION="A Fast, Easy and Free BitTorrent client - daemon"
KEYWORDS="~amd64 ~x86"
IUSE="debug_grade_1 "

src_install() {
     if use debug_grade_1 ; then
   set -ex
       fi
	dobin daemon/transmission-daemon
	dobin daemon/transmission-remote

	doman daemon/transmission-daemon.1
	doman daemon/transmission-remote.1

	newinitd "${FILESDIR}"/${MY_PN}-daemon.initd.8 ${MY_PN}-daemon
	newconfd "${FILESDIR}"/${MY_PN}-daemon.confd.3 ${MY_PN}-daemon
}
