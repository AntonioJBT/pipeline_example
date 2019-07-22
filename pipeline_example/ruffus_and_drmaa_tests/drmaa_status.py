#!/usr/bin/env python

import drmaa

def main():
    """ Query the system. """
    with drmaa.Session() as s:
        print('A DRMAA object was created')
        print('Supported contact strings: {}'.format(s.contact))
        print('Supported DRM systems: {}'.format(s.drmsInfo))
        print('Supported DRMAA implementations: {}'.format(s.drmaaImplementation))
#        print('Version %s' % s.version)

        print('Exiting')

#strings $DRMAA_LIBRARY_PATH | grep 1\.0 # provides de version

if __name__=='__main__':
    main()
