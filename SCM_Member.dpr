program SCM_Member;

uses
  Vcl.Forms,
  frmMember in 'frmMember.pas' {Member},
  Vcl.Themes,
  Vcl.Styles,
  Utility in 'Utility.pas',
  dlgBasicLogin in 'dlgBasicLogin.pas' {BasicLogin},
  dlgAbout in 'dlgAbout.pas' {About},
  exeinfo in 'exeinfo.pas',
  winMsgDef in 'winMsgDef.pas',
  dlgDOBPicker in 'dlgDOBPicker.pas' {DOBPicker},
  dlgFindMember in 'dlgFindMember.pas' {FindMember},
  dlgGotoMember in 'dlgGotoMember.pas' {GotoMember},
  dlgGotoMembership in 'dlgGotoMembership.pas' {GotoMembership},
  dlgDelMember in 'dlgDelMember.pas' {DelMember},
  dmSCM in 'dmSCM.pas' {SCM: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Windows10 SlateGray');
  Application.CreateForm(TMember, Member);
  Application.Run;
end.
