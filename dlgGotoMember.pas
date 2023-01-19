unit dlgGotoMember;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.VirtualImage, Vcl.BaseImageCollection, Vcl.ImageCollection;

type
  TGotoMember = class(TForm)
    Panel1: TPanel;
    btnGoto: TButton;
    Panel2: TPanel;
    Label1: TLabel;
    lblErrMsg: TLabel;
    Edit1: TEdit;
    ImageCollection1: TImageCollection;
    VirtualImage1: TVirtualImage;
    procedure FormCreate(Sender: TObject);
    procedure btnGotoClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    fPassed: boolean;
    fMemberID: integer;
    fSwimClubID: integer;
    function getMemberID: integer;
    procedure setMemberID(const Value: integer);
    function getSwimClubID: integer;
    procedure setSwimClubID(const Value: integer);
    function AssertMemberID(aMemberID: integer): boolean;

  public
    { Public declarations }
    property MemberID: integer read getMemberID write setMemberID;
    property SwimClubID: integer read getSwimClubID write setSwimClubID;
  end;

var
  GotoMember: TGotoMember;

implementation

{$R *.dfm}

uses dmSCM;

function TGotoMember.AssertMemberID(aMemberID: integer): boolean;
begin
  result := false;
  if Assigned(SCM) then
  begin
    if not Assigned(SCM.qAssertMemberID.Connection) then
      SCM.qAssertMemberID.Connection := SCM.scmConnection;
    SCM.qAssertMemberID.Close;
    SCM.qAssertMemberID.SQL.Clear;
    SCM.qAssertMemberID.SQL.Add
      ('SELECT MemberID, MembershipNum, SwimClubID FROM Member WHERE MemberID = '
      + IntToStr(aMemberID) + ' AND SwimClubID = ' + IntToStr(fSwimClubID));
    try
      SCM.qAssertMemberID.Open;
      if (SCM.qAssertMemberID.Active) then
      begin
        if SCM.qAssertMemberID.RecordCount > 0 then
          result := true;
      end;
    except
      on E: Exception do
        lblErrMsg.Caption := 'SCM DB access error.';
    end;

  end;
end;

procedure TGotoMember.btnCancelClick(Sender: TObject);
begin
  fMemberID := 0;
  fPassed := false;
  ModalResult := mrCancel;
end;

procedure TGotoMember.btnGotoClick(Sender: TObject);
begin
  if (fMemberID = 0) then
  begin
    Beep;
    lblErrMsg.Caption := 'Member''s ID invalid.';
    exit;
  end;
  // Assert state of local-fMemberID
  if AssertMemberID(fMemberID) then
  begin
    fPassed := true;
    ModalResult := mrOk;
  end;
end;

procedure TGotoMember.Edit1Change(Sender: TObject);
var
  i: integer;
begin
  fMemberID := 0;
  if (Length(Edit1.Text) = 0) then
  begin
    lblErrMsg.Caption := '';
    exit;
  end;
  i := StrToIntDef(Edit1.Text, 0);
  if (i = 0) then
  begin
    lblErrMsg.Caption := '';
    exit;
  end;
  if AssertMemberID(i) then
  begin
    fMemberID := i;
    lblErrMsg.Caption := 'Member''s ID ..OK';
    exit;
  end
  else
  begin
    lblErrMsg.Caption := '...?';
    exit;
  end;
end;

procedure TGotoMember.FormCreate(Sender: TObject);
begin
  fPassed := false;
  fMemberID := 0;
  fSwimClubID := 1;
  lblErrMsg.Caption := '';
  Edit1.Text := '';
end;

procedure TGotoMember.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) then
    btnGotoClick(self)
  else
  begin
    if (Key = VK_ESCAPE) then
      btnCancelClick(self);
  end;
end;

procedure TGotoMember.FormShow(Sender: TObject);
begin
  Edit1.SetFocus;
end;

function TGotoMember.getMemberID: integer;
begin
  result := fMemberID;
end;

function TGotoMember.getSwimClubID: integer;
begin
  result := fSwimClubID;
end;


procedure TGotoMember.setMemberID(const Value: integer);
begin
  fMemberID := Value;
end;

procedure TGotoMember.setSwimClubID(const Value: integer);
begin
  fSwimClubID := Value;
end;

end.
