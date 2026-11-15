#ifndef PayloadDir
  #error Pass /DPayloadDir=path to the verified portable package contents.
#endif
#ifndef OutputDir
  #define OutputDir "..\..\..\outputs"
#endif

[Setup]
AppId={{506B1A15-600C-47EB-A94C-ED2E4AB17333}
AppName=TranslucentTB (26H2 Temporary)
AppVersion=2026.2.1
AppVerName=TranslucentTB 26H2 Temporary 1 (Unofficial)
AppPublisher=PDSB001 (unofficial packaging)
AppPublisherURL=https://github.com/PDSB001/TranslucentTB
AppSupportURL=https://github.com/PDSB001/TranslucentTB/issues
DefaultDirName={localappdata}\Programs\TranslucentTB-26H2-Temporary
DefaultGroupName=TranslucentTB (26H2 Temporary)
PrivilegesRequired=lowest
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
MinVersion=10.0.22000
DisableProgramGroupPage=yes
AppMutex=344635E9-9AE4-4E60-B128-D53E25AB70A7
CloseApplications=no
RestartApplications=no
LicenseFile={#PayloadDir}\LICENSE.md
InfoBeforeFile=installer-notice.txt
OutputDir={#OutputDir}
OutputBaseFilename=TranslucentTB-UNOFFICIAL-26H2-Setup-x64
Compression=lzma2
SolidCompression=yes
WizardStyle=modern
UninstallDisplayIcon={app}\TranslucentTB.exe
UninstallDisplayName=TranslucentTB (26H2 Temporary)
SetupIconFile=..\TranslucentTB\resources\TranslucentTB.dev.ico

[Languages]
Name: "chinesesimplified"; MessagesFile: "compiler:Languages\ChineseSimplified.isl"
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "创建桌面快捷方式 / Create a desktop shortcut"
Name: "startup"; Description: "登录后自动启动临时版 / Start this temporary build at sign-in"; Flags: unchecked

[Files]
Source: "{#PayloadDir}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs; Excludes: "settings.json,*.log"

[Icons]
Name: "{group}\TranslucentTB (26H2 Temporary)"; Filename: "{app}\TranslucentTB.exe"; WorkingDir: "{app}"
Name: "{group}\卸载临时版 - Uninstall"; Filename: "{uninstallexe}"
Name: "{userdesktop}\TranslucentTB (26H2 Temporary)"; Filename: "{app}\TranslucentTB.exe"; WorkingDir: "{app}"; Tasks: desktopicon
Name: "{userstartup}\TranslucentTB (26H2 Temporary)"; Filename: "{app}\TranslucentTB.exe"; WorkingDir: "{app}"; Tasks: startup

[Run]
Filename: "{app}\TranslucentTB.exe"; Description: "启动临时版（切换版本后请先重启电脑） / Launch (restart Windows first when switching builds)"; Flags: postinstall unchecked skipifsilent nowait

[Messages]
chinesesimplified.FinishedLabel=临时版安装完成。%n%n如果之前运行过官方版或其他临时版，请重启电脑，再使用桌面快捷方式启动。不要同时运行多个版本。%n%n原作者发布兼容更新后，建议从“已安装的应用”卸载本临时版并回到官方版本。
english.FinishedLabel=The temporary build is installed.%n%nIf you previously ran another build, restart Windows before launching from the shortcut. Do not run multiple versions together.%n%nWhen the original authors publish a compatible update, uninstall this temporary build from Installed apps and return to the official version.
