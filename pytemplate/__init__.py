import os

from pytemplate.fizzbuzz import FizzBuzz

__all__ = ['FizzBuzz']

metafile = os.path.abspath(os.path.join(os.path.dirname( __file__ ), '..', 'meta'))
if not os.path.exists(metafile):
    metafile = os.path.abspath(os.path.join(os.path.dirname(__file__), 'meta'))


with open(metafile) as mf:
    meta = {
        k.strip():v.strip() for k, v in
        [l.strip().split("=")
        for l in mf
        if l.strip() != '' and not l.strip().startswith("#")]
   }

__version__ = meta['VERSION']
