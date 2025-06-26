!include "MUI2.nsh"

Name "DominatorAgent"
OutFile "DominatorAgentInstaller.exe"
InstallDir "$PROGRAMFILES\DominatorAgent"

Page Directory
Page InstFiles

Section "Install"
    SetOutPath "$INSTDIR"
    File /r "publish\*.*"
    nsExec::Exec '"$SYSDIR\sc.exe" create DominatorAgent binPath= "\"$INSTDIR\DominatorAgent.exe\"" start= auto'
    nsExec::Exec '"$SYSDIR\sc.exe" start DominatorAgent'
SectionEnd

Section "Uninstall"
    nsExec::Exec '"$SYSDIR\sc.exe" stop DominatorAgent'
    nsExec::Exec '"$SYSDIR\sc.exe" delete DominatorAgent'
    Delete "$INSTDIR\*.*"
    RMDir "$INSTDIR"
SectionEnd
