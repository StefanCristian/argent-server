# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit transmission-2.76

DESCRIPTION="A Fast, Easy and Free BitTorrent client - command line (CLI) version"
KEYWORDS="~amd64 ~x86"
IUSE="debug_grade_1 "

src_install() {
     if use debug_grade_1 ; then
   set -ex
       fi
	dobin cli/transmission-cli
	doman cli/transmission-cli.1
}
