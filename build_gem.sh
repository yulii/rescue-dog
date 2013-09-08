#!/bin/sh
LIB_NAME="rescue-dog"
if [ $# -ne 2 ]
then
	echo "Usage: $0 {version} {target}"
	exit 1
fi
GEMSPEC="${LIB_NAME}.gemspec"
PKG_FILE="${LIB_NAME}-$1.gem"

echo "[RUN] gem install"
bundle install
echo "[RUN] rake"
bundle exec rake

if [ $? -eq 1 ]
then
	exit 1
fi
echo "[RUN] gem build ${GEMSPEC}"
gem build ${GEMSPEC}
if [ $? -eq 1 ]
then
	exit 1
fi

echo "[RUN] mv ${PKG_FILE} pkg/"
mv ${PKG_FILE} ./pkg

case "$2" in
	"install")
		echo "[RUN] rake install pkg/${PKG_FILE}"
		bundle exec rake install --trace
	;;
	"deploy")
		echo "[RUN] gem push pkg/${PKG_FILE}"
		gem push pkg/${PKG_FILE}

		echo "[RUN] git tag -a version-$1"
		git tag -a version-$1 -m ""
		git push --tags
	;;
	*)
		echo "FATAL: invalid target"
		exit 1
	;;
esac

