
@echo off
echo ------------------Git Status------------------
git status
echo ------------------Formating------------------
powershell -File %userprofile%\apps\tfmt.ps1
echo ------------------GIT ADD ALL------------------
git add .
echo ------------------COMMIT------------------
git commit -m"%~1"
echo ------------------GIT PUSH------------------
git push
