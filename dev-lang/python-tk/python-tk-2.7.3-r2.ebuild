# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/python/python-2.7.3-r2.ebuild,v 1.10 2012/07/03 16:24:00 ranger Exp $

EAPI="2"
WANT_AUTOMAKE="none"
WANT_LIBTOOL="none"

inherit autotools eutils flag-o-matic multilib pax-utils python toolchain-funcs

MY_P="Python-${PV}"

PATCHSET_REVISION="1"

DESCRIPTION="Tk libraries for Python (also provides IDLE)"
HOMEPAGE="http://www.python.org/"
SRC_URI="http://www.python.org/ftp/python/${PV}/${MY_P}.tar.bz2
	mirror://gentoo/python-gentoo-patches-${PV}-${PATCHSET_REVISION}.tar.bz2"

LICENSE="PSF-2"
SLOT="2.7"
PYTHON_ABI="${SLOT}"
KEYWORDS="amd64 x86"
IUSE="debug_grade_1 ipv6 +threads +wide-unicode"

RDEPEND="
	=dev-lang/python-${PVR}[-tk]
	ipv6? ( =dev-lang/python-${PVR}[ipv6] )
	threads? ( =dev-lang/python-${PVR}[threads] )
	wide-unicode? ( =dev-lang/python-${PVR}[wide-unicode] )
	>=dev-lang/tk-8.0
	dev-tcltk/blt"
DEPEND=">=sys-devel/autoconf-2.65
	${RDEPEND}
	$([[ "${PV}" == *_pre* ]] && echo "=${CATEGORY}/${PN}-${PV%%.*}*")
	dev-util/pkgconfig
	!sys-devel/gcc[libffi]"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	python_pkg_setup
}

src_prepare() {
	# Ensure that internal copies of expat, libffi and zlib are not used.
	rm -fr Modules/expat
	rm -fr Modules/_ctypes/libffi*
	rm -fr Modules/zlib

	if [[ "${PV}" =~ ^[[:digit:]]+\.[[:digit:]]+_pre ]]; then
		if [[ "$(hg branch)" != "default" ]]; then
			die "Invalid EHG_REVISION"
		fi
	fi

	if [[ "${PV}" =~ ^[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+_pre ]]; then
		if [[ "$(hg branch)" != "${SLOT}" ]]; then
			die "Invalid EHG_REVISION"
		fi

		if grep -Eq '#define PY_RELEASE_LEVEL[[:space:]]+PY_RELEASE_LEVEL_FINAL' Include/patchlevel.h; then
			# Update micro version, release level and version string.
			local micro_version="${PV%_pre*}"
			micro_version="${micro_version##*.}"
			local version_string="${PV%.*}.$((${micro_version} - 1))+"
			sed \
				-e "s/\(#define PY_MICRO_VERSION[[:space:]]\+\)[^[:space:]]\+/\1${micro_version}/" \
				-e "s/\(#define PY_RELEASE_LEVEL[[:space:]]\+\)[^[:space:]]\+/\1PY_RELEASE_LEVEL_ALPHA/" \
				-e "s/\(#define PY_VERSION[[:space:]]\+\"\)[^\"]\+\(\"\)/\1${version_string}\2/" \
				-i Include/patchlevel.h || die "sed failed"
		fi
	fi

	local excluded_patches
	if ! tc-is-cross-compiler; then
		excluded_patches="*_all_crosscompile.patch"
	fi

	EPATCH_EXCLUDE="${excluded_patches}" EPATCH_SUFFIX="patch" \
		epatch "${WORKDIR}/${PV}-${PATCHSET_REVISION}"

	sed -i -e "s:@@GENTOO_LIBDIR@@:$(get_libdir):g" \
		Lib/distutils/command/install.py \
		Lib/distutils/sysconfig.py \
		Lib/site.py \
		Lib/sysconfig.py \
		Lib/test/test_site.py \
		Makefile.pre.in \
		Modules/Setup.dist \
		Modules/getpath.c \
		setup.py || die "sed failed to replace @@GENTOO_LIBDIR@@"

	eautoreconf
}

src_configure() {
	# dbm module can be linked against berkdb or gdbm.
	# Defaults to gdbm when both are enabled, #204343.
	local disable
	disable+=" dbm"
	disable+=" _bsddb"
	disable+=" gdbm"
	disable+=" _curses _curses_panel"
	disable+=" readline"
	disable+=" _sqlite3"
	disable+=" _elementtree pyexpat"
	export PYTHON_DISABLE_MODULES="${disable}"

	if [[ -n "${PYTHON_DISABLE_MODULES}" ]]; then
		einfo "Disabled modules: ${PYTHON_DISABLE_MODULES}"
	fi

	if [[ "$(gcc-major-version)" -ge 4 ]]; then
		append-flags -fwrapv
	fi

	filter-flags -malign-double

	[[ "${ARCH}" == "alpha" ]] && append-flags -fPIC

	# https://bugs.gentoo.org/show_bug.cgi?id=50309
	if is-flagq -O3; then
		is-flagq -fstack-protector-all && replace-flags -O3 -O2
		use hardened && replace-flags -O3 -O2
	fi

	if tc-is-cross-compiler; then
		OPT="-O1" CFLAGS="" LDFLAGS="" CC="" \
		./configure --{build,host}=${CBUILD} || die "cross-configure failed"
		emake python Parser/pgen || die "cross-make failed"
		mv python hostpython
		mv Parser/pgen Parser/hostpgen
		make distclean
		sed -i \
			-e "/^HOSTPYTHON/s:=.*:=./hostpython:" \
			-e "/^HOSTPGEN/s:=.*:=./Parser/hostpgen:" \
			Makefile.pre.in || die "sed failed"
	fi

	# Export CXX so it ends up in /usr/lib/python2.X/config/Makefile.
	tc-export CXX

	# Set LDFLAGS so we link modules with -lpython2.7 correctly.
	# Needed on FreeBSD unless Python 2.7 is already installed.
	# Please query BSD team before removing this!
	append-ldflags "-L."

	OPT="" econf \
		--with-fpectl \
		--enable-shared \
		$(use_enable ipv6) \
		$(use_with threads) \
		$(use wide-unicode && echo "--enable-unicode=ucs4" || echo "--enable-unicode=ucs2") \
		--infodir='${prefix}/share/info' \
		--mandir='${prefix}/share/man' \
		--with-libc="" \
		--with-system-expat \
		--with-system-ffi
}

src_compile() {
	emake EPYTHON="python${PV%%.*}" || die "emake failed"
}

src_install() {
     if use debug_grade_1 ; then
   set -ex
       fi
	[[ -z "${ED}" ]] && ED="${D%/}${EPREFIX}/"

	emake DESTDIR="${D}" altinstall || die "emake altinstall failed"
	python_clean_installation_image -q

	mv "${ED}usr/bin/idle" "${ED}usr/bin/idle${SLOT}" || die
	rm -rf "${ED}"etc || die

	local myrelfile=""
	for myfile in `find "${ED}"usr/ -type f; find "${ED}"usr/ -type l`; do
		myrelfile="${myfile/${ED}}"
		case "${myrelfile}" in
			*lib-tk*)
				true ;;
			*_tkinter.so)
				true ;;
			*/idlelib/*)
				true ;;
			*bin/idle*)
				true ;;
			*)
				rm "${myfile}" || die ;;
		esac
	done

	# kill empty dirs from ${ED}
	local dropped
	while true; do
		dropped="0"
		for mydir in `find "${ED}"usr/ -type d -empty`; do
			if [ -d "${mydir}" ]; then
				rmdir "${mydir}" || die
				dropped="1"
			fi
		done
		[[ "${dropped}" = "0" ]] && break
	done
}

pkg_postinst() {
	python_mod_optimize -f -x "/(site-packages|test|tests)/" $(python_get_libdir)
}

pkg_postrm() {
	python_mod_cleanup $(python_get_libdir)
}
