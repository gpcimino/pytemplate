VENV_NAME=.venv
VENV_BIN=${VENV_NAME}/bin
VENV_ACTIVATE=${VENV_BIN}/activate
PYTHON=${VENV_BIN}/python3
PIP=${VENV_BIN}/pip
SYSPYTHON=/usr/bin/python3
ROOT_PATH:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
PROJECT:=$(shell basename ${ROOT_PATH})
RPM_INSTALL_DIR:=/opt/acme/${PROJECT}
RPM_BUILD_ROOT:=${ROOT_PATH}/build
RPM_BUILD_HOME:=${RPM_BUILD_ROOT}${RPM_INSTALL_DIR}
RPM_PIP:=${RPM_BUILD_HOME}/bin/pip
BRANCH:=$(shell git rev-parse --abbrev-ref HEAD)
HASH:=$(shell git rev-parse HEAD)
FPM:=/usr/local/bin/fpm
include meta
WHEEL_FILE=${PROJECT}-${VERSION}-py3-none-any.whl
RMP_FILE=${PROJECT}-${VERSION}-1.x86_64.rpm



default:
	@echo "Makefile for $(PROJECT)"
	@echo
	@echo 'Usage:'
	@echo
	@echo '    make venv            install the package in a virtual environment'
	@echo '    make test            test with coverage report'
	@echo '    make safety          look for security vulnerabilities'
	@echo '    make pylint          linter'
	@echo '    make cc              show cyclomatic complexity (McCabe)'
	@echo '    make mi              show maintainability index score'
	@echo '    make rpm             create RPM package with embedded python binaries'
	@echo '    make clean           cleanup all temporary files'
	@echo '    make clean-venv      delete local venv'
	@echo '    make clean-build     cleanup artifacts (rpms, wheels)'
	@echo '    make clean-pyc       cleanup python bn files (pyc, pyo) files'	
	@echo
	@echo '    . ${VENV_ACTIVATE}   activate venv'
	@echo


venv: ${VENV_ACTIVATE}

${VENV_ACTIVATE}: requirements.txt
	test -d ${VENV_NAME} || ${SYSPYTHON} -m venv ${VENV_NAME}
	${PIP} install --upgrade pip
	${PIP} install -Ur requirements.txt
	${PIP} install -Ur requirements-dev.txt	
	${PIP} install -e .
	touch ${VENV_ACTIVATE}


test: venv ${VENV_BIN}/coverage 
	${VENV_BIN}/coverage run --include=$(PROJECT)/*.py  -m unittest discover -s tests/; \
	${VENV_BIN}/coverage report;

${VENV_BIN}/coverage:
	${PIP} install coverage

safety: venv ${VENV_BIN}/safety
	${VENV_BIN}/safety check

${VENV_BIN}/safety:
	${PIP} install safety

pylint: venv ${VENV_BIN}/pylint
	${VENV_BIN}/pylint --disable=C ${PROJECT}

${VENV_BIN}/pylint:
	${PIP} install pylint

cc: venv ${VENV_BIN}/radon
	radon cc -n D -a -s ${PROJECT}/*.py

mi: venv ${VENV_BIN}/radon
	radon mi ${PROJECT}/*.py

${VENV_BIN}/radon:
	${PIP} install radon

quality: test pylint cc mi

clean-venv:
	rm -Rf ${VENV_NAME}

clean: clean-build clean-pyc clean-test

clean-build:
	rm -fr build/
	rm -fr dist/
	rm -fr .eggs/
	find . -name '*.egg-info' -exec rm -fr {} +
	find . -name '*.egg' -exec rm -f {} +
	rm -f ${PROJECT}*.rpm
	rm -f ${PROJECT}/meta

clean-pyc:
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +
	find . -name '__pycache__' -exec rm -fr {} +

clean-test:
	rm -fr .tox/
	rm -f .coverage
	rm -fr htmlcov/

wheel: venv ${VENV_BIN}/wheel
	@echo make wheel
	cp meta ${PROJECT}/
	${PYTHON} setup.py bdist_wheel
	rm -f ${PROJECT}/meta

${VENV_BIN}/wheel:
	@echo install wheel
	${PIP} install wheel

rpm: wheel 
	echo ${USER}
	# add makes dependency to dist/*.rpm
	rm -Rf ${RPM_BUILD_ROOT}
	mkdir -p ${RPM_BUILD_ROOT}
	mkdir -p ${RPM_BUILD_HOME}/etc
	# use --copies to avoid symb links in the venv
	${SYSPYTHON} -m venv --copies ${RPM_BUILD_HOME}
	${RPM_PIP} install --upgrade pip
	${RPM_PIP} install -r requirements.txt
	${RPM_PIP} install "$(shell ls -t -d -1  dist/* | head -n 1)"
	# pip can be removed in the installation pkg
	${RPM_PIP} uninstall -y pip
	# make absolute paths local to root installation dir e.g. /opt/acme/, workaround to do not use virtaulenv(3)_tools
	find ${RPM_BUILD_ROOT} -type f -exec sed -i "s@${RPM_BUILD_ROOT}@@g" {} \;
	find ${RPM_BUILD_ROOT} -iname *.pyc -exec rm {} \;
	find ${RPM_BUILD_ROOT} -iname *.pyo -exec rm {} \;
	rm -f ${PROJECT}*.rpm
    # add --summary <== readme: https://github.com/jordansissel/fpm/issues/1536	
	fpm \
		-t rpm \
		-s dir \
		-n ${PROJECT} \
		-C ${RPM_BUILD_ROOT} \
		--verbose \
		-d python36 \
		--rpm-user ${USER}  \
		--rpm-group ${USER} \
		--version ${VERSION} \
		--url ${URL} \
		--license "${LICENSE}" \
		--maintainer "${AUTHOR}" \
		--description "${DESCRIPTION}" \
		--before-install rpm/preinst \
		--after-remove   rpm/postrm \
		.

