# Copyright 2004-2014 Sabayon
# Distributed under the terms of the GNU General Public License v2

EAPI=5

EGIT_REPO_URI="git://github.com/Rogentos/argent-live.git"
EGIT_COMMIT="v${PV}"

inherit eutils systemd git-2

DESCRIPTION="Argent live image scripts and tools"
HOMEPAGE="http://www.argentlinux.org"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 arm x86"
IUSE=""

DEPEND=""
RDEPEND="!app-misc/livecd-tools
	!sys-apps/gpu-detector
	app-eselect/eselect-opengl
	dev-util/dialog
	sys-apps/gawk
	sys-apps/pciutils
	sys-apps/keyboard-configuration-helpers
	sys-apps/sed"

src_install() {
	emake DESTDIR="${D}" SYSV_INITDIR="/etc/init.d" \
		SYSTEMD_UNITDIR="$(systemd_get_unitdir)" \
		install || die
}
