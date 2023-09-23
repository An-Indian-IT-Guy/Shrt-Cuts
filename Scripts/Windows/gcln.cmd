echo off
powershell -File %userprofile%\apps\gc.ps1 -repoUrl "%~1" -workspaceFolder "%~2"
