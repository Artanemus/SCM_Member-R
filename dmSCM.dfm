object SCM: TSCM
  OnCreate = DataModuleCreate
  Height = 264
  Width = 362
  object scmConnection: TFDConnection
    Params.Strings = (
      'ConnectionDef=MSSQL_SwimClubMeet')
    Connected = True
    LoginPrompt = False
    Left = 136
    Top = 24
  end
  object tblSwimClub: TFDTable
    ActiveStoredUsage = [auDesignTime]
    Connection = scmConnection
    TableName = 'SwimClubMeet.dbo.SwimClub'
    Left = 112
    Top = 88
  end
  object dsSwimClub: TDataSource
    DataSet = tblSwimClub
    Left = 208
    Top = 88
  end
  object qrySCMSystem: TFDQuery
    Connection = scmConnection
    Left = 96
    Top = 160
  end
end
