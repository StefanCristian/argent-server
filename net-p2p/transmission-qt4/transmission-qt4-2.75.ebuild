# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit eutils transmission-2.75

DESCRIPTION="A Fast, Easy and Free BitTorrent client - Qt4 UI"
KEYWORDS="~amd64 ~x86"
IUSE="debug_grade_1 "

RDEPEND="x11-libs/qt-core:4
	x11-libs/qt-gui:4[dbus]
"
DEPEND="${RDEPEND}"

src_install() {
     if use debug_grade_1 ; then
   set -ex
       fi
	pushd qt >/dev/null
	dodoc README.txt

	dobin transmission-qt
	doman transmission-qt.1

	domenu ${MY_PN}-qt.desktop || die

	local res
	for res in 16 22 24 32 48; do
		newicon -s ${res} icons/hicolor_apps_${res}x${res}_${MY_PN}.png ${MY_PN}-qt.png
	done

	insinto /usr/share/kde4/services
	doins "${T}"/${MY_PN}-magnet.protocol

	insinto /usr/share/qt4/translations
	doins translations/*.qm
	popd >/dev/null
}
