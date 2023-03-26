unit dmSCM;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Phys.MSSQL,
  FireDAC.Phys.MSSQLDef;

type
  TSCM = class(TDataModule)
    SCMConnection: TFDConnection;
    tblContactNumType: TFDTable;
    tblContactNumTypeContactNumTypeID: TFDAutoIncField;
    tblContactNumTypeCaption: TWideStringField;
    tblStroke: TFDTable;
    tblDistance: TFDTable;
    dsMember: TDataSource;
    qryMember: TFDQuery;
    qryMemberMemberID: TFDAutoIncField;
    qryMemberMembershipDue: TSQLTimeStampField;
    qryMemberMembershipNum: TIntegerField;
    qryMemberFirstName: TWideStringField;
    qryMemberLastName: TWideStringField;
    qryMemberFName: TWideStringField;
    qryMemberDOB: TSQLTimeStampField;
    qryMemberSwimmerAge: TIntegerField;
    qryMemberIsActive: TBooleanField;
    qryMemberIsSwimmer: TBooleanField;
    qryMemberIsArchived: TBooleanField;
    qryMemberEmail: TWideStringField;
    qryMemberSwimClubID: TIntegerField;
    qryMemberCreatedOn: TSQLTimeStampField;
    qryMemberArchivedOn: TSQLTimeStampField;
    qryMemberGenderID: TIntegerField;
    qryMemberluGender: TStringField;
    qryMemberluMembershipType: TStringField;
    qryMemberMembershipTypeID: TIntegerField;
    qryMemberluHouse: TStringField;
    qryMemberHouseID: TIntegerField;
    tblMembershipType: TFDTable;
    dsMembershipType: TDataSource;
    tblGender: TFDTable;
    dsGender: TDataSource;
    dsHouse: TDataSource;
    tblHouse: TFDTable;
    dsContactNum: TDataSource;
    qryContactNum: TFDQuery;
    qryContactNumContactNumID: TFDAutoIncField;
    qryContactNumNumber: TWideStringField;
    qryContactNumContactNumTypeID: TIntegerField;
    qryContactNumMemberID: TIntegerField;
    qryContactNumlu: TStringField;
    qrySwimClub: TFDQuery;
    dsSwimClub: TDataSource;
    qryMemberMembershipStr: TWideStringField;
    qryFindMember: TFDQuery;
    qryFindMemberMemberID: TFDAutoIncField;
    qryFindMemberMembershipNum: TIntegerField;
    qryFindMemberFName: TWideStringField;
    qryFindMemberdtDOB: TWideStringField;
    qryFindMemberAge: TIntegerField;
    qryFindMemberIsActive: TBooleanField;
    qryFindMembercGender: TWideStringField;
    qryFindMembercMembershipType: TWideStringField;
    qryFindMemberFirstName: TWideStringField;
    qryFindMemberLastName: TWideStringField;
    qryFindMemberGenderID: TIntegerField;
    qryFindMemberMemberShipTypeID: TIntegerField;
    qryFindMemberIsSwimmer: TBooleanField;
    dsFindMember: TDataSource;
    qAssertMemberID: TFDQuery;
    qryEntrantDataCount: TFDQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure qryMemberAfterScroll(DataSet: TDataSet);
    procedure qryMemberAfterInsert(DataSet: TDataSet);
    procedure qryMemberBeforeDelete(DataSet: TDataSet);
    procedure qryMemberAfterDelete(DataSet: TDataSet);
  private
    { Private declarations }
    FIsActive: boolean;
    fRecordCount: Integer;

  public
    { Public declarations }
    procedure ActivateTable();

//    procedure SimpleLoadSettingString(ASection, AName: string; var AValue: string);
//    procedure SimpleMakeTemporyFDConnection(Server, User, Password: string;
//      OsAuthent: boolean);
//    procedure SimpleSaveSettingString(ASection, AName, AValue: string);

    procedure UpdateDOB(DOB: TDateTime);
    procedure UpdateSwimClub(SwimClubID: Integer);
    procedure UpdateMember(SwimClubID: Integer;
      hideArchived, hideInactive, hideNonSwimmer: boolean);

    function LocateMember(MemberID: Integer): boolean;

    property scmIsActive: boolean read FIsActive write FIsActive;
    property RecordCount: Integer read fRecordCount;

  end;

const
  SCMMEMBERPREF = 'SCM_MemberPref.ini';
  USEDSHAREDINIFILE = True; // NOTE: Always true. 26/09/2022

var
  SCM: TSCM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}

uses
  System.IOUtils, IniFiles, scmUtility, scmDefines, Winapi.Windows, Winapi.Messages,
  vcl.Dialogs, System.UITypes, vcl.Forms;

procedure TSCM.ActivateTable;
begin
  FIsActive := True;
end;

procedure TSCM.DataModuleCreate(Sender: TObject);
begin
  // TODO:
  fRecordCount := 0;
end;

function TSCM.LocateMember(MemberID: Integer): boolean;
var
  SearchOptions: TLocateOptions;
begin
  result := false;
  SearchOptions := [loPartialKey];
  try
    begin
      result := qryMember.Locate('MemberID', MemberID, SearchOptions);
    end
  except
    on E: Exception do
      // lblErrMsg.Caption := 'SCM DB access error.';
  end;
end;

procedure TSCM.qryMemberAfterDelete(DataSet: TDataSet);
begin
  // Refresh display ?
end;

procedure TSCM.qryMemberAfterInsert(DataSet: TDataSet);
var
  fld: TField;
begin
  fld := DataSet.FieldByName('IsArchived');
  if (fld.IsNull) then
  begin
    fld.AsBoolean := false;
  end;
  fld := DataSet.FieldByName('IsActive');
  if (fld.IsNull) then
  begin
    fld.AsBoolean := True;
  end;
  fld := DataSet.FieldByName('IsSwimmer');
  if (fld.IsNull) then
  begin
    fld.AsBoolean := True;
  end;
end;

procedure TSCM.qryMemberAfterScroll(DataSet: TDataSet);
begin
  // use this to post directly to form : TForm(Self.GetOwner).Handle;
  // requires uses : Vcl.Forms
  PostMessage(TForm(Owner).Handle, SCM_AFTERSCROLL, 0, 0);
end;

procedure TSCM.qryMemberBeforeDelete(DataSet: TDataSet);
var
  SQL: string;
  MemberID, result: Integer;
begin
  // Best to finalize any editing - prior to calling execute statements.
  DataSet.CheckBrowseMode;
  MemberID := DataSet.FieldByName('MemberID').AsInteger;
  if MemberID <> 0 then
  begin
    // second chance to abort delete - but only displayed if there is entrant data with race-times
    // could have used SCMConnection.ExecScalar(SQL, [MemberID]).
    qryEntrantDataCount.Connection := SCMConnection;
    // FYI - assignment of connection typically sets DS state to closed.
    qryEntrantDataCount.Close;
    qryEntrantDataCount.ParamByName('MEMBERID').AsInteger := MemberID;
    qryEntrantDataCount.Prepare;
    qryEntrantDataCount.Open;
    if qryEntrantDataCount.Active then
    begin
      if qryEntrantDataCount.FieldByName('TOT').AsInteger > 0 then
      begin
        result := MessageDlg('This member has race-time data!' + sLineBreak +
          'Are you sure you want to delete the member?',
          TMsgDlgType.mtConfirmation, [mbYes, mbNo], 0, mbNo);
        if IsNegativeResult(result) then
        begin
          qryEntrantDataCount.Close; // tidy up...?
          Abort;
        end;
      end;
      qryEntrantDataCount.Close;
    end;
    qryMember.DisableControls; // will it stop refresh of contact table?
    // remove all the relationships in associated tables for this member
    SQL := 'DELETE FROM [SwimClubMeet].[dbo].[ContactNum] WHERE MemberID = ' +
      IntToStr(MemberID) + ';';
    SCMConnection.ExecSQL(SQL);
    {TODO -oBen -cGeneral : db.Split and dbo.TeamSplit need to be handled prior to cleaning dbo.Entrant.}
    SQL := 'UPDATE [SwimClubMeet].[dbo].[Entrant] SET [MemberID] = NULL, ' +
      '[RaceTime] = NULL, [TimeToBeat] = NULL, [PersonalBest] = NULL, ' +
      '[IsDisqualified] = 0,[IsScratched] = 0 WHERE MemberID = ' +
      IntToStr(MemberID) + ';';
    SCMConnection.ExecSQL(SQL);
    {TODO -oBen -cGeneral : TeamEntrant table design incomplete. Additional fields needed.}
    SQL := 'UPDATE [SwimClubMeet].[dbo].[TeamEntrant] SET [MemberID] = NULL,  [RaceTime] = NULL WHERE MemberID = '
      + IntToStr(MemberID) + ';';
    SCMConnection.ExecSQL(SQL);
    { TODO -oBen -cGeneral : DELETE from TeamNominee - remove all member's nominations to relay events. }
    SQL := 'DELETE FROM [SwimClubMeet].[dbo].[Nominee] WHERE MemberID = ' +
      IntToStr(MemberID) + ';';
    SCMConnection.ExecSQL(SQL);
    qryMember.EnableControls;
  end;
end;

{
procedure TSCM.SimpleLoadSettingString(ASection, AName: string; var AValue: string);
var
  ini: TIniFile;
begin
  if USEDSHAREDINIFILE then
    ini := TIniFile.Create(GetSCM_SharedIniFile)
  else
    ini := TIniFile.Create(TPath.GetDocumentsPath + PathDelim + SCMMEMBERPREF);
  try
    AValue := ini.ReadString(ASection, Aname, '');
  finally
    ini.Free;
  end;
end;

procedure TSCM.SimpleMakeTemporyFDConnection(Server, User, Password: string;
  OsAuthent: boolean);
var
  AValue, ASection, AName: string;
begin
  if (SCMConnection.Connected) then
  begin
    SCMConnection.Close();
  end;

  SCMConnection.Params.Add('Server=' + Server);
  SCMConnection.Params.Add('DriverID=MSSQL');
  SCMConnection.Params.Add('Database=SwimClubMeet');
  SCMConnection.Params.Add('User_name=' + User);
  SCMConnection.Params.Add('Password=' + Password);
  if (OsAuthent) then
    AValue := 'Yes'
  else
    AValue := 'No';
  SCMConnection.Params.Add('OSAuthent=' + AValue);
  SCMConnection.Params.Add('Mars=yes');
  SCMConnection.Params.Add('MetaDefSchema=dbo');
  SCMConnection.Params.Add('ExtendedMetadata=False');
  SCMConnection.Params.Add('ApplicationName=scmTimeKeeper');
  SCMConnection.Connected := True;

  // ON SUCCESS - Save connection details.
  if (SCMConnection.Connected) then
  begin
    ASection := 'MSSQL_SwimClubMeet';
    AName := 'Server';
    SimpleSaveSettingString(ASection, AName, Server);
    AName := 'User';
    SimpleSaveSettingString(ASection, AName, User);
    AName := 'Password';
    SimpleSaveSettingString(ASection, AName, Password);
    AName := 'OSAuthent';
    SimpleSaveSettingString(ASection, AName, AValue);
  end
end;

procedure TSCM.SimpleSaveSettingString(ASection, AName, AValue: string);
var
  ini: TIniFile;
begin
  if USEDSHAREDINIFILE then
    ini := TIniFile.Create(Utility.GetSCM_SharedIniFile)
  else
    // ALT 1. User documents folder - root directory (always read write)
    // ini := TIniFile.Create(TPath.GetDocumentsPath + PathDelim + SCMMEMBERPREF);
    // ALT 2. AppData (hidden) - Forced directories assures SCM path exists.
    // C:\Users\<#USERNAME#>\AppData\Roaming\Artanemus\SCM\
    ini := TIniFile.Create(Utility.GetSCMAppDataDir + SCMMEMBERPREF);
  try
    ini.WriteString(ASection, AName, AValue);
  finally
    ini.Free;
  end;

end;
}

procedure TSCM.UpdateDOB(DOB: TDateTime);
begin
  if Assigned(qryMember.Connection) and (qryMember.Active) then
  begin
    qryMember.DisableControls;
    qryMember.Edit;
    qryMember.FieldByName('DOB').AsDateTime := DOB;
    qryMember.Post;
    qryMember.EnableControls;
  end;

end;

procedure TSCM.UpdateMember(SwimClubID: Integer;
  hideArchived, hideInactive, hideNonSwimmer: boolean);
begin
  if not Assigned(qryMember.Connection) then
    qryMember.Connection := SCMConnection;

  qryMember.DisableControls;
  qryMember.Close;
  if SwimClubID <> 0 then
  begin
    qryMember.ParamByName('SWIMCLUBID').AsInteger := SwimClubID;
    qryMember.ParamByName('HIDE_ARCHIVED').AsBoolean := hideArchived;
    qryMember.ParamByName('HIDE_INACTIVE').AsBoolean := hideInactive;
    qryMember.ParamByName('HIDE_NONSWIMMERS').AsBoolean := hideNonSwimmer;
    qryMember.Prepare;
    qryMember.Open;
    if qryMember.Active then
    begin
      fRecordCount := qryMember.RecordCount;
      if not Assigned(qryContactNum.Connection) then
        qryContactNum.Connection := SCMConnection;
      if not qryContactNum.Active then
        qryContactNum.Open;
    end
    else
      fRecordCount := 0;
  end;
  qryMember.EnableControls;
  // This allows the main to adjust record count, etc....
  PostMessage(TForm(Owner).handle, SCM_REQUERY, 0, 0);

end;

procedure TSCM.UpdateSwimClub(SwimClubID: Integer);
begin
  if not Assigned(qrySwimClub.Connection) then
    qrySwimClub.Connection := SCMConnection;
  qrySwimClub.DisableControls;
  qrySwimClub.Close;
  if SwimClubID <> 0 then
  begin
    qrySwimClub.ParamByName('SWIMCLUBID').AsInteger := SwimClubID;
    qrySwimClub.Prepare;
    qrySwimClub.Open;
  end;
  qrySwimClub.EnableControls;
end;

end.
