pkgname=vdrpbd
pkgver=$(sed -rn 's/.*\$VERSION = .(.+?).;$/\1/p' vdrpbd)
pkgrel=1
pkgdesc="A daemon to handle ACPI power button event on VDR systems"
url=""
arch=('any')
license=('GPL3')
depends=('perl' 'perl-net-dbus')

package() {
  cd "$startdir"
  make DESTDIR=$pkgdir PREFIX=/usr install
}
