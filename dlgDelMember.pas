unit dlgDelMember;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.WinXCtrls,
  Vcl.VirtualImage, Vcl.BaseImageCollection, Vcl.ImageCollection, Vcl.StdCtrls;

type
  TDelMember = class(TForm)
    ImageCollection1: TImageCollection;
    VirtualImage1: TVirtualImage;
    RelativePanel1: TRelativePanel;
    lblTitle: TLabel;
    Panel1: TPanel;
    btnYes: TButton;
    btnNo: TButton;
    lblDetails: TLabel;
    VirtualImage2: TVirtualImage;
    lblDetailEx: TLabel;
    VirtualImage3: TVirtualImage;
    VirtualImage4: TVirtualImage;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnYesClick(Sender: TObject);
    procedure btnNoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DelMember: TDelMember;

implementation

{$R *.dfm}

procedure TDelMember.btnNoClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TDelMember.btnYesClick(Sender: TObject);
begin
  ModalResult := mrYes;
end;

procedure TDelMember.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = VK_ESCAPE then
    ModalResult := mrCancel;
end;

procedure TDelMember.FormShow(Sender: TObject);
begin
  btnNo.SetFocus;
end;

end.
