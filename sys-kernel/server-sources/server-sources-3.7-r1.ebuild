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

src_install() {
     if use debug_grade_1 ; then
   set -ex
       fi
	# Drop this workaround on the next bump
	local base_path="${S}/sabayon/config"
	for config in "${base_path}"/*x86.config; do
		echo "# CONFIG_SPL is not set" >> "${config}"
	done
	sabayon-kernel_src_install
}
