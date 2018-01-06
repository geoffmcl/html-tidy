HTML::Tidy
==========
HTML::Tidy is an HTML checker in a handy dandy object.  It's meant as
a companion to [HTML::Lint][1], which is written in Perl but is not
nearly as capable as HTML::Tidy.


PREREQUISITES
=============
HTML::Tidy does very little work.  The real work of HTML::Tidy is
done by the [Tidy](http://www.html-tidy.org/) library, which is written in C.  
To use this HTML::Tidy perl wrapper, you must install **Tidy**!

There are few ways to install **Tidy**:

* Clone the github **Tidy** [source](https://github.com/htacg/tidy-html5), build and install it like any other C library. This is the best in that the default `next` branch contains the latest and greatest stable version. And later, as **Tidy** moves on, improves, a `git pull`, build, re-install, keeps you up-to-date...

* Get a zip/tarball from the **Tidy** [source](https://github.com/htacg/tidy-html5), build and install it, but this is more or less equivalent to the above, except you must repeat the process to get later versions. And **Tidy** provides some [binary](http://binaries.html-tidy.org/) releases.

* Your operating system may also have a package for **Tidy** that you can install, but this will seldom be the very latest, and like the zip/tarball, must be repeated to later upgrade.  

You need only do one of these steps.


INSTALLATION
============
Once you have **Tidy** installed via one of the previous methods, install HTML::Tidy like any standard Perl module, except for the setting of the environment `TIDY_ROOT` to point to where you installed **Tidy**.

#### Linux

    export TIDY_ROOT=/usr
    perl Makefile.PL
    make
    make test
    make install

There is a convenient `build-me.sh` script to do the above, except the install, which must be done separately, and may require `sudo` depending where the perl site libraries are installed.

In linux `HTML::Tidy`, i.e. `Tidy.so`, is linked with the **shared** `libtidy`, which should be installed in `/usr/lib`, or possibly `/usr/local/lib`, or other places depending on your system... but the perl build system should take care of this, and give a **warning** it it fails...

It may be possible to use a `libtidy.so` installed to other locations, but then to load and run this `Tidy.pm`, it may be necessary to `export LD_LIBRARY_PATH=/path/to/libtidy.so`, or something... before each run. Not recommended, explored or tested...

#### Windows

This is a build using Microsoft Visual Studio, the [community](https://www.visualstudio.com/vs/community/) version is free. The last build for me was using MSVC 14 2005 in 64-bit mode, to match my perl (v5.14.2) 64-bit, by [ActiveState](https://www.activestate.com/)...

    establish the appropriate MSVC x64/AMD64 build environment
    set TIDY_ROOT=d:\path\to\tidy\install
    perl Makefile.PL [verbose]
    perl scripts\modmakefile.pl Makefile -o Makefile.mak
    nmake /f Makefile.mak
    nmake /f Makefile.mak test
    nmake /f Makefile.mak install

Note the additional command - `perl scripts\modmakefile.pl Makefile -o Makefile.mak` - this is a **kludge** to get over the fact that the `perl makefile maker` scripts add a link option `-nodefaultlib`, which causes many missing `external` on the link. There should be a way to tell the `perl makefile maker` to omit this option, or somehow modify it, and this step would not be required.
   
There is a convenient `build-me.bat` script to do the above, except the install, which must be done separately, and may require `administrator` priviledges, depending where perl site libraries are installed. Some batch files used may not be available on your system, but they should only show a warning and not influence the build.

Normally when building and installing **Tidy** the default cmake location for the install is like `C:\Program Files\tidy`, which is **not** very convenient, and be warned, spaces is the path name may cause problems without extra effort. Thus when building and installing **Tidy** you should add an install location of your choice, like `cmake ..\.. -DCMAKE_INSTALL_PREFIX:PATH=d:\path\to\install\tidy`... Then you have a convenient path to use to set `TIDY_ROOT` here.

In Windows `HTML::Tidy`, i.e. `Tidy.dll`, is linked with the **static** library `tidys.lib`, so once linked and installed it no longer needs anything from the **Tidy** install. This is also so the **Tidy** DLL, `tidy.dll` does not clash with the `Tidy.dll` built here.

This project may also be buildable using say `MinGW`, or other windows build systems, but it is likely that you would also have to build **Tidy** using the **same** system. 

And of course this wrapper must be build with the **same** `bitness`, 32-bit or 64-bit, as your `perl` installation.

COPYRIGHT AND LICENSE
=====================
Copyright (C) 2004-2017 by Andy Lester

This library is free software.  It may be redistributed and modified
under the Artistic License v2.0.

  [1]: http://search.cpan.org/dist/HTML-Lint/       "HTML::Lint"

