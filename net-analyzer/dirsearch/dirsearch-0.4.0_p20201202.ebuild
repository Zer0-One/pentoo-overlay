# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{5,6,7,8} )
PYTHON_REQ_USE="threads(+)"

inherit eutils python-single-r1

HASH_COMMIT="07726bbf4c5c540b0e1d974c77864a78ed21c386"
DESCRIPTION="A simple command line tool designed to brute force dirs and files in websites"
HOMEPAGE="https://github.com/maurosoria/dirsearch"
SRC_URI="https://github.com/maurosoria/dirsearch/archive/${HASH_COMMIT}.tar.gz -> ${P}.tar.gz"

#https://github.com/maurosoria/dirsearch/issues/650
#KEYWORDS="amd64 ~arm64 x86"
LICENSE="GPL-2"
SLOT="0"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}-${HASH_COMMIT}

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	#https://github.com/pentoo/pentoo-overlay/issues/512
#	eapply "${FILESDIR}/${P}_add_homedir_support-r1.patch"

	mv *.md Dockerfile  "${T}" || die
	python_fix_shebang -q "${S}"

	default
}

src_install() {
	insinto "/usr/share/${PN}"
	doins -r *

	python_optimize "${D}/usr/share/${PN}"

	make_wrapper $PN \
		"${PYTHON} /usr/share/${PN}/dirsearch.py"

	dodoc "${T}"/{*.md,Dockerfile}
}

pkg_postinst() {
	elog "\nExample: https://infosectoughguy.blogspot.com/2016/10/lazy-directory-searching-for-pentesters.html\n"
}
