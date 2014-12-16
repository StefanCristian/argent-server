# Copyright 2004-2010 Sabayon
# Copyright 2014 Argent
# Distributed under the terms of the GNU General Public License v2

DESCRIPTION="Argent live tool for X.Org video driver configuration"
HOMEPAGE="http://www.argentlinux.org"
SRC_URI=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64 ppc"
IUSE="debug_grade_1 "

RDEPEND=">=app-misc/rogentoslive-tools-1.6.0"
DEPEND=""

src_unpack () {
        cd "${WORKDIR}"
        cp "${FILESDIR}"/gpu-configuration . -p
}

src_install () {
	cd "${WORKDIR}"
	exeinto /sbin/
	doexe gpu-configuration
}

pkg_postinst() {
	local xorg_conf="${ROOT}/etc/X11/xorg.conf"
	if [ -f "${xorg_conf}" ]; then
		echo
		elog "Disabling UseEvents option in your xorg.conf if found"
		elog "This option is known to cause Segmentation Faults on"
		elog "NVIDIA GeForce 6xxx and 7xxx with >=nvidia-drivers-275.xx"
		echo
		# this is quite lame sed, but who cares
		sed -i "/Option.*UseEvents/ s/^/#/" "${xorg_conf}"
	fi
}
