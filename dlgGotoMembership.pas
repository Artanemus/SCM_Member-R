unit dlgGotoMembership;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.VirtualImage, Vcl.BaseImageCollection, Vcl.ImageCollection;

type
  TGotoMembership = class(TForm)
    Panel1: TPanel;
    btnGoto: TButton;
    Panel2: TPanel;
    Label1: TLabel;
    lblErrMsg: TLabel;
    Edit1: TEdit;
    VirtualImage1: TVirtualImage;
    ImageCollection1: TImageCollection;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnGotoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
  private
    { Private declarations }
    fPassed: boolean;
    fMemberID: integer;
    fMembershipNum: integer;
    fSwimClubID: integer;
    function getMemberID: integer;
    procedure setMemberID(const Value: integer);
    function getSwimClubID: integer;
    procedure setSwimClubID(const Value: integer);
    function AssertMembershipNum(aMembershipNum: integer): boolean;
    function getMembershipNum: integer;
    procedure setMembershipNum(const Value: integer);

  public
    { Public declarations }
    property MemberID: integer read getMemberID write setMemberID;
    property SwimClubID: integer read getSwimClubID write setSwimClubID;
    property MembershipNum: integer read getMembershipNum write setMembershipNum;

  end;

var
  GotoMembership: TGotoMembership;

implementation

{$R *.dfm}

uses dmSCM;

function TGotoMembership.AssertMembershipNum(aMembershipNum: integer): boolean;
begin
  result := false;
  fMemberID := 0;
  if Assigned(SCM) then
  begin
    if not Assigned(SCM.qAssertMemberID.Connection) then
      SCM.qAssertMemberID.Connection := SCM.scmConnection;
    SCM.qAssertMemberID.Close;
    SCM.qAssertMemberID.SQL.Clear;
    SCM.qAssertMemberID.SQL.Add
      ('SELECT MemberID, MembershipNum, SwimClubID FROM Member WHERE MembershipNum = '
      + IntToStr(aMembershipNum) + ' AND SwimClubID = ' + IntToStr(fSwimClubID));
    try
      SCM.qAssertMemberID.Open;
      if (SCM.qAssertMemberID.Active) then
      begin
        if SCM.qAssertMemberID.RecordCount > 0 then
        begin
          result := true;
          // NOTE: MemberID assign ...
          fMemberID := SCM.qAssertMemberID.FieldByName('MemberID').AsInteger;
        end;
      end;
    except
      on E: Exception do
        lblErrMsg.Caption := 'SCM DB access error.';
    end;

  end;
end;

procedure TGotoMembership.btnGotoClick(Sender: TObject);
begin
  if (fMembershipNum = 0) then
  begin
    Beep;
    lblErrMsg.Caption := 'Membership number is invalid.';
    exit;
  end;
  // check if valid membership number
  if AssertMembershipNum(fMembershipNum) then
  begin
    fPassed := true;
    ModalResult := mrOk;
  end;
end;

procedure TGotoMembership.Edit1Change(Sender: TObject);
begin
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
  if AssertMembershipNum(i) then
  begin
    fMembershipNum := i;
    lblErrMsg.Caption := 'Membership number ..OK.';
    exit;
  end
  else
  begin
    lblErrMsg.Caption := '...?';
    exit;
  end;
end;


end;

procedure TGotoMembership.FormCreate(Sender: TObject);
begin
  fPassed := false;
  fMemberID := 0;
  fMembershipNum := 0;
  fSwimClubID := 1;
  lblErrMsg.Caption := '';
  Edit1.Text := '';
end;

procedure TGotoMembership.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) then
    btnGotoClick(self)
  else
  begin
    if (Key = VK_ESCAPE) then
    begin
      fMemberID := 0;
      fMembershipNum := 0;
      fPassed := false;
      ModalResult := mrCancel;
    end;
  end;
end;

procedure TGotoMembership.FormShow(Sender: TObject);
begin
  Edit1.SetFocus;
end;

function TGotoMembership.getMemberID: integer;
begin
  result := fMemberID;
end;

function TGotoMembership.getMembershipNum: integer;
begin
  result := fMembershipNum;
end;

function TGotoMembership.getSwimClubID: integer;
begin
  result := fSwimClubID;
end;

procedure TGotoMembership.setMemberID(const Value: integer);
begin
  fMemberID := Value;
end;

procedure TGotoMembership.setMembershipNum(const Value: integer);
begin
  fMembershipNum := Value;
end;

procedure TGotoMembership.setSwimClubID(const Value: integer);
begin
  fSwimClubID := Value;
end;

end.
