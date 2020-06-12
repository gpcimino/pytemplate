import re
from setuptools import find_packages, setup


with open("requirements.txt") as rf:
    requirements = rf.readlines()
# to understand the statement below read https://packaging.python.org/discussions/install-requires-vs-requirements/
requirements = list(set([re.split(' |@|;|==', r)[0] for r in requirements if r!='']))

with open("README.rst") as rf:
    readme = rf.read()
with open("meta") as rf:
    meta = {
        k.strip():v.strip() for k, v in
        [l.strip().split("=")
        for l in rf
        if l.strip() != '' and not l.strip().startswith("#")]
    }

setup(
    name=meta['NAME'],
    version=meta['VERSION'],
    url=meta['URL'],
    description=meta['DESCRIPTION'],
    long_description=readme,
    author=meta['AUTHOR'],
    author_email=meta['AUTHOR_EMAIL'],
    license=meta['LICENSE'],
    classifiers=[
        'Development Status :: 1 - Planning',
        'Programming Language :: Python :: 3'
    ],
    keywords=['python'],
    platforms=['any'],
    packages=find_packages(),
    include_package_data=True,
    # package_dir={'pytemplate': 'pytemplate'},
    # package_data={
    #     'datazookeeper': [
    #         'meta',
    #         'etc/whatever'
    #     ]
    # },    
    zip_safe=False,
    install_requires=requirements,
    entry_points={
        'console_scripts': [
            'fizzbuzz = pytemplate.script:main'
        ]
    }
)
