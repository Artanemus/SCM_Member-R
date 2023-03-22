unit frmMember;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, VclTee.TeeGDIPlus,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, System.ImageList, Vcl.ImgList,
  FireDAC.Comp.Client, FireDAC.Comp.DataSet, Vcl.StdCtrls, VclTee.TeEngine,
  VclTee.TeeSpline, VclTee.Series, VclTee.TeeProcs, VclTee.Chart,
  VclTee.DBChart, Vcl.ComCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.DBCtrls, Vcl.Mask,
  Vcl.ExtCtrls, Vcl.Menus, dmSCM, Vcl.WinXCalendars;

type
  TMember = class(TForm)
    Panel1: TPanel;
    lblMemberCount: TLabel;
    chkbHideInActive: TCheckBox;
    chkbHideArchived: TCheckBox;
    chkbHideNonSwimmers: TCheckBox;
    Panel3: TPanel;
    DBNavigator1: TDBNavigator;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Panel7: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    Label2: TLabel;
    Label1: TLabel;
    Label10: TLabel;
    DBText3: TDBText;
    Label6: TLabel;
    Label7: TLabel;
    Label12: TLabel;
    DBText5: TDBText;
    Label21: TLabel;
    Label22: TLabel;
    Label24: TLabel;
    DBlucboGender: TDBLookupComboBox;
    DBedtFirstName: TDBEdit;
    DBedtLastName: TDBEdit;
    DBlucboMembershipType: TDBLookupComboBox;
    DBedtMembershipNum: TDBEdit;
    DBchkIsActive: TDBCheckBox;
    DBEdtEmail: TDBEdit;
    DBgridContactInfo: TDBGrid;
    DBlucboHouse: TDBLookupComboBox;
    DBchkIsSwimmer: TDBCheckBox;
    DBchkIsArchived: TDBCheckBox;
    btnClearHouse: TButton;
    btnClearMembershipType: TButton;
    btnClearGender: TButton;
    TabSheet5: TTabSheet;
    DBGrid3: TDBGrid;
    ImageList1: TImageList;
    MainMenu1: TMainMenu;
    File2: TMenuItem;
    Exit2: TMenuItem;
    Help2: TMenuItem;
    About2: TMenuItem;
    btnFindMember: TButton;
    btnGotoMemberID: TButton;
    Find1: TMenuItem;
    Find2: TMenuItem;
    Label13: TLabel;
    Label18: TLabel;
    RegistrationNum: TDBEdit;
    Label8: TLabel;
    dtpickDOB: TCalendarPicker;
    lblCount: TLabel;
    btnGotoMembership: TButton;
    DBNavigator2: TDBNavigator;
    Onlinehelp1: TMenuItem;
    SCMwebsite1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure About2Click(Sender: TObject);
    procedure DBGrid3CellClick(Column: TColumn);
    procedure DBGrid3ColEnter(Sender: TObject);
    procedure DBGrid3ColExit(Sender: TObject);
    procedure DBGrid3DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid3KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DrawCheckBoxes(oGrid: TObject; Rect: TRect; Column: TColumn);
    procedure dtpickDOBChange(Sender: TObject);
    procedure chkbHideArchivedClick(Sender: TObject);
    procedure chkbHideInActiveClick(Sender: TObject);
    procedure chkbHideNonSwimmersClick(Sender: TObject);
    procedure DBGrid3EditButtonClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure btnFindMemberClick(Sender: TObject);
    procedure btnGotoMemberIDClick(Sender: TObject);
    procedure btnGotoMembershipClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Find2Click(Sender: TObject);
    procedure Onlinehelp1Click(Sender: TObject);
    procedure SCMwebsite1Click(Sender: TObject);
    procedure Exit2Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure DBNavigator1BeforeAction(Sender: TObject; Button: TNavigateBtn);
    procedure DBNavigator1Click(Sender: TObject; Button: TNavigateBtn);

  private
    { Private declarations }
    fSwimClubID: Integer;
    fDoDelete: Boolean;
    procedure ReadPreferences();
    procedure WritePreferences();
    function FindMember(MemberID: Integer): Boolean;

  public
    { Public declarations }
    procedure HandleMessage(var msg: TagMsg; var handled: Boolean);
    procedure ClearAllFilters();
  end;

const
  INIFILE_SCM_MEMBERPREF = 'SCM_MemberPref.ini';
  INIFILE_SECTION = 'SCM_Member';

var
  Member: TMember;

implementation

{$R *.dfm}

uses Utility, dlgBasicLogin, System.IniFiles, System.UITypes, dlgAbout,
  winMsgDef, dlgDOBPicker, dlgFindMember, dlgGotoMember, dlgGotoMembership,
  System.IOUtils, Winapi.ShellAPI, dlgDelMember;

procedure TMember.About2Click(Sender: TObject);
var
  dlg: TAbout;
begin
  dlg := TAbout.Create(Self);
  dlg.ShowModal;
  FreeAndNil(dlg);
end;

procedure TMember.btnClearClick(Sender: TObject);
begin
  if Assigned(SCM) and (SCM.qryMember.Active) then
  begin
    if (SCM.qryMember.State <> dsInsert) or (SCM.qryMember.State <> dsEdit) then
      SCM.qryMember.Edit();
    case TButton(Sender).Tag of
      1:
        SCM.qryMember.FieldByName('GenderID').Clear();
      2:
        SCM.qryMember.FieldByName('MembershipTypeID').Clear();
      3:
        SCM.qryMember.FieldByName('HouseID').Clear();
    end;
  end;
end;

procedure TMember.btnFindMemberClick(Sender: TObject);
var
  dlg: TFindMember;
  rtn: TModalResult;
begin
  dlg := TFindMember.Create(Self);
  rtn := dlg.ShowModal();
  if IsPositiveResult(rtn) then
  begin
    // LOCATE MEMBER IN qryMember
    FindMember(dlg.MemberID)
  end;
  dlg.Free;
end;

procedure TMember.btnGotoMemberIDClick(Sender: TObject);
var
  dlg: TGotoMember;
  rtn: TModalResult;
begin
  if Assigned(SCM) then
  begin
    dlg := TGotoMember.Create(Self);
    dlg.SwimClubID := SCM.dsMember.DataSet.FieldByName('SwimClubID').AsInteger;
    rtn := dlg.ShowModal;
    if IsPositiveResult(rtn) then
    begin
      // LOCATE MEMBER IN qryMember
      FindMember(dlg.MemberID)
    end;
    dlg.Free;
  end;
end;

procedure TMember.btnGotoMembershipClick(Sender: TObject);
var
  dlg: TGotoMembership;
  rtn: TModalResult;
begin
  if Assigned(SCM) then
  begin
    dlg := TGotoMembership.Create(Self);
    dlg.SwimClubID := SCM.dsMember.DataSet.FieldByName('SwimClubID').AsInteger;
    rtn := dlg.ShowModal;
    if IsPositiveResult(rtn) then
    begin
      // NOTE: returns both MembershipNum and MemberID
      // LOCATE MEMBER IN qryMember
      FindMember(dlg.MemberID)
    end;
    dlg.Free;
  end;
end;

procedure TMember.chkbHideArchivedClick(Sender: TObject);
begin
  if Assigned(SCM) then
    SCM.UpdateMember(fSwimClubID, chkbHideArchived.Checked,
      chkbHideInActive.Checked, chkbHideNonSwimmers.Checked);
end;

procedure TMember.chkbHideInActiveClick(Sender: TObject);
begin
  if Assigned(SCM) then
    SCM.UpdateMember(fSwimClubID, chkbHideArchived.Checked,
      chkbHideInActive.Checked, chkbHideNonSwimmers.Checked);
end;

procedure TMember.chkbHideNonSwimmersClick(Sender: TObject);
begin
  if Assigned(SCM) then
    SCM.UpdateMember(fSwimClubID, chkbHideArchived.Checked,
      chkbHideInActive.Checked, chkbHideNonSwimmers.Checked);
end;

procedure TMember.ClearAllFilters;
begin
  if Assigned(SCM) then
  begin
    chkbHideArchived.Checked := false;
    chkbHideInActive.Checked := false;
    chkbHideNonSwimmers.Checked := false;
    SCM.UpdateMember(fSwimClubID, chkbHideArchived.Checked,
      chkbHideInActive.Checked, chkbHideNonSwimmers.Checked);
  end;
end;

procedure TMember.DBGrid3CellClick(Column: TColumn);
begin
  if Assigned(Column.Field) and (Column.Field.DataType = ftBoolean) then
  begin
    if (Column.Grid.DataSource.DataSet.State <> dsEdit) or
      (Column.Grid.DataSource.DataSet.State <> dsInsert) then
      Column.Grid.DataSource.DataSet.Edit;
    Column.Field.Value := not Column.Field.AsBoolean;
  end;
  if Assigned(Column.Field) and (Column.Field.FieldKind = fkLookup) then
  begin
    if (Column.Grid.DataSource.DataSet.State <> dsEdit) or
      (Column.Grid.DataSource.DataSet.State <> dsInsert) then
      Column.Grid.DataSource.DataSet.Edit;
  end;
end;

procedure TMember.DBGrid3ColEnter(Sender: TObject);
begin
  // Important to cast TBGridOptions - else assignment desn't work!
  // If the field is boolean, switch off Grid editing, else allow editing
  if Assigned(DBGrid3.SelectedField) and
    (DBGrid3.SelectedField.DataType = ftBoolean) then
  begin
    // Use TBGridOptions constructor
    // Copy current options but remove editing option
    DBGrid3.Options := DBGrid3.Options - [dgEditing];
  end;
end;

procedure TMember.DBGrid3ColExit(Sender: TObject);
begin
  if Assigned(DBGrid3.SelectedField) and
    (DBGrid3.SelectedField.DataType = ftBoolean) then
    // Use TBGridOptions constructor
    // Copy current options but add editing option
    DBGrid3.Options := DBGrid3.Options + [dgEditing];

end;

procedure TMember.DBGrid3DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  // CHECKBOX DRAWING
  if Assigned(Column.Field) and (Column.Field.DataType = ftBoolean) then
  begin
    DrawCheckBoxes(DBGrid3, Rect, Column);
    if gdFocused in State then
      DBGrid3.Canvas.DrawFocusRect(Rect);
  end
  else
  begin
    DBGrid3.DefaultDrawColumnCell(Rect, DataCol, Column, State);
    if gdFocused in State then
      DBGrid3.Canvas.DrawFocusRect(Rect);
  end;
end;

procedure TMember.DBGrid3EditButtonClick(Sender: TObject);
var
  fld: TField;
  cal: TDOBPicker;
  // point: TPoint;
  Rect: TRect;
  rtn: TModalResult;
begin
  // handle the ellipse button for the DOB - show DatePicker
  fld := DBGrid3.SelectedField;
  if fld.Name = 'qryMemberDOB' then
  begin
    cal := TDOBPicker.Create(Self);
    Rect := TButton(Sender).ClientToScreen(TButton(Sender).ClientRect);
    cal.Left := Rect.Left;
    cal.Top := Rect.Top;
    cal.CalendarView1.Date := fld.AsDateTime;
    rtn := cal.ShowModal;
    if IsPositiveResult(rtn) then
    begin
      if (DBGrid3.DataSource.State <> dsEdit) or
        (DBGrid3.DataSource.State <> dsInsert) then
      begin
        // ALT: SCM.UpdateDOB(cal.CalendarView1.Date);
        DBGrid3.DataSource.Edit;
        fld.Value := cal.CalendarView1.Date;
      end;

    end;
    cal.Free;
  end;
end;

procedure TMember.DBGrid3KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  fld: TField;
  // dbg: TDBGrid;
begin
  // dbg := TDBGrid(Sender);

  // Sender is TDBGrid
  if Assigned(DBGrid3.SelectedField) then
  begin

    if (DBGrid3.SelectedField.DataType = ftBoolean) then
    begin
      // If the selected field is a boolean,
      // then enable SPACE key to toggle the value.
      fld := DBGrid3.SelectedField;
      if (Key = vkSpace) then
      begin
        if (DBGrid3.DataSource.DataSet.State <> dsEdit) or
          (DBGrid3.DataSource.DataSet.State <> dsInsert) then
        begin
          DBGrid3.DataSource.DataSet.Edit();
        end;
        fld.Value := not fld.AsBoolean;
        Key := NULL;
      end;
      // Y, y, T, t
      if (Key = $59) or (Key = $79) or (Key = $54) or (Key = $74) then
      begin
        if (DBGrid3.DataSource.DataSet.State <> dsEdit) or
          (DBGrid3.DataSource.DataSet.State <> dsInsert) then
        begin
          DBGrid3.DataSource.DataSet.Edit();
        end;
        fld.Value := 1;
        Key := NULL;
      end;
      // N, n, F, f
      if (Key = $4E) or (Key = $6E) or (Key = $46) or (Key = $66) then
      begin
        if (DBGrid3.DataSource.DataSet.State <> dsEdit) or
          (DBGrid3.DataSource.DataSet.State <> dsInsert) then
        begin
          DBGrid3.DataSource.DataSet.Edit();
        end;
        fld.Value := 0;
        Key := NULL;
      end;
    end;

    // DROPDOWN COMBOBOX
    if (DBGrid3.SelectedField.FieldKind = fkLookup) then
    begin
      // NullValueKey - Alt+BkSp - CLEAR
      if (Key = vkBack) and (ssAlt in Shift) then
      begin
        fld := DBGrid3.SelectedField;
        if (fld.FieldName = 'luHouse') then
        begin
          DBGrid3.DataSource.DataSet.Edit();
          DBGrid3.DataSource.DataSet.FieldByName('HouseID').Clear();
          DBGrid3.DataSource.DataSet.Post();
          Key := NULL;
        end;
        if (fld.FieldName = 'luMembershipType') then
        begin
          DBGrid3.DataSource.DataSet.Edit();
          DBGrid3.DataSource.DataSet.FieldByName('MembershipTypeID').Clear();
          DBGrid3.DataSource.DataSet.Post();
          Key := NULL;
        end;
        if (fld.FieldName = 'luGender') then
        begin
          DBGrid3.DataSource.DataSet.Edit();
          DBGrid3.DataSource.DataSet.FieldByName('GenderID').Clear();
          DBGrid3.DataSource.DataSet.Post();
          Key := NULL;
        end;
      end;
    end;
  end;

end;

procedure TMember.DBNavigator1BeforeAction(Sender: TObject;
  Button: TNavigateBtn);
var
  dlg: TDelMember;
  FName, s: string;
  ID: Integer;
begin
  if Button = nbDelete then
  begin
    fDoDelete := false;
    dlg := TDelMember.Create(Self);
    // get the fullname of the member to delete
    FName := SCM.dsMember.DataSet.FieldByName('FName').AsString;
    ID := SCM.dsMember.DataSet.FieldByName('MemberID').AsInteger;
    s := IntToStr(ID);
    dlg.lblTitle.Caption := 'Delete (ID: ' + s + ') ' + FName +
      ' from the SwimClubMeet database ?';
    // display the confirm delete dlg
    if IsPositiveResult(dlg.ShowModal) then
    begin
      fDoDelete := true;
      // the delete action is allowed to continue ...
    end
    else
      // raises a silent exception - cancelling the action.
      Abort;
    dlg.Free;
  end;
end;

procedure TMember.DBNavigator1Click(Sender: TObject; Button: TNavigateBtn);
begin
  if Button = nbDelete then
  begin
    // click occurs after action...
    fDoDelete := false;
  end;
end;

// ---------------------------------------------------------------------------
// Draw a very basic checkbox (ticked) - not a nice as TCheckListBox
// ---------------------------------------------------------------------------
procedure TMember.DrawCheckBoxes(oGrid: TObject; Rect: TRect; Column: TColumn);
var
  MyRect: TRect;
  oField: TField;
  iPos, iFactor: Integer;
  bValue: Boolean;
  g: TDBGrid;
  points: array [0 .. 4] of TPoint;

begin
  g := TDBGrid(oGrid);
  oField := Column.Field;
  // is the cell checked?
  if (oField.Value = -1) then
    bValue := true
  else
    bValue := false;
  // clear the cell with the current OS brush color?
  g.Canvas.FillRect(Rect);
  // calculate margins
  MyRect.Top := Round(((Rect.Bottom - Rect.Top - 11) / 2.0)) + Rect.Top;
  MyRect.Left := Round(((Rect.Right - Rect.Left - 11) / 2.0)) + Rect.Left;
  MyRect.Bottom := MyRect.Top + 10;
  MyRect.Right := MyRect.Left + 10;
  // depends on theme - clBlack?;
  g.Canvas.Pen.Color := clHighlightText;
  // draw the box (with cell margins)
  points[0].x := MyRect.Left;
  points[0].y := MyRect.Top;
  points[1].x := MyRect.Right;
  points[1].y := MyRect.Top;
  points[2].x := MyRect.Right;
  points[2].y := MyRect.Bottom;
  points[3].x := MyRect.Left;
  points[3].y := MyRect.Bottom;
  points[4].x := MyRect.Left;
  points[4].y := MyRect.Top;

  g.Canvas.Polyline(points);

  iPos := MyRect.Left;
  iFactor := 1;
  // DRAW A TICK - Cross would be nicer?
  if (bValue) then
  begin
    // depends on theme - clWhite?
    g.Canvas.Pen.Color := clHighlightText;
    g.Canvas.MoveTo(iPos + (iFactor * 2), MyRect.Top + 4);
    g.Canvas.LineTo(iPos + (iFactor * 2), MyRect.Top + 7);
    g.Canvas.MoveTo(iPos + (iFactor * 3), MyRect.Top + 5);
    g.Canvas.LineTo(iPos + (iFactor * 3), MyRect.Top + 8);
    g.Canvas.MoveTo(iPos + (iFactor * 4), MyRect.Top + 6);
    g.Canvas.LineTo(iPos + (iFactor * 4), MyRect.Top + 9);
    g.Canvas.MoveTo(iPos + (iFactor * 5), MyRect.Top + 5);
    g.Canvas.LineTo(iPos + (iFactor * 5), MyRect.Top + 8);
    g.Canvas.MoveTo(iPos + (iFactor * 6), MyRect.Top + 4);
    g.Canvas.LineTo(iPos + (iFactor * 6), MyRect.Top + 7);
    g.Canvas.MoveTo(iPos + (iFactor * 7), MyRect.Top + 3);
    g.Canvas.LineTo(iPos + (iFactor * 7), MyRect.Top + 6);
    g.Canvas.MoveTo(iPos + (iFactor * 8), MyRect.Top + 2);
    g.Canvas.LineTo(iPos + (iFactor * 8), MyRect.Top + 5);
  end;
end;

procedure TMember.dtpickDOBChange(Sender: TObject);
begin
  if Assigned(SCM) and (SCM.qryMember.Active) then
  begin
    if (SCM.qryMember.State <> dsEdit) then
      SCM.qryMember.Edit();
    SCM.qryMember.FieldByName('DOB').AsDateTime := dtpickDOB.Date;
    // let user perform manual post
    // SCM.qryMember.Post();
  end;
end;

procedure TMember.Exit2Click(Sender: TObject);
begin
  Close();
end;

procedure TMember.Find2Click(Sender: TObject);
begin
  btnFindMemberClick(Self);
end;

function TMember.FindMember(MemberID: Integer): Boolean;
var
  b: Boolean;
  s: string;
  rtn: TModalResult;
begin
  result := false;
  b := SCM.LocateMember(MemberID);
  if b then
    result := true
  else
  begin
    s := 'Filters must to be cleared to display this member.' + sLineBreak +
      'Clear the filters?';
    rtn := MessageDlg(s, TMsgDlgType.mtConfirmation, mbYesNo, 0);
    if IsPositiveResult(rtn) then
    begin
      ClearAllFilters;
      b := SCM.LocateMember(MemberID);
      if b then
        result := true;
    end;
  end;
end;

procedure TMember.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  // Test database state
  if Assigned(SCM) and (SCM.qryMember.Active) then
  begin
    if (SCM.qryMember.State = dsEdit) or (SCM.qryMember.State = dsInsert) then
      SCM.qryMember.Post();
  end;
end;

procedure TMember.FormCreate(Sender: TObject);
var
  aBasicLogin: TBasicLogin;
  result: TModalResult;
begin
  // ----------------------------------------------------
  // C R E A T E   D A T A M O D U L E   S C M .
  // ----------------------------------------------------
  try
    SCM := TSCM.Create(Self);
  finally
    // with SCM created and the essential tables are open then
    // asserting the connection should be true
    if not Assigned(SCM) then
    begin
      MessageDlg('The SCM connection couldn''t be created!', mtError,
        [mbOk], 0);
      Application.Terminate;
    end;
  end;
  if not Assigned(SCM) then
    Exit;
  // ----------------------------------------------------
  // C O N N E C T   T O   S E R V E R .
  // ----------------------------------------------------
  aBasicLogin := TBasicLogin.Create(Self);
  result := aBasicLogin.ShowModal;
  aBasicLogin.Free;

  if (result = mrAbort) or (result = mrCancel) then
  begin
    Application.Terminate;
    Exit;
  end;

  // ----------------------------------------------------
  // R E G I S T E R   W I N D O W S   M E S S A G E S  .
  // var defined in winMsgDef.pas
  // ----------------------------------------------------
  WM_SCMAFTERSCOLL := RegisterWindowMessage('WM_SCMAFTERSCOLL');
  WM_SCMREQUERY := RegisterWindowMessage('WM_SCMREQUERY');
  Application.OnMessage := HandleMessage;

  // ----------------------------------------------------
  // A C T I V A T E   S C M  .
  // ----------------------------------------------------
  SCM.ActivateTable;
  // A S S E R T .
  if not SCM.IsActive then
  begin
    MessageDlg('An error occurred during MSSQL table activation.' + sLineBreak +
      'The database''s schema may need updating.' + sLineBreak +
      'The application will terminate!', mtError, [mbOk], 0);
    Application.Terminate;
  end;
  // ----------------------------------------------------
  // I N I T I A L I Z E   P A R A M S .
  // ----------------------------------------------------
  Application.ShowHint := true; // enable hints
  fSwimClubID := 1;
  chkbHideArchived.Checked := true;
  chkbHideInActive.Checked := false;
  chkbHideNonSwimmers.Checked := false;

  // ----------------------------------------------------
  // R E A D   P R E F E R E N C E S .
  // ----------------------------------------------------
  ReadPreferences;

  // ----------------------------------------------------
  // D I S P L A Y   F O R M   C A P T I O N   I N F O .
  // ----------------------------------------------------
  Self.Caption := 'SwimClubMeet (SCM) MEMBER : ';
  SCM.UpdateSwimClub(fSwimClubID);
  if SCM.qrySwimClub.Active then
  begin
    Self.Caption := Self.Caption + SCM.qrySwimClub.FieldByName
      ('DetailStr').AsString;
  end;

  // ----------------------------------------------------
  // Prepares all core queries  (Master+Child)
  // ----------------------------------------------------
  SCM.UpdateMember(fSwimClubID, chkbHideArchived.Checked,
    chkbHideInActive.Checked, chkbHideNonSwimmers.Checked);

  // Display tabsheet
  PageControl1.TabIndex := 0;

end;

procedure TMember.FormDestroy(Sender: TObject);
begin
  WritePreferences;
end;

procedure TMember.HandleMessage(var msg: TagMsg; var handled: Boolean);
begin
  // only call here if SCM exists.
  if Assigned(SCM) then
  begin
    // FOLLOWING MESSAGES GENERATED BY qryMember
    if msg.message = WM_SCMAFTERSCOLL then
    begin
      // DATE-OF-BIRTH - DATETIME PICKER INIT
      dtpickDOB.Date := SCM.qryMember.FieldByName('DOB').AsDateTime;
    end;
    if msg.message = WM_SCMREQUERY then
    begin
      // UPDATE THE NUMBER OF RECORDS.
      lblCount.Caption := IntToStr(SCM.RecordCount);
    end;
  end;

end;

procedure TMember.Onlinehelp1Click(Sender: TObject);
var
  base_URL: string;
begin
  base_URL := 'http://artanemus.github.io/manual/index.htm';
  ShellExecute(0, NIL, PChar(base_URL), NIL, NIL, SW_SHOWNORMAL);

end;

procedure TMember.ReadPreferences;
var
  ini: TIniFile;
begin
  // C:\Users\<#USERNAME#>\AppData\Roaming\Artanemus\SCM\ + SCMMEMBERPREF
  ini := TIniFile.Create(Utility.GetSCMAppDataDir + INIFILE_SCM_MEMBERPREF);
  try
    chkbHideArchived.Checked := ini.ReadBool(INIFILE_SECTION,
      'HideArchived', true);
    chkbHideInActive.Checked := ini.ReadBool(INIFILE_SECTION,
      'HideInActive', false);
    chkbHideNonSwimmers.Checked := ini.ReadBool(INIFILE_SECTION,
      'HideNonSwimmer', false);
  finally
    ini.Free;
  end;
end;

procedure TMember.SCMwebsite1Click(Sender: TObject);
var
  base_URL: string;
begin
  // compiles just fine!
  // ShellExecute(0, 0, L"http://artanemus.github.io", 0, 0, SW_SHOW);

  base_URL := 'http://artanemus.github.io';
  ShellExecute(0, 'open', PChar(base_URL), NIL, NIL, SW_SHOWNORMAL);

end;

procedure TMember.WritePreferences;
var
  ini: TIniFile;
begin
  // C:\Users\<#USERNAME#>\AppData\Roaming\Artanemus\SCM\ + SCMMEMBERPREF
  ini := TIniFile.Create(Utility.GetSCMAppDataDir + INIFILE_SCM_MEMBERPREF);
  try
    ini.WriteBool(INIFILE_SECTION, 'HideArchived', chkbHideArchived.Checked);
    ini.WriteBool(INIFILE_SECTION, 'HideInActive', chkbHideInActive.Checked);
    ini.WriteBool(INIFILE_SECTION, 'HideNonSwimmer',
      chkbHideNonSwimmers.Checked);
  finally
    ini.Free;
  end;
end;

end.
