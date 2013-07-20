# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit kde4-meta-pkg

DESCRIPTION="KDE internationalization package meta includer"
HOMEPAGE="http://www.kde.org/"
LICENSE="GPL-2"

KEYWORDS="~amd64 ~x86"
IUSE="debug_grade_1 "

# ignored: ca@valencia
MY_LANGS="ar bg bs ca cs da de el en_GB es et eu fa fi fr ga gl he
hi hr hu ia is it ja kk km ko lt lv nb nds nl nn pa pl pt pt_BR ro ru si sk sl
sr sv tg th tr ug uk vi wa zh_CN zh_TW"

DEPEND=""
RDEPEND="${DEPEND}
	!kde-base/kde-l10n-meta"
for MY_LANG in ${MY_LANGS} ; do
	IUSE="debug_grade_1 ${IUSE} linguas_${MY_LANG}"
	RDEPEND="${RDEPEND}
		linguas_${MY_LANG}? ( $(add_kdebase_dep kde-l10n-${MY_LANG}) )"
done

unset MY_LANG
unset MY_LANGS
