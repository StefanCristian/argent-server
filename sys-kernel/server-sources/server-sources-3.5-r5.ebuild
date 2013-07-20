# Copyright 2004-2010 Sabayon Linux
# Distributed under the terms of the GNU General Public License v2

K_SABKERNEL_SELF_TARBALL_NAME="sabayon"
K_SABKERNEL_NAME="server"
K_ONLY_SOURCES="1"
K_SABKERNEL_FORCE_SUBLEVEL="0"
inherit sabayon-kernel
KEYWORDS="~amd64 ~x86"
DESCRIPTION="Official Sabayon Linux Server kernel sources"
RESTRICT="mirror"
IUSE="debug_grade_1 sources_standalone"

DEPEND="${DEPEND}
	sources_standalone? ( !=sys-kernel/linux-server-${PVR} )
	!sources_standalone? ( =sys-kernel/linux-server-${PVR} )"

src_unpack() {
        sabayon-kernel_src_unpack
        if use amd64; then
                cd "${S}" || die
                epatch "${FILESDIR}/__pte_alloc_kernel-gentoo-bug-416685.patch"
        fi
}
