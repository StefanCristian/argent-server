# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
TRANSMISSION_ECLASS_VERSION_OK=2.71
inherit transmission-2.71

DESCRIPTION="A BitTorrent client (meta package)"
#HOMEPAGE="http://www.transmissionbt.com/"
SRC_URI=""

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ayatana gtk lightweight qt4 xfs"

RDEPEND="
	~net-p2p/transmission-base-${PV}[lightweight=,xfs=]
	gtk? (
		~net-p2p/transmission-gtk-${PV}[ayatana=]
	)
	!gtk? (
		~net-p2p/transmission-cli-${PV}
	)"
