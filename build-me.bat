@setlocal
@REM ####################
@REM setup
@set TMPLOG=bldlog-1.txt
@set BLDDIR=%CD%
@set TMPROOT=..\..\..

@set VCVERS=14
@set GENERATOR=Visual Studio %VCVERS% Win64
@set SET_BAT=%ProgramFiles(x86)%\Microsoft Visual Studio %VCVERS%.0\VC\vcvarsall.bat
@if NOT EXIST "%SET_BAT%" goto NOBAT

@set TMPPL=Makefile.PL
@if NOT EXIST %TMPPL% goto NOPL

@echo Begin %DATE% %TIME%, output to %TMPLOG%
@echo Begin %DATE% %TIME% > %TMPLOG%

@echo Doing: 'call "%SET_BAT%" %PROCESSOR_ARCHITECTURE%'
@echo Doing: 'call "%SET_BAT%" %PROCESSOR_ARCHITECTURE%' >> %TMPLOG%
@call "%SET_BAT%" %PROCESSOR_ARCHITECTURE% >> %TMPLOG% 2>&1
@if ERRORLEVEL 1 goto ERR0
@REM call setupqt64
@cd %BLDDIR%
@REM http://search.cpan.org/~bingos/ExtUtils-MakeMaker-7.24/lib/ExtUtils/MakeMaker.pm#How_To_Write_A_Makefile.PL
@REM Can maybe add 'LINKTYPE=static', also maybe to make
@set TMPOPTS=verbose
@set TMPCMD=perl -f %TMPPL% %TMPOPTS%
@echo Doing '%TMPCMD%'
@echo Doing '%TMPCMD%' >> %TMPLOG%
@%TMPCMD% >> %TMPLOG% 2>&1
@if ERRORLEVEL 1 goto ERR1

@echo Doing 'nmake'
@echo Doing 'nmake' >> %TMPLOG%
@nmake >> %TMPLOG% 2>&1
@if ERRORLEVEL 1 goto ERR2

@goto END

:NOBAT
@echo Error: Can NOT locate %SET_BAT%! *** FIX ME ***
@goto ISERR

:NOPL
@echo Error: Can NOT locate %TMPPL%! *** FIX ME ***
@goto ISERR

:ERR0
@echo Error: MSVC %VCVERS% setup error!!!
@goto ISERR

:ERR1
@echo Error doing '%TMPCMD%'! See %TMPLOG%
@goto ISERR

:ERR2
@echo Error doing 'nmake'! See %TMPLOG%
@goto ISERR

:ISERR
@echo Error Exist - See %TMPLOG%
@echo Error Exist >> %TMPLOG%
@endlocal
@exit /b 1

:END
@endlocal
@exit /b 0

@REM eof
