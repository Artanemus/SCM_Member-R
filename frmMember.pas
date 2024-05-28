unit frmMember;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.DBCtrls,
  SCMSimpleConnect, SCMUtility, dmSCM,
  FireDAC.Comp.Client, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait, Data.DB, System.Actions,
  Vcl.ActnList, Vcl.WinXCtrls, Vcl.ExtCtrls, ProgramSetting, Vcl.ComCtrls,
  exeinfo, Vcl.Imaging.pngimage, SCMDefines;

type
  TMember = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    chkbUseOsAuthentication: TCheckBox;
    edtPassword: TEdit;
    edtServerName: TEdit;
    edtUser: TEdit;
    btnConnect: TButton;
    btnDisconnect: TButton;
    ActionList1: TActionList;
    actnConnect: TAction;
    actnDisconnect: TAction;
    actnManageMembers: TAction;
    ActivityIndicator1: TActivityIndicator;
    lblAniIndicatorStatus: TLabel;
    Timer1: TTimer;
    Panel1: TPanel;
    Image1: TImage;
    StatusMsg: TLabel;
    btnManageMembers: TButton;
    procedure actnConnectExecute(Sender: TObject);
    procedure actnConnectUpdate(Sender: TObject);
    procedure actnDisconnectExecute(Sender: TObject);
    procedure actnDisconnectUpdate(Sender: TObject);
    procedure btnManageMembersClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
    fDBName: String;
    fDBConnection: TFDConnection;
    fLoginTimeOut: integer;
    fConnectionCountdown: integer;
    procedure ConnectOnTerminate(Sender: TObject); // THREAD.
    procedure Status_ConnectionDescription;
    procedure LoadFromSettings; // JSON Program Settings
    procedure LoadSettings; // JSON Program Settings
    procedure SaveToSettings; // JSON Program Settings
    function GetSCMVerInfo(): string;
    procedure ManageMembers(var Msg: TMessage); message SCM_INITIALISE;

  public
    { Public declarations }
  end;

var
  Member: TMember;

implementation

{$R *.dfm}

uses frmManageMember;

procedure TMember.actnConnectExecute(Sender: TObject);
var
  sc: TSimpleConnect;
  myThread: TThread;
begin
  if (Assigned(SCM) and (SCM.scmConnection.Connected = false)) then
  begin
    lblAniIndicatorStatus.Caption := 'Connecting ' +
      IntToStr(CONNECTIONTIMEOUT);
    StatusMsg.Caption := '';
    ActivityIndicator1.Animate := true; // start spinning
    lblAniIndicatorStatus.Visible := true; // a label 'Connecting'
    fConnectionCountdown := CONNECTIONTIMEOUT - 1;
    Timer1.Enabled := true; // start the countdown

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
    if SCM.scmConnection.Connected and actnConnect.Enabled then
      actnConnect.Enabled := false;
    if not SCM.scmConnection.Connected and not actnConnect.Enabled then
      actnConnect.Enabled := true;
  end
  else // D E F A U L T  I N I T  . Data module not created.
  begin
    if not actnConnect.Enabled then
      actnConnect.Enabled := true;
  end;
  // btnConnect.Enabled := actnConnect.Enabled;
end;

procedure TMember.actnDisconnectExecute(Sender: TObject);
begin
  if Assigned(SCM) then
  begin
    SCM.DeActivateTable;
    SCM.scmConnection.Connected := false;
  end;
  ActivityIndicator1.Animate := false;
  lblAniIndicatorStatus.Visible := false;
  SaveToSettings; // As this was a OK connection - store parameters.
  Status_ConnectionDescription;

  // CALL IT DIRECTLY - ELSE IT WILL NOT WORK
  actnDisconnectUpdate(Self);
  actnConnectUpdate(Self);
end;

procedure TMember.actnDisconnectUpdate(Sender: TObject);
begin
  // verbose code - stop unecessary repaints ...
  if Assigned(SCM) then
  begin
    if SCM.scmConnection.Connected and not actnDisconnect.Enabled then
      actnDisconnect.Enabled := true;
    if not SCM.scmConnection.Connected and actnDisconnect.Enabled then
      actnDisconnect.Enabled := false;
  end
  else // D E F A U L T  I N I T  . Data module not created.
  begin
    if actnDisconnect.Enabled then
      actnDisconnect.Enabled := false;
  end;
end;

procedure TMember.btnManageMembersClick(Sender: TObject);
begin
  if Assigned(SCM) and SCM.IsActive and SCM.scmConnection.Connected then
  PostMessage(Handle, SCM_INITIALISE, 0, 0);
end;

procedure TMember.ConnectOnTerminate(Sender: TObject);
begin
  lblAniIndicatorStatus.Visible := false;
  ActivityIndicator1.Animate := false;
  Timer1.Enabled := false;
  fConnectionCountdown := CONNECTIONTIMEOUT - 1;

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
    if (SCM.IsActive = true) then
      PostMessage(Handle, SCM_INITIALISE, 0, 0);
  end;

  if not SCM.scmConnection.Connected then
  begin
    // Attempt to connect failed.
    StatusMsg.Caption :=
      'A connection couldn''t be made. (Check you input values.)';
  end
  else
    // Status : SwimClub name + APP and DB version.
    Status_ConnectionDescription;


  // nothing here works
  // actnDisconnect.Update;
  // actnConnect.Update;
  // UpdateAction(actnDisconnect);
  // UpdateAction(actnConnect);
  // ActionList1.UpdateAction(actnDisconnect);
  // ActionList1.UpdateAction(actnConnect);

  // CALL IT DIRECTLY ....
  actnDisconnectUpdate(Self);
  actnConnectUpdate(Self);

end;

procedure TMember.FormCreate(Sender: TObject);
var
  AValue, ASection, AName: string;

begin
  // Initialization of params.
  application.ShowHint := true;
  ActivityIndicator1.Animate := false;
  fLoginTimeOut := CONNECTIONTIMEOUT; // DEFAULT 20 - defined in ProgramSetting
  fConnectionCountdown := CONNECTIONTIMEOUT - 1;
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

  Status_ConnectionDescription;

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

procedure TMember.ManageMembers(var Msg: TMessage);
var
  dlg: TManageMember;
begin
  // Hide the MAIN-FORM and display frmManageMember
  Visible := false;
  dlg := TManageMember.Create(Self);
  dlg.Prepare(SCM.scmConnection, 1, 0);
  dlg.ShowModal;
  dlg.Free;
  Visible := true;
  ExecuteAction(actnDisconnect);
  Close();  // terminate application ....
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
    StatusMsg.Caption := 'Connected to SwimClubMeet. ';
    StatusMsg.Caption := StatusMsg.Caption + GetSCMVerInfo;

    if Assigned(SCM.dsSwimClub.DataSet) then
      s := SCM.dsSwimClub.DataSet.FieldByName('Caption').AsString
    else
      s := '';
    StatusMsg.Caption := StatusMsg.Caption + sLineBreak + s;
  end
  else
    StatusMsg.Caption := 'No Connection.';
end;

procedure TMember.Timer1Timer(Sender: TObject);
begin
  // countdown from CONNECTIONTIMEOUT
  fConnectionCountdown := fConnectionCountdown - 1;
  lblAniIndicatorStatus.Caption := 'Connecting ' +
    IntToStr(fConnectionCountdown);
end;

end.
