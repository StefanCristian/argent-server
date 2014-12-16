# Copyright 2004-2014 Sabayon Linux
# Distributed under the terms of the GNU General Public License v2

EAPI="2"

inherit eutils

DESCRIPTION="Argent Linux Entropy Test Package (fooooon't install this)"
HOMEPAGE="http://www.argentlinux.org"
SRC_URI="mirror://sabayon/app-misc/entrofoo.tar.bz2"

RESTRICT="nomirror"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND=""
DEPEND=""

S="${WORKDIR}"

pkg_setup() {
	einfo "Hello, this is pkg_setup"
}

pkg_preinst() {
	einfo "Hello, this is pkg_preinst"
}

pkg_postinst() {
	einfo "Hello, this is pkg_postinst"
}

pkg_prerm() {
	einfo "Hello, this is pkg_prerm"
}

pkg_postrm() {
	einfo "Hello, this is pkg_postrm"
}

src_install () {
	# This is lame, but this is a lame ebuild too
	cp "${WORKDIR}/"* "${D}/" -R
}
