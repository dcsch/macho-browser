# Mach-O Browser

*Mach-O Browser* – A Mac application for browsing the contents of
[Mach-O](http://en.wikipedia.org/wiki/Mach-O) (Mach Object) files,
including executables, shared libraries, and intermediate object files.

Home: [githib.com/dcsch/macho-browser](https://github.com/dcsch/macho-browser)

## Introduction

*Mach-O Browser* aims to provide similar functionality to the
[otool](http://developer.apple.com/mac/library/documentation/Darwin/Reference/ManPages/man1/otool.1.html) and
[nm](http://developer.apple.com/mac/library/documentation/Darwin/Reference/ManPages/man1/nm.1.html)
command-line tools, but utilising the Aqua interface of macOS.

## Changes

### Version 0.9 (3)
- Added ability to open applications, which will load the executable named in the Info.plist.
- Added  `LC_RPATH`, `LC_MAIN`, `LC_DYLD_INFO`, `LC_DYLD_INFO_ONLY`.

### Version 0.9 (2)
- Removed extraneous control highlighting.
- Malformed load commands are highlighted in red.  (Only for segments so far.)

### Version 0.9 (1)
- Initial public release.
