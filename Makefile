VENV_NAME=.venv
VENV_BIN=${VENV_NAME}/bin
VENV_ACTIVATE=${VENV_BIN}/activate
PYTHON=${VENV_BIN}/python3
PIP=${VENV_BIN}/pip
SYSPYTHON=/usr/bin/python3
PROJECT=pytemplate


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
	@echo '    make clean           cleanup all temporary files'
	@echo '    make clean-venv      delete local venv'
	@echo
	@echo '    . ${VENV_ACTIVATE}   activate venv'
	@echo


venv: ${VENV_ACTIVATE}

${VENV_ACTIVATE}: requirements.txt
	test -d ${VENV_NAME} || ${SYSPYTHON} -m venv ${VENV_NAME}; \
	${PIP} install --upgrade pip; \
	${PIP} install -Ur requirements.txt; \
	${PIP} install -e .; \
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

clean-pyc:
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +
	find . -name '__pycache__' -exec rm -fr {} +

clean-test:
	rm -fr .tox/
	rm -f .coverage
	rm -fr htmlcov/

wheel: venv
	${PIP} install wheel
	${PYTHON} setup.py bdist_wheel


rpm:
	#dot="$(cd "$(dirname "$0")"; pwd)"
	dot=/home/giampaolo/projects/pytemplate
	appname=${PROJECT}
	install_dir=/opt/cmre/${appname}
	build_root=${dot}/build
	build_home=${build_root}${install_dir}
	pip=${build_home}/bin/pip
	rm -rf ${build_root}
	mkdir -p ${build_root}
	${SYSPYTHON} -m venv --copies ${build_home}
	${pip} install --upgrade pip
	${pip} install -r requirements.txt
	${pip} install "$(ls -t -d -1  dist/* | head -n 1)"
	${pip} uninstall -y pip

	find ${build_root} -type f  | xargs sed -i "s@$build_root@@g"
	find ${build_root} -iname *.pyc -exec rm {} \;
	find ${build_root} -iname *.pyo -exec rm {} \;

	rm -f ${appname}*.rpm
	fpm -t rpm -s dir -n ${appname} -C ${build_root} --verbose -d python36 .

