# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit transmission-2.76

DESCRIPTION="A Fast, Easy and Free BitTorrent client - base files"
KEYWORDS="~amd64 ~x86"
IUSE="debug_grade_1 lightweight xfs"

DEPEND="xfs? ( sys-fs/xfsprogs )"

DOCS="AUTHORS NEWS"

src_install() {
     if use debug_grade_1 ; then
   set -ex
       fi
	default
	rm "${ED}"/usr/share/${MY_PN}/web/LICENSE || die

	keepdir /var/{${MY_PN}/{config,downloads},log/${MY_PN}}
	fowners -R ${MY_PN}:${MY_PN} /var/{${MY_PN}/{,config,downloads},log/${MY_PN}}
	dolib.a "${S}/libtransmission/libtransmission.a"
}
