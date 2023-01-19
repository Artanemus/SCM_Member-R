unit dlgFindMember;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.Client, FireDAC.Comp.DataSet, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.VirtualImage, Vcl.BaseImageCollection,
  Vcl.ImageCollection;

type
  TFindMember = class(TForm)
    Panel1: TPanel;
    Edit1: TEdit;
    Panel2: TPanel;
    btnGotoMember: TButton;
    DBGrid1: TDBGrid;
    ImageCollection1: TImageCollection;
    VirtualImage1: TVirtualImage;
    lblFound: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCloseClick(Sender: TObject);
    procedure btnGotoMemberClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
    fPassed: boolean;
    fMemberID: integer;
    function getMemberID: integer;
    procedure setMemberID(const Value: integer);
  public
    { Public declarations }
    property MemberID: integer read getMemberID write setMemberID;
  end;

var
  FindMember: TFindMember;

implementation

{$R *.dfm}

uses dmSCM;

procedure TFindMember.btnCloseClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFindMember.btnGotoMemberClick(Sender: TObject);
begin
  if Assigned(SCM) and (SCM.qryFindMember.Active) then
  begin
    fMemberID := SCM.qryFindMember.FieldByName('MemberID').AsInteger;
    if (fMemberID > 0) then
    begin
      fPassed := true;
      ModalResult := mrOk;
    end;
  end
  else
    ModalResult := mrCancel;
end;

procedure TFindMember.DBGrid1DblClick(Sender: TObject);
begin
  btnGotoMemberClick(self);
end;

procedure TFindMember.Edit1Change(Sender: TObject);
var
  LocateSuccess: boolean;
  SearchOptions: TLocateOptions;
  MemberID: integer;
  fs: string;

begin

  LocateSuccess := false;
  if (SCM.qryFindMember.Active = false) then
    exit;

  fs := '';
  SCM.qryFindMember.DisableControls();

  // LOCATE AND STORE THE CURRENT MEMBERID
  MemberID := SCM.qryFindMember.FieldByName('MemberID').AsInteger;

  // ---------------------------------
  // MEMBER'S NAME ....
  // ---------------------------------
  if (Length(Edit1.Text) > 0) then
  begin
    fs := fs + '[FName] LIKE ' + QuotedStr('%' + Edit1.Text + '%');
  end;

  if (fs.IsEmpty()) then
    SCM.qryFindMember.Filtered := false
  else
  begin
    SCM.qryFindMember.Filter := fs;
    if not(SCM.qryFindMember.Filtered) then
    begin
      SCM.qryFindMember.Filtered := true;
    end;
  end;

  // DISPLAY NUMBER OF RECORDS FOUND
  SCM.qryFindMember.Last();
  lblFound.Caption := 'Found: ' + IntToStr(SCM.qryFindMember.RecordCount);
  // RE_LOCATE TO THE MEMBERID
  if (MemberID <> 0) then
  begin
    SearchOptions := [];
    try
      begin
        LocateSuccess := SCM.qryFindMember.Locate('MemberID', MemberID,
          SearchOptions);
      end;
    except
      on E: Exception do
        LocateSuccess := false;
    end;
  end;
  // IF MEMBER NOT FOUND ... BROWSE TO FIRST RECORD.
  if (LocateSuccess = false) then
    SCM.qryFindMember.First();

  SCM.qryFindMember.EnableControls();
end;

procedure TFindMember.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SCM.qryFindMember.Close;
end;

procedure TFindMember.FormCreate(Sender: TObject);
begin
  fPassed := false;
  fMemberID := 0;

  if Assigned(SCM) then
  begin
    if not Assigned(SCM.tblMembershipType.Connection) then
      SCM.tblMembershipType.Connection := SCM.scmConnection;
    if not Assigned(SCM.qryFindMember.Connection) then
      SCM.qryFindMember.Connection := SCM.scmConnection;
  end;

  if not SCM.qryFindMember.Active then
    SCM.qryFindMember.Open;

  // A s s i g n m e n t   r e q u i r e d  !
  DBGrid1.DataSource := SCM.dsFindMember;
  // Results in Edit1Change event!   (Sets up filters and record count.)
  Edit1.Text := '';
end;

procedure TFindMember.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    ModalResult := mrCancel;
end;

function TFindMember.getMemberID: integer;
begin
  result := fMemberID;
end;

procedure TFindMember.setMemberID(const Value: integer);
begin
  fMemberID := Value;
end;

end.
