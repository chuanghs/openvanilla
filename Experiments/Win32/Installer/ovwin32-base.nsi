; Script generated by the HM NIS Edit Script Wizard.

; HM NIS Edit Wizard helper defines
!define PRODUCT_NAME "OpenVanilla"
!define PRODUCT_VERSION "0.7.2rc1-20051116"
!define PRODUCT_PUBLISHER "openvanilla.org"
!define PRODUCT_WEB_SITE "http://openvanilla.org"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"
!define IME_ROOT_KEY "HKLM"
!define IME_KEY "SYSTEM\CurrentControlSet\Control\Keyboard Layouts\"
!define IME_KEY_USER "Keyboard Layout\Preload"

SetCompressor lzma

; MUI 1.67 compatible ------
!include "MUI.nsh"

; MUI Settings
!define MUI_ABORTWARNING
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\modern-install.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"

; Language Selection Dialog Settings
!define MUI_LANGDLL_REGISTRY_ROOT "${PRODUCT_UNINST_ROOT_KEY}"
!define MUI_LANGDLL_REGISTRY_KEY "${PRODUCT_UNINST_KEY}"
!define MUI_LANGDLL_REGISTRY_VALUENAME "NSIS:Language"

; Welcome page
!insertmacro MUI_PAGE_WELCOME
; License page
!insertmacro MUI_PAGE_LICENSE "..\..\..\Documents\OSX\Installer\zh_TW.lproj\License.rtf"
; Directory page
;!insertmacro MUI_PAGE_DIRECTORY
; Instfiles page
!insertmacro MUI_PAGE_INSTFILES
; Finish page
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_INSTFILES

; Language files
!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_LANGUAGE "TradChinese"

; Reserve files
!insertmacro MUI_RESERVEFILE_INSTALLOPTIONS

; MUI end ------

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "OpenVanilla-Win32.exe"
InstallDir "$WINDIR\OpenVanilla"
ShowInstDetails show
ShowUnInstDetails show

Function .onInit
  ReadRegStr $0 ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Key"
  StrCmp $0 "" +3 0
	  MessageBox MB_ICONINFORMATION|MB_OK "偵測到已安裝 OpenVanilla ，請移除後重新安裝。"
	  Abort
  !insertmacro MUI_LANGDLL_DISPLAY
FunctionEnd

Section "MainSection" SEC01
  SetOutPath "$SYSDIR"
  SetOverwrite ifnewer
  File "System32\OVIME.ime"
  File "System32\libltdl3.dll"
  File "System32\libiconv-2.dll"
  File "System32\tinyxml.dll"
  File "System32\OVIMEUI.DLL"
  File "System32\OVIME.ime"
SectionEnd

Section "Modules" SEC02
  SetOutPath "$WINDIR\OpenVanilla"
  SetOVerwrite ifnewer
  File /r "zh_TW"
  File "OVPreferences.exe"
  File "OVPreferences.exe.manifest"
  SetOutPath "$WINDIR\OpenVanilla\Modules"
  File "Modules\OVIMRoman.DLL"
SectionEnd

Section -AdditionalIcons
  SetOutPath $INSTDIR
  CreateDirectory "$SMPROGRAMS\OpenVanilla"
  CreateShortCut "$SMPROGRAMS\OpenVanilla\Uninstall.lnk" "$INSTDIR\uninst.exe"
  CreateShortCut "$SMPROGRAMS\OpenVanilla\OVPreferences.lnk" "$WINDIR\OpenVanilla\OVPreferences.exe"
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
  System::Call 'imm32::ImmInstallIME(t "$SYSDIR\OVIME.ime", t "中文 (繁體) - OpenVanilla")'
  registry::Open /NOUNLOAD "${IME_ROOT_KEY}\${IME_KEY}" /N="OVIME.ime" /G=1 /T=REG_SZ .r0
  registry::Find /NOUNLOAD .r1 .r2 .r3 .r4
  StrLen $5 "${IME_KEY}"
  StrCpy $6 $1 "" $5
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Key" "$6"
  System::Call "user32::LoadKeyboardLayout(t $6, i 1)"
#  Exec "$WINDIR\OpenVanilla\OVPreferences.exe"
SectionEnd


Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "OpenVanilla 已成功地從你的電腦移除。"
FunctionEnd

Function un.onInit
!insertmacro MUI_UNGETLANGUAGE
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "你確定要完全移除 OpenVanilla ，其及所有的元件？" IDYES +2
  Abort
FunctionEnd

Section Uninstall
  Delete "$INSTDIR\uninst.exe"
  Delete "$SYSDIR\libltdl3.dll"
  Delete "$SYSDIR\libiconv-2.dll"
  Delete "$SYSDIR\tinyxml.dll"
  Delete "$SYSDIR\OVIMEUI.DLL"
  Delete "$SYSDIR\OVIME.ime"
  Delete "$WINDIR\OpenVanilla\OVPreferences.exe"
  Delete "$WINDIR\OpenVanilla\OVPreferences.exe.manifest"
  RMDir /r "$WINDIR\OpenVanilla\zh_TW"
  Delete "$WINDIR\OpenVanilla\Modules\OVIMRoman.DLL"
  RMDir "$WINDIR\OpenVanilla\Modules"

  Delete "$SMPROGRAMS\OpenVanilla\Uninstall.lnk"
  Delete "$SMPROGRAMS\OpenVanilla\OVPreferences.lnk"

  RMDir "$SMPROGRAMS\OpenVanilla"

  ReadRegStr $0 ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Key"
  DeleteRegKey ${IME_ROOT_KEY} "${IME_KEY}$0"
  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
 
  SetAutoClose true
SectionEnd
