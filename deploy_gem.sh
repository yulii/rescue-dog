#!/bin/sh
LIB_NAME="rescue-dog"
if [ $# -ne 1 ]
then
	echo "invalid VERSION"
	exit 1
fi
GEMSPEC="${LIB_NAME}.gemspec"
PKG_FILE="${LIB_NAME}-$1.gem"

echo "[RUN] rspec"
rspec
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
echo "[RUN] gem push pkg/${PKG_FILE}"
gem push pkg/${PKG_FILE}

echo "[RUN] git tag -a version-${$1}"
git tag -a version-$1
git push --tags
