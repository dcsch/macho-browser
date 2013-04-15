Mach-O Browser README
=====================

*Mach-O Browser* – A Mac application for browsing the contents of
[Mach-O](http://en.wikipedia.org/wiki/Mach-O) (Mach Object) files,
including executables, shared libraries, and intermediate object files.

Home: [githib.com/dcsch/macho-browser](https://github.com/dcsch/macho-browser)

Introduction
------------

*Mach-O Browser* aims to provide similar functionality to the
[otool](http://developer.apple.com/mac/library/documentation/Darwin/Reference/ManPages/man1/otool.1.html) and
[nm](http://developer.apple.com/mac/library/documentation/Darwin/Reference/ManPages/man1/nm.1.html)
command-line tools, but utilising the Aqua interface of Mac OS X.

Known Limitations
-----------------

The following load commands don't display any data:
- `LC_SYMSEG`
- `LC_THREAD`
- `LC_UNIXTHREAD`
- `LC_LOADFVMLIB`
- `LC_IDFVMLIB`
- `LC_IDENT`
- `LC_FVMFILE`
- `LC_PREPAGE`
- `LC_PREBOUND_DYLIB`
- `LC_ROUTINES`
- `LC_SUB_FRAMEWORK`
- `LC_SUB_UMBRELLA`
- `LC_SUB_CLIENT`
- `LC_SUB_LIBRARY`
- `LC_TWOLEVEL_HINTS`
- `LC_PREBIND_CKSUM`
- `LC_ROUTINES_64`
- `LC_RPATH`
- `LC_CODE_SIGNATURE`
- `LC_SEGMENT_SPLIT_INFO`
- `LC_REEXPORT_DYLIB`
- `LC_LAZY_LOAD_DYLIB`
- `LC_ENCRYPTION_INFO`
- `LC_DYLD_INFO`
- `LC_DYLD_INFO_ONLY`

Changes
-------

### Version 0.9(2)
- Removed extraneous control highlighting.
- Malformed load commands are highlighted in red.  (Only for segments so far.)

### Version 0.9(1)
- Initial public release.

[David Schweinsberg](mailto:david.schweinsberg@gmail.com)
