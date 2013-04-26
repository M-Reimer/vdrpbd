pkgname=vdrpbd
pkgver=$(sed -rn 's/.*\$VERSION = .(.+?).;$/\1/p' vdrpbd)
pkgrel=1
pkgdesc="A daemon to handle ACPI power button event on VDR systems"
url="http://projects.vdr-developer.org/projects/vdrpbd"
arch=('any')
license=('GPL3')
depends=('perl' 'perl-net-dbus')
backup=('etc/vdrpbd.conf')

package() {
  cd "$startdir"
  make DESTDIR=$pkgdir PREFIX=/usr install
}
