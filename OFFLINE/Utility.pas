unit Utility;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.Win.Registry, shlobj;

function GetSCM_SharedIniFile(): string;
function GetSCMAppDataDir(): string;
function GetSCMCommonAppDataDir(): string;
function GetSCMTempDir(): string;
function GetSCMDocumentDir(): string;
function GetRegAppPath(appName: string): string;
function GetRegArtanemusAppPath(appName: string): string;

const
  PrefFileName = 'SCM_SharedPref.ini';
  SCMSubFolder = 'Artanemus\SCM\';
implementation

function GetSCM_SharedIniFile(): string;
begin
  result := GetSCMAppDataDir + PrefFileName;
end;

function GetSCMAppDataDir(): string;
var
  str: string;
begin

  result := '';
  str := GetEnvironmentVariable('APPDATA');
  str := IncludeTrailingPathDelimiter(str);
  // Append product-specific path
  str := str + SCMSubFolder;
  if not DirectoryExists(str) then
  begin
    { *
      ForceDirectories creates a new directory as specified in Dir, which must be
      a fully-qualified path name. If the directories given in the path do not yet
      exist, ForceDirectories attempts to create them. ForceDirectories returns
      True if it successfully creates all necessary directories, False if it could
      not create a needed directory.
      Note: Do not call ForceDirectories with an empty string. Doing so causes
      ForceDirectories to raise an exception.
      * }
    if not System.SysUtils.ForceDirectories(str) then
      // FAILED! - Use alternative default document directory...
      exit;
  end;
  result := str;
end;

function GetSCMCommonAppDataDir(): string;
var
  str: string;
  szPath: array [0 .. Max_Path] of Char;
begin
  result := '';
  if (SUCCEEDED(SHGetFolderPath(null, CSIDL_COMMON_APPDATA, 0, 0, szPath))) then
  begin
    str := String(szPath);
    str := IncludeTrailingPathDelimiter(str) + SCMSubFolder;
    if not DirectoryExists(str) then
    begin
      if not CreateDir(str) then
        exit;
    end;
  end;
  result := str;
end;

function GetSCMTempDir(): string;
var
  str: string;
begin
  result := '';
  str := GetEnvironmentVariable('TMP');
  str := IncludeTrailingPathDelimiter(str);
  if not DirectoryExists(str) then
  begin
    if not CreateDir(str) then
      exit;
  end;
  result := str;
end;

function GetSCMDocumentDir(): string;
begin
  result := GetEnvironmentVariable('HOMEPATH');
  result := IncludeTrailingPathDelimiter(result);
  result := result + 'SCM\';
end;

function GetRegAppPath(appName: string): string;
var
  reg: TRegistry;
  KeyName: string;
begin
  KeyName := '\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\';
  result := '';
  reg := TRegistry.Create(KEY_READ);
  try
    begin
      reg.RootKey := HKEY_LOCAL_MACHINE;
      if reg.KeyExists(KeyName) then
      begin
        reg.OpenKey(KeyName, false);
        result := reg.ReadString('Path');
      end;
    end;
  finally
    reg.Free;
  end;
end;

function GetRegArtanemusAppPath(appName: string): string;
var
  reg: TRegistry;
  KeyName: string;
begin
  KeyName := '\Software\\Artanemus\';
  result := '';
  KeyName := KeyName + appName + '\';
  result := '';
  reg := TRegistry.Create(KEY_READ);
  try
    begin
      reg.RootKey := HKEY_CURRENT_USER;
      reg.OpenKey(KeyName, false);
      result := reg.ReadString('Path');

    end;
  finally
    reg.Free;
  end;

end;

end.


