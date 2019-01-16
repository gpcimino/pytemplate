from setuptools import find_packages, setup


with open("requirements.txt") as rf:
    requirements = rf.readlines()
with open("README.rst") as rf:
    readme = rf.read()

setup(
    name='pytemplate',
    version='0.1.0',
    url="https://github.com/gpcimino/pytemplate",
    description='A Python Project Template',
    long_description=readme,
    author='Giampaolo Cimino',
    author_email='gcimino@gmail.com',
    license='Apache-2.0',
    classifiers=[
        'Development Status :: 1 - Planning',
        'Programming Language :: Python :: 3'
    ],
    keywords=['python'],
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
