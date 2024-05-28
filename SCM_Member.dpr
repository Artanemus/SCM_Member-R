program SCM_Member;

uses
  Vcl.Forms,
  Vcl.Themes,
  Vcl.Styles,
  dlgBasicLogin in '..\SCM_SHARED\dlgBasicLogin.pas' {BasicLogin},
  SCMUtility in '..\SCM_SHARED\SCMUtility.pas',
  SCMDefines in '..\SCM_SHARED\SCMDefines.pas',
  exeinfo in '..\SCM_SHARED\exeinfo.pas',
  SCMSimpleConnect in '..\SCM_SHARED\SCMSimpleConnect.pas',
  dlgAbout in '..\SCM_SHARED\dlgAbout.pas' {About},
  dlgDeleteMember in '..\SCM_SwimClubMeet-R\MEMBERS\dlgDeleteMember.pas' {DeleteMember},
  dlgFindMember in '..\SCM_SwimClubMeet-R\MEMBERS\dlgFindMember.pas' {FindMember},
  dlgGotoMember in '..\SCM_SwimClubMeet-R\MEMBERS\dlgGotoMember.pas' {GotoMember},
  dlgGotoMembership in '..\SCM_SwimClubMeet-R\MEMBERS\dlgGotoMembership.pas' {GotoMembership},
  dlgMemberFilter in '..\SCM_SwimClubMeet-R\MEMBERS\dlgMemberFilter.pas' {MemberFilter},
  dmManageMemberData in '..\SCM_SwimClubMeet-R\MEMBERS\dmManageMemberData.pas' {ManageMemberData: TDataModule},
  frmManageMember in '..\SCM_SwimClubMeet-R\MEMBERS\frmManageMember.pas' {ManageMember},
  rptMemberChart in '..\SCM_SwimClubMeet-R\MEMBERS\rptMemberChart.pas' {MemberChart: TDataModule},
  rptMemberDetail in '..\SCM_SwimClubMeet-R\MEMBERS\rptMemberDetail.pas' {MemberDetail: TDataModule},
  rptMemberHistory in '..\SCM_SwimClubMeet-R\MEMBERS\rptMemberHistory.pas' {MemberHistory: TDataModule},
  rptMembersDetail in '..\SCM_SwimClubMeet-R\MEMBERS\rptMembersDetail.pas' {MembersDetail: TDataModule},
  rptMembersList in '..\SCM_SwimClubMeet-R\MEMBERS\rptMembersList.pas' {MembersList: TDataModule},
  rptMembersSummary in '..\SCM_SwimClubMeet-R\MEMBERS\rptMembersSummary.pas' {MembersSummary: TDataModule},
  dlgDOBPicker in '..\SCM_SwimClubMeet-R\dlgDOBPicker.pas' {DOBPicker},
  dmSCM in 'dmSCM.pas' {SCM: TDataModule},
  frmMember in 'frmMember.pas' {Member},
  ProgramSetting in 'ProgramSetting.pas',
  XSuperJSON in '..\x-superobject\XSuperJSON.pas',
  XSuperObject in '..\x-superobject\XSuperObject.pas',
  SCMHelpers in '..\SCM_SHARED\SCMHelpers.pas',
  dlgMemberClub in '..\SCM_SwimClubMeet-R\MEMBERS\dlgMemberClub.pas' {MemberClub};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TSCM, SCM);
  Application.CreateForm(TMember, Member);
  TStyleManager.TrySetStyle('Windows10 SlateGray');
  Application.Run;
end.
