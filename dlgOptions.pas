unit dlgOptions;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Samples.Spin,
  Vcl.ExtCtrls, Vcl.VirtualImage, Vcl.BaseImageCollection, Vcl.ImageCollection,
  Vcl.WinXPickers, Vcl.WinXCalendars, Vcl.PlatformDefaultStyleActnCtrls,
  System.Actions, Vcl.ActnList, Vcl.ActnMan, Vcl.DBCtrls;

type

  TOptions = class(TForm)
    Panel1: TPanel;
    btnClose: TButton;
    btnCancel: TButton;
    ImageCollection1: TImageCollection;

  private
    { Private declarations }
    // P R E F E R E N C E   F I L E   A C C E S S .
    procedure ReadPreferences(iniFileName: string);
    procedure WritePreferneces(iniFileName: string);

  public
    { Public declarations }

  end;


var
  Options: TOptions;

implementation

{$R *.dfm}

uses dmSCM, FireDAC.Stan.Param, System.UITypes, Utility, IniFiles;


procedure TOptions.ReadPreferences(iniFileName: string);
var
  iFile: TIniFile;
//  i: Integer;
begin
//  iFile := TIniFile.create(iniFileName);
//  iFile.Free;
end;


procedure TOptions.WritePreferneces(iniFileName: string);
var
  iFile: TIniFile;
begin
//  iFile := TIniFile.create(iniFileName);
//  iFile.Free;
end;

end.
