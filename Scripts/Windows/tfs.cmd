@echo off

IF "%~1"=="" (
    call ECHO No version specified. Call with '?' parameter to get a list of available versions
) ELSE (
    IF "%~1"=="?" (
        call ECHO Available versions:
        call ECHO -------------------
        call dir %PROGRAMDATA%\chocolatey\lib /b | findstr /i "terraform"
    ) ELSE (
        call ECHO %~1>"%UserProfile%/.terraform-version"
        call ECHO Selected version:
        call more "%UserProfile%/.terraform-version"
        call ECHO Performing reload of PowerShell profile. After that, you are ready to go!
        call ECHO -------------------
        call powershell & $profile
    )
)