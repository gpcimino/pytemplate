from setuptools import find_packages, setup


with open("requirements.txt") as rf:
    requirements = rf.readlines()
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
    zip_safe=False,
    install_requires=requirements,
    entry_points={
        'console_scripts': [
            'fizzbuzz = pytemplate.script:main'
        ]
    }
)
