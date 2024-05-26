unit frmMember;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.DBCtrls,
  SCMSimpleConnect, SCMUtility, dmSCM,
  FireDAC.Comp.Client, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait, Data.DB, System.Actions,
  Vcl.ActnList, Vcl.WinXCtrls, Vcl.ExtCtrls, ProgramSetting, Vcl.ComCtrls,
  exeinfo;

type
  TMember = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    chkbUseOsAuthentication: TCheckBox;
    edtPassword: TEdit;
    edtServerName: TEdit;
    edtUser: TEdit;
    DBComboBox1: TDBComboBox;
    Label4: TLabel;
    btnConnect: TButton;
    btnDisconnect: TButton;
    btnManageMembers: TButton;
    ActionList1: TActionList;
    actnConnect: TAction;
    actnDisconnect: TAction;
    actnManageMembers: TAction;
    ActivityIndicator1: TActivityIndicator;
    lblAniIndicatorStatus: TLabel;
    Timer1: TTimer;
    StatusBar1: TStatusBar;
    procedure actnConnectExecute(Sender: TObject);
    procedure actnConnectUpdate(Sender: TObject);
    procedure actnDisconnectExecute(Sender: TObject);
    procedure actnDisconnectUpdate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    fDBName: String;
    fDBConnection: TFDConnection;
    fLoginTimeOut: integer;
    fConnectionCountdown: integer;
    procedure ConnectOnTerminate(Sender: TObject); //THREAD.
    procedure Status_ConnectionDescription;
    procedure LoadFromSettings; // JSON Program Settings
    procedure LoadSettings; // JSON Program Settings
    procedure SaveToSettings; // JSON Program Settings
    function GetSCMVerInfo(): string;


  public
    { Public declarations }
  end;

var
  Member: TMember;

implementation

{$R *.dfm}

procedure TMember.actnConnectExecute(Sender: TObject);
var
  sc: TSimpleConnect;
  myThread: TThread;
begin
  // Hide the Login and abort buttons while attempting connection
//  lblLoginErrMsg.Visible := false;
//  btnAbort.Visible := false;
  btnConnect.Visible := false;
//  lblMsg.Visible := true;
//  lblMsg.Update();
  Application.ProcessMessages();

  if Assigned(fDBConnection) then
  begin
    sc := TSimpleConnect.CreateWithConnection(Self, fDBConnection);
    // DEFAULT : SwimClubMeet
    sc.DBName := fDBName;
    sc.SimpleMakeTemporyConnection(edtServerName.Text, edtUser.Text,
      edtPassword.Text, chkbUseOsAuthentication.Checked);
//    lblMsg.Visible := false;

    if (fDBConnection.Connected) then
    begin
      // setting modal result will Close() the form;
      ModalResult := mrOk;
    end
    else
    begin
      // show error message - let user try again or abort
//      lblLoginErrMsg.Visible := true;
//      btnAbort.Visible := true;
      btnConnect.Visible := true;
    end;
    sc.Free;
  end;


  if (Assigned(SCM) and (SCM.scmConnection.Connected = false)) then
  begin
    lblAniIndicatorStatus.Caption := 'Connecting';
    fConnectionCountdown := fLoginTimeOut;
    ActivityIndicator1.Visible := true; // progress timer
    ActivityIndicator1.Enabled := true; // start spinning
    lblAniIndicatorStatus.Visible := true; // a label with countdown
    Timer1.Enabled := true; // start the countdown
    actnConnect.Visible := false;
    application.ProcessMessages;

    myThread := TThread.CreateAnonymousThread(
      procedure
      begin
        // can only be assigned if not connected
        SCM.scmConnection.Params.Values['LoginTimeOut'] :=
          IntToStr(fLoginTimeOut);

        sc := TSimpleConnect.CreateWithConnection(Self, SCM.scmConnection);
        sc.DBName := 'SwimClubMeet'; // DEFAULT
        sc.SaveConfigAfterConnection := false; // using JSON not System.IniFiles
        sc.SimpleMakeTemporyConnection(edtServerName.Text, edtUser.Text,
          edtPassword.Text, chkbUseOsAuthentication.Checked);
        Timer1.Enabled := false;
        sc.Free
      end);

    myThread.OnTerminate := ConnectOnTerminate;
    myThread.Start;
  end;

end;

procedure TMember.actnConnectUpdate(Sender: TObject);
begin
  // verbose code - stop unecessary repaints ...
  if Assigned(SCM) then
  begin
    if SCM.scmConnection.Connected and actnConnect.Visible then
      actnConnect.Visible := false;
    if not SCM.scmConnection.Connected and not actnConnect.Visible then
      actnConnect.Visible := true;
  end
  else // D E F A U L T  I N I T  . Data module not created.
  begin
    if not actnConnect.Visible then
      actnConnect.Visible := true;
  end;
end;

procedure TMember.actnDisconnectExecute(Sender: TObject);
begin
  if Assigned(SCM) then
  begin
    SCM.DeActivateTable;
    SCM.scmConnection.Connected := false;
    StatusBar1.SimpleText := 'No connection.';
  end;
  ActivityIndicator1.Visible := false;
  lblAniIndicatorStatus.Visible := false;
  ActivityIndicator1.Enabled := false;
  SaveToSettings; // As this was a OK connection - store parameters.
  UpdateAction(actnDisconnect);
  UpdateAction(actnConnect);
end;

procedure TMember.actnDisconnectUpdate(Sender: TObject);
begin
  // verbose code - stop unecessary repaints ...
  if Assigned(SCM) then
  begin
    if SCM.scmConnection.Connected and not actnDisconnect.Visible then
      actnDisconnect.Visible := true;
    if not SCM.scmConnection.Connected and actnDisconnect.Visible then
      actnDisconnect.Visible := false;
  end
  else // D E F A U L T  I N I T  . Data module not created.
  begin
    if actnDisconnect.Visible then
      actnDisconnect.Visible := false;
  end;
end;

procedure TMember.ConnectOnTerminate(Sender: TObject);
begin
  lblAniIndicatorStatus.Visible := false;
  ActivityIndicator1.Enabled := false;
  ActivityIndicator1.Visible := false;

  if TThread(Sender).FatalException <> nil then
  begin
    // something went wrong
    // Exit;
  end;

  if not Assigned(SCM) then
    exit;

  // C O N N E C T E D  .
  if (SCM.scmConnection.Connected) then
  begin
    SCM.ActivateTable;

    // ALL TABLES SUCCESSFULLY MADE ACTIVE ...
    if (SCM.IsActive = true) then
    begin

    end;
  end;

  if not SCM.scmConnection.Connected then
  begin
    // Attempt to connect failed.
    StatusBar1.SimpleText :=
      'A connection couldn''t be made. (Check you input values.)';
  end;

  // Disconnect button vivibility
  UpdateAction(actnDisconnect);
  // Connect button vivibility
  UpdateAction(actnConnect);
  // Status : SwimClub name + APP and DB version.
  Status_ConnectionDescription;

end;

procedure TMember.FormCreate(Sender: TObject);
var
  AValue, ASection, AName: string;

begin
  // Initialization of params.
  application.ShowHint := true;
  ActivityIndicator1.Visible := false;
  ActivityIndicator1.Enabled := false;
  btnDisconnect.Visible := false;
  fLoginTimeOut := CONNECTIONTIMEOUT; // DEFAULT 20 - defined in ProgramSetting
  fConnectionCountdown := CONNECTIONTIMEOUT;
  Timer1.Enabled := false;
  lblAniIndicatorStatus.Visible := false;

  // A Class that uses JSON to read and write application configuration
  if Settings = nil then
    Settings := TPrgSetting.Create;

      // C R E A T E   T H E   D A T A M O D U L E .
  if NOT Assigned(SCM) then
    SCM := TSCM.Create(Self);
  if SCM.scmConnection.Connected then
    SCM.scmConnection.Connected := false;

  // READ APPLICATION   C O N F I G U R A T I O N   PARAMS.
  // JSON connection settings. Windows location :
  // %SYSTEMDRIVE\%%USER%\%USERNAME%\AppData\Roaming\Artanemus\SwimClubMeet\Member
  LoadSettings;

end;

function TMember.GetSCMVerInfo: string;
var
  myExeInfo: TExeInfo;
begin
  result := '';
  // if connected - display the application version
  // and the SwimClubMeet database version.
  if Assigned(SCM) then
    if SCM.scmConnection.Connected then
      result := 'DB v' + SCM.GetDBVerInfo;
  // get the application version number
  myExeInfo := TExeInfo.Create(Self);
  result := 'App v' + myExeInfo.FileVersion + ' - ' + result;
  myExeInfo.Free;
end;

procedure TMember.LoadFromSettings;
begin
  edtServerName.Text := Settings.Server;
  edtUser.Text := Settings.User;
  edtPassword.Text := Settings.Password;
  chkbUseOsAuthentication.Checked := Settings.OSAuthent;
  fLoginTimeOut := Settings.LoginTimeOut;
end;

procedure TMember.LoadSettings;
begin
  if Settings = nil then
    Settings := TPrgSetting.Create;
  if not FileExists(Settings.GetDefaultSettingsFilename()) then
  begin
    ForceDirectories(Settings.GetSettingsFolder());
    Settings.SaveToFile();
  end;
  Settings.LoadFromFile();
  LoadFromSettings();
end;

procedure TMember.SaveToSettings;
begin
  Settings.Server := edtServerName.Text;
  Settings.User := edtUser.Text;
  Settings.Password := edtPassword.Text;
  if chkbUseOsAuthentication.Checked then
    Settings.OSAuthent := true
  else
    Settings.OSAuthent := false;
  Settings.LoginTimeOut := fLoginTimeOut;
  Settings.SaveToFile();
end;

procedure TMember.Status_ConnectionDescription;
var
s: string;
begin
  if Assigned(SCM) and SCM.IsActive then
  begin
    // STATUS BAR CAPTION.
    StatusBar1.SimpleText := 'Connected to SwimClubMeet. ';
    StatusBar1.SimpleText := StatusBar1.SimpleText + GetSCMVerInfo;

    if Assigned(SCM.dsSwimClub.DataSet) then
      s:= SCM.dsSwimClub.DataSet.FieldByName('Caption').AsString
    else s:='';
    StatusBar1.SimpleText := StatusBar1.SimpleText + sLineBreak + s;
  end
  else
    StatusBar1.SimpleText := 'NOT CONNECTED. ';
end;

end.
