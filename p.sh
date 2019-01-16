#!/bin/bash

set -x

dot="$(cd "$(dirname "$0")"; pwd)"
appname=pytemplate
install_dir=/opt/cmre/$appname
build_root=$dot/build
build_home=$build_root$install_dir
pip=$build_home/bin/pip

rm -rf $build_root
mkdir -p $build_root

python3 -m venv --copies $build_home
$pip install --upgrade pip
$pip install -r requirements.txt
$pip install "$(ls -t -d -1  dist/* | head -n 1)"
$pip uninstall -y pip

find $build_root -type f  | xargs sed -i "s@$build_root@@g"

find $build_root -iname *.pyc -exec rm {} \;
find $build_root -iname *.pyo -exec rm {} \;

rm -f $appname*.rpm

fpm \
	-t rpm \
	-s dir \
	-n pytemplate \
	-C $build_root \
	--verbose \
	-d python36 \
	.

set +x
