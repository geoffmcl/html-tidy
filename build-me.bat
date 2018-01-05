@setlocal
@REM ####################
@REM setup
@set MODMKFIL=1
@set NEWMKFIL=Makefile.mak
@set TMPLOG=bldlog-1.txt
@set BLDDIR=%CD%
@set TMPROOT=..\..\..
@set MKFIL=Makefile
@set TMPTARG=blib\arch\auto\HTML\Tidy\Tidy.dll

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
@REM Remove/Rename previous Makefile
@if EXIST Makefile @del Makefile
@REM  http://search.cpan.org/~bingos/ExtUtils-MakeMaker-7.24/lib/ExtUtils/MakeMaker.pm#How_To_Write_A_Makefile.PL
@REM Can maybe add 'LINKTYPE=static', also maybe to make
@set TMPOPTS=verbose
@set TMPCMD=perl -f %TMPPL% %TMPOPTS%
@echo Doing '%TMPCMD%'
@echo Doing '%TMPCMD%' >> %TMPLOG%
@%TMPCMD% >> %TMPLOG% 2>&1
@if ERRORLEVEL 1 goto ERR1
@if NOT EXIST Makefile goto NOMAKE

@REM ****************************************************************************************
@if NOT "%MODMKFIL%x" == "1x" goto DNMKFIL
@REM Until 'ExtUtils::MakeMaker' can be convinced to **NOT** add `-nodefaultlib` to 'Makefile'
@echo Doing 'call modmakefile Makefile -o %NEWMKFIL%'
@echo Doing 'call modmakefile Makefile -o %NEWMKFIL%' >> %TMPLOG%
@call modmakefile Makefile -o %NEWMKFIL% >> %TMPLOG%
@set MKFIL=%NEWMKFIL%
:DNMKFIL
@REM ****************************************************************************************
@if EXIST %TMPTARG% @del %TMPTARG%
@echo Doing 'nmake /f %MKFIL%'
@echo Doing 'nmake /f %MKFIL%' >> %TMPLOG%
@nmake /f %MKFIL% >> %TMPLOG% 2>&1
@if ERRORLEVEL 1 goto ERR2
@if NOT EXIST %TMPTARG% goto NOBLD
@echo.
@call dirmin %TMPTARG%
@echo Appears a successful build of 'Tidy.dll'
@echo.
@echo Do you want to run the 'tests'?
@echo.
@pause
@echo.
@echo Doing 'nmake /f %MKFIL% test'
@echo Doing 'nmake /f %MKFIL% test' >> %TMPLOG%
@nmake /f %MKFIL% test >> %TMPLOG% 2>&1
@if ERRORLEVEL 1 goto ERR4
@echo Appears a successful 'test'
@echo.
@goto END

:NOBLD
@echo Error: Appears build of %TMPTARG% FAILED!
@goto ISERR

:NOBAT
@echo Error: Can NOT locate %SET_BAT%! *** FIX ME ***
@goto ISERR

:NOPL
@echo Error: Can NOT locate %TMPPL%! *** FIX ME ***
@goto ISERR

:ERR0
@echo Error: MSVC %VCVERS% setup error!!!
@goto ISERR

:NOMAKE
@echo Error: Appears NO Makefile created
:ERR1
@echo Error doing '%TMPCMD%'! See %TMPLOG%
@goto ISERR

:ERR2
@echo Error doing 'nmake'! See %TMPLOG%
@goto ISERR

:ERR4
@echo Error doing 'nmake test'! See %TMPLOG%
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
