program SCM_Member;

uses
  Vcl.Forms,
  frmMember in 'frmMember.pas' {Member},
  Vcl.Themes,
  Vcl.Styles,
  dlgDOBPicker in 'dlgDOBPicker.pas' {DOBPicker},
  dlgFindMember in 'dlgFindMember.pas' {FindMember},
  dlgGotoMember in 'dlgGotoMember.pas' {GotoMember},
  dlgGotoMembership in 'dlgGotoMembership.pas' {GotoMembership},
  dlgDelMember in 'dlgDelMember.pas' {DelMember},
  dmSCM in 'dmSCM.pas' {SCM: TDataModule},
  dlgBasicLogin in '..\SCM_SHARED\dlgBasicLogin.pas' {BasicLogin},
  SCMUtility in '..\SCM_SHARED\SCMUtility.pas',
  SCMDefines in '..\SCM_SHARED\SCMDefines.pas',
  exeinfo in '..\SCM_SHARED\exeinfo.pas',
  SCMSimpleConnect in '..\SCM_SHARED\SCMSimpleConnect.pas',
  dlgAbout in '..\SCM_SHARED\dlgAbout.pas' {About};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Windows10 SlateGray');
  Application.CreateForm(TMember, Member);
  Application.Run;
end.
