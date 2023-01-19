object SCM: TSCM
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 455
  Width = 665
  object SCMConnection: TFDConnection
    Params.Strings = (
      'ConnectionDef=MSSQL_SwimClubMeet')
    ConnectedStoredUsage = [auDesignTime]
    Connected = True
    LoginPrompt = False
    Left = 64
    Top = 24
  end
  object tblContactNumType: TFDTable
    ActiveStoredUsage = [auDesignTime]
    Active = True
    IndexFieldNames = 'ContactNumTypeID'
    Connection = SCMConnection
    UpdateOptions.AssignedValues = [uvEDelete, uvEInsert, uvEUpdate]
    UpdateOptions.EnableDelete = False
    UpdateOptions.EnableInsert = False
    UpdateOptions.EnableUpdate = False
    UpdateOptions.UpdateTableName = 'SwimClubMeet..ContactNumType'
    TableName = 'SwimClubMeet..ContactNumType'
    Left = 531
    Top = 184
    object tblContactNumTypeContactNumTypeID: TFDAutoIncField
      FieldName = 'ContactNumTypeID'
      Origin = 'ContactNumTypeID'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object tblContactNumTypeCaption: TWideStringField
      FieldName = 'Caption'
      Origin = 'Caption'
      Size = 30
    end
  end
  object tblStroke: TFDTable
    ActiveStoredUsage = [auDesignTime]
    IndexFieldNames = 'StrokeID'
    Connection = SCMConnection
    UpdateOptions.UpdateTableName = 'SwimClubMeet..Stroke'
    TableName = 'SwimClubMeet..Stroke'
    Left = 285
    Top = 320
  end
  object tblDistance: TFDTable
    ActiveStoredUsage = [auDesignTime]
    IndexFieldNames = 'DistanceID'
    Connection = SCMConnection
    UpdateOptions.UpdateTableName = 'SwimClubMeet..Distance'
    TableName = 'SwimClubMeet..Distance'
    Left = 288
    Top = 368
  end
  object dsMember: TDataSource
    DataSet = qryMember
    Left = 124
    Top = 128
  end
  object qryMember: TFDQuery
    ActiveStoredUsage = [auDesignTime]
    AfterInsert = qryMemberAfterInsert
    BeforeDelete = qryMemberBeforeDelete
    AfterDelete = qryMemberAfterDelete
    AfterScroll = qryMemberAfterScroll
    IndexFieldNames = 'SwimClubID;MemberID'
    MasterFields = 'SwimClubID'
    DetailFields = 'SwimClubID'
    Connection = SCMConnection
    UpdateOptions.UpdateTableName = 'SwimClubMeet..Member'
    UpdateOptions.KeyFields = 'SwimClubID;MemberID'
    SQL.Strings = (
      'USE [SwimClubMeet]'
      ''
      'DECLARE @HideInActive BIT;'
      'DECLARE @HideArchived BIT;'
      'DECLARE @HideNonSwimmers BIT;'
      'DECLARE @SwimClubID INTEGER;'
      ''
      'SET @HideInActive = :HIDE_INACTIVE;'
      'SET @HideArchived = :HIDE_ARCHIVED;'
      'SET @HideNonSwimmers = :HIDE_NONSWIMMERS;'
      'SET @SwimClubID = :SWIMCLUBID; '
      ''
      'SELECT [MemberID],'
      '       [MembershipNum],'
      '       [MembershipStr],'
      '       [MembershipDue],'
      '       [FirstName],'
      '       [LastName],'
      '       [DOB],'
      '       dbo.SwimmerAge(GETDATE(), [DOB]) AS SwimmerAge,'
      '       [IsActive],'
      '       IsSwimmer,'
      '       IsArchived,'
      '       [Email],'
      '       [GenderID],'
      '       [SwimClubID],'
      '       [MembershipTypeID],'
      
        '       CONCAT(Member.FirstName, '#39' '#39', UPPER(Member.LastName)) AS ' +
        'FName,'
      '       HouseID,'
      '       CreatedOn,'
      '       ArchivedOn'
      'FROM [dbo].[Member]'
      'WHERE (IsActive >= CASE'
      '                       WHEN @HideInActive = 1 THEN'
      '                           1'
      '                       ELSE'
      '                           0'
      '                   END'
      '      )'
      '      AND (IsArchived <= CASE'
      '                             WHEN @HideArchived = 1 THEN'
      '                                 0'
      '                             ELSE'
      '                                 1'
      '                         END'
      '          )'
      '      AND (IsSwimmer >= CASE'
      '                            WHEN @HideNonSwimmers = 1 THEN'
      '                                1'
      '                            ELSE'
      '                                0'
      '                        END'
      '          )'
      '-- mitigates NULL booleans'
      '      OR'
      '      ('
      '          IsArchived IS NULL'
      '          AND @HideArchived = 0'
      '      )'
      '      OR'
      '      ('
      '          IsActive IS NULL'
      '          AND @HideInActive = 0'
      '      )'
      '      OR'
      '      ('
      '          IsSwimmer IS NULL'
      '          AND @HideNonSwimmers = 0'
      '      );'
      ''
      ''
      ''
      '')
    Left = 57
    Top = 128
    ParamData = <
      item
        Name = 'HIDE_INACTIVE'
        DataType = ftBoolean
        ParamType = ptInput
        Value = False
      end
      item
        Name = 'HIDE_ARCHIVED'
        DataType = ftBoolean
        ParamType = ptInput
        Value = False
      end
      item
        Name = 'HIDE_NONSWIMMERS'
        DataType = ftBoolean
        ParamType = ptInput
        Value = False
      end
      item
        Name = 'SWIMCLUBID'
        DataType = ftInteger
        ParamType = ptInput
        Value = 1
      end>
    object qryMemberMemberID: TFDAutoIncField
      Alignment = taCenter
      DisplayLabel = 'ID'
      DisplayWidth = 4
      FieldName = 'MemberID'
      Origin = 'MemberID'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object qryMemberMembershipDue: TSQLTimeStampField
      FieldName = 'MembershipDue'
      Origin = 'MembershipDue'
      Visible = False
    end
    object qryMemberMembershipNum: TIntegerField
      Alignment = taLeftJustify
      DisplayLabel = 'Num#'
      DisplayWidth = 4
      FieldName = 'MembershipNum'
      Origin = 'MembershipNum'
    end
    object qryMemberMembershipStr: TWideStringField
      FieldName = 'MembershipStr'
      Origin = 'MembershipStr'
      Size = 24
    end
    object qryMemberFirstName: TWideStringField
      DisplayLabel = 'First Name'
      DisplayWidth = 18
      FieldName = 'FirstName'
      Origin = 'FirstName'
      Size = 128
    end
    object qryMemberLastName: TWideStringField
      DisplayLabel = 'Last Name'
      DisplayWidth = 18
      FieldName = 'LastName'
      Origin = 'LastName'
      Size = 128
    end
    object qryMemberFName: TWideStringField
      FieldName = 'FName'
      Origin = 'FName'
      ReadOnly = True
      Required = True
      Visible = False
      Size = 257
    end
    object qryMemberDOB: TSQLTimeStampField
      DisplayWidth = 12
      FieldName = 'DOB'
      Origin = 'DOB'
      DisplayFormat = 'dd/mm/yyyy'
    end
    object qryMemberSwimmerAge: TIntegerField
      DisplayLabel = 'Age'
      DisplayWidth = 4
      FieldName = 'SwimmerAge'
      Origin = 'SwimmerAge'
      ReadOnly = True
    end
    object qryMemberIsActive: TBooleanField
      Alignment = taCenter
      DisplayLabel = 'Active'
      FieldName = 'IsActive'
      Origin = 'IsActive'
    end
    object qryMemberIsSwimmer: TBooleanField
      FieldName = 'IsSwimmer'
      Origin = 'IsSwimmer'
    end
    object qryMemberIsArchived: TBooleanField
      FieldName = 'IsArchived'
      Origin = 'IsArchived'
    end
    object qryMemberEmail: TWideStringField
      DisplayWidth = 50
      FieldName = 'Email'
      Origin = 'Email'
      Size = 256
    end
    object qryMemberSwimClubID: TIntegerField
      FieldName = 'SwimClubID'
      Origin = 'SwimClubID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Visible = False
    end
    object qryMemberCreatedOn: TSQLTimeStampField
      FieldName = 'CreatedOn'
      Origin = 'CreatedOn'
    end
    object qryMemberArchivedOn: TSQLTimeStampField
      FieldName = 'ArchivedOn'
      Origin = 'ArchivedOn'
    end
    object qryMemberGenderID: TIntegerField
      FieldName = 'GenderID'
      Origin = 'GenderID'
      Visible = False
    end
    object qryMemberluGender: TStringField
      DisplayLabel = 'Gender'
      DisplayWidth = 12
      FieldKind = fkLookup
      FieldName = 'luGender'
      LookupDataSet = tblGender
      LookupKeyFields = 'GenderID'
      LookupResultField = 'Caption'
      KeyFields = 'GenderID'
      Lookup = True
    end
    object qryMemberluMembershipType: TStringField
      DisplayLabel = 'Membership Type'
      DisplayWidth = 24
      FieldKind = fkLookup
      FieldName = 'luMembershipType'
      LookupDataSet = tblMembershipType
      LookupKeyFields = 'MembershipTypeID'
      LookupResultField = 'Caption'
      KeyFields = 'MembershipTypeID'
      Size = 24
      Lookup = True
    end
    object qryMemberMembershipTypeID: TIntegerField
      FieldName = 'MembershipTypeID'
      Origin = 'MembershipTypeID'
      Visible = False
    end
    object qryMemberluHouse: TStringField
      DisplayLabel = 'House'
      DisplayWidth = 14
      FieldKind = fkLookup
      FieldName = 'luHouse'
      LookupDataSet = tblHouse
      LookupKeyFields = 'HouseID'
      LookupResultField = 'Caption'
      KeyFields = 'HouseID'
      Lookup = True
    end
    object qryMemberHouseID: TIntegerField
      DisplayLabel = 'House'
      DisplayWidth = 14
      FieldName = 'HouseID'
      Origin = 'HouseID'
      Visible = False
    end
  end
  object tblMembershipType: TFDTable
    ActiveStoredUsage = [auDesignTime]
    Active = True
    IndexFieldNames = 'MembershipTypeID'
    Connection = SCMConnection
    UpdateOptions.UpdateTableName = 'SwimClubMeet..MembershipType'
    TableName = 'SwimClubMeet..MembershipType'
    Left = 282
    Top = 176
  end
  object dsMembershipType: TDataSource
    DataSet = tblMembershipType
    Left = 370
    Top = 176
  end
  object tblGender: TFDTable
    ActiveStoredUsage = [auDesignTime]
    Active = True
    IndexFieldNames = 'GenderID'
    Connection = SCMConnection
    UpdateOptions.UpdateTableName = 'SwimClubMeet..Gender'
    TableName = 'SwimClubMeet..Gender'
    Left = 286
    Top = 272
  end
  object dsGender: TDataSource
    DataSet = tblGender
    Left = 368
    Top = 272
  end
  object dsHouse: TDataSource
    DataSet = tblHouse
    Left = 372
    Top = 224
  end
  object tblHouse: TFDTable
    ActiveStoredUsage = [auDesignTime]
    Active = True
    IndexFieldNames = 'HouseID'
    Connection = SCMConnection
    UpdateOptions.UpdateTableName = 'SwimClubMeet..House'
    TableName = 'SwimClubMeet..House'
    Left = 286
    Top = 224
  end
  object dsContactNum: TDataSource
    DataSet = qryContactNum
    Left = 119
    Top = 184
  end
  object qryContactNum: TFDQuery
    ActiveStoredUsage = [auDesignTime]
    Active = True
    Indexes = <
      item
        Active = True
        Selected = True
        Name = 'mcMember_ContactNum'
        Fields = 'MemberID;ContactNumID'
        DescFields = 'ContactNumID'
      end>
    IndexName = 'mcMember_ContactNum'
    MasterSource = dsMember
    MasterFields = 'MemberID'
    Connection = SCMConnection
    UpdateOptions.UpdateTableName = 'SwimClubMeet..ContactNum'
    UpdateOptions.KeyFields = 'ContactNumID'
    SQL.Strings = (
      'USE [SwimClubMeet]'
      ''
      ''
      'SELECT ContactNum.ContactNumID'
      #9',ContactNum.Number'
      #9',ContactNum.ContactNumTypeID'
      #9',ContactNum.MemberID'
      'FROM ContactNum')
    Left = 57
    Top = 184
    object qryContactNumContactNumID: TFDAutoIncField
      FieldName = 'ContactNumID'
      Origin = 'ContactNumID'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object qryContactNumNumber: TWideStringField
      FieldName = 'Number'
      Origin = 'Number'
      Size = 30
    end
    object qryContactNumContactNumTypeID: TIntegerField
      FieldName = 'ContactNumTypeID'
      Origin = 'ContactNumTypeID'
    end
    object qryContactNumMemberID: TIntegerField
      FieldName = 'MemberID'
      Origin = 'MemberID'
    end
    object qryContactNumlu: TStringField
      FieldKind = fkLookup
      FieldName = 'luContactNumType'
      LookupDataSet = tblContactNumType
      LookupKeyFields = 'ContactNumTypeID'
      LookupResultField = 'Caption'
      KeyFields = 'ContactNumTypeID'
      Lookup = True
    end
  end
  object qrySwimClub: TFDQuery
    Connection = SCMConnection
    SQL.Strings = (
      'USE SwimClubMeet;'
      ''
      ''
      'DECLARE @SwimClubID AS Integer;'
      'SET @SwimClubID = :SWIMCLUBID;'
      ''
      'SELECT [SwimClubID],'
      '       [NickName],'
      '       [Caption],'
      '       [Email],'
      '       [ContactNum],'
      '       [WebSite],'
      '       [HeatAlgorithm],'
      '       [EnableTeamEvents],'
      '       [EnableSwimOThon],'
      '       [EnableExtHeatTypes],'
      '       [EnableMembershipStr],'
      '       [NumOfLanes],'
      '       [LenOfPool],'
      '       [StartOfSwimSeason],'
      '       [CreatedOn],'
      
        '       SUBSTRING(CONCAT(SwimClub.Caption, '#39' ('#39', SwimClub.NickNam' +
        'e, '#39')'#39'), 0, 60) AS DetailStr'
      'FROM SwimCLub'
      'WHERE Swimclub.SwimClubID = 1;')
    Left = 224
    Top = 32
    ParamData = <
      item
        Name = 'SWIMCLUBID'
        DataType = ftInteger
        ParamType = ptInput
        Value = 1
      end>
  end
  object dsSwimClub: TDataSource
    DataSet = qrySwimClub
    Left = 296
    Top = 32
  end
  object qryFindMember: TFDQuery
    ActiveStoredUsage = [auDesignTime]
    Active = True
    Filtered = True
    FilterOptions = [foCaseInsensitive]
    Filter = '(GenderID = 1 OR GenderID = 2) AND (IsActive = TRUE)'
    IndexFieldNames = 'MemberID'
    Connection = SCMConnection
    UpdateOptions.AssignedValues = [uvEDelete, uvEInsert, uvEUpdate]
    UpdateOptions.EnableDelete = False
    UpdateOptions.EnableInsert = False
    UpdateOptions.EnableUpdate = False
    SQL.Strings = (
      'SELECT        '
      'Member.FirstName'
      ', Member.LastName'
      ', Member.MemberID'
      ', Member.GenderID'
      ', Member.MemberShipTypeID'
      ', Member.MembershipNum'
      ', FORMAT(Member.DOB, '#39'dd/MM/yyyy'#39') AS dtDOB'
      ', Member.IsActive'
      ', Member.MembershipDue'
      ', Gender.Caption AS cGender'
      '--, SwimClub.Caption AS cSwimClub'
      '--, SwimClub.NickName'
      ', MembershipType.Caption AS cMembershipType'
      ', MembershipType.IsSwimmer'
      ', CONCAT(UPPER([LastName]), '#39', '#39', Member.FirstName ) AS FName'
      ', DATEDIFF ( year , [DOB], GETDATE() ) AS Age'
      'FROM            Member '
      'LEFT OUTER JOIN'
      
        '                         MembershipType ON Member.MembershipType' +
        'ID = MembershipType.MembershipTypeID '
      'LEFT OUTER JOIN'
      
        '                         SwimClub ON Member.SwimClubID = SwimClu' +
        'b.SwimClubID '
      'LEFT OUTER JOIN'
      
        '                         Gender ON Member.GenderID = Gender.Gend' +
        'erID'
      #9#9#9#9#9'ORDER BY Member.LastName')
    Left = 446
    Top = 24
    object qryFindMemberMemberID: TFDAutoIncField
      Alignment = taCenter
      DisplayLabel = '  ID'
      DisplayWidth = 5
      FieldName = 'MemberID'
      Origin = 'MemberID'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
      DisplayFormat = '0000'
    end
    object qryFindMemberMembershipNum: TIntegerField
      DisplayLabel = 'Num#'
      DisplayWidth = 6
      FieldName = 'MembershipNum'
      Origin = 'MembershipNum'
      DisplayFormat = '##00'
    end
    object qryFindMemberFName: TWideStringField
      DisplayLabel = 'Member'#39's Name'
      DisplayWidth = 160
      FieldName = 'FName'
      Origin = 'FName'
      ReadOnly = True
      Required = True
      Size = 258
    end
    object qryFindMemberdtDOB: TWideStringField
      Alignment = taCenter
      DisplayLabel = '  DOB'
      DisplayWidth = 11
      FieldName = 'dtDOB'
      Origin = 'dtDOB'
      ReadOnly = True
      Size = 4000
    end
    object qryFindMemberAge: TIntegerField
      Alignment = taCenter
      DisplayWidth = 3
      FieldName = 'Age'
      Origin = 'Age'
      ReadOnly = True
      DisplayFormat = '#0'
    end
    object qryFindMemberIsActive: TBooleanField
      DisplayLabel = 'Active'
      DisplayWidth = 6
      FieldName = 'IsActive'
      Origin = 'IsActive'
    end
    object qryFindMembercGender: TWideStringField
      DisplayLabel = 'Gender'
      DisplayWidth = 7
      FieldName = 'cGender'
      Origin = 'cGender'
    end
    object qryFindMembercMembershipType: TWideStringField
      DisplayLabel = 'Membership Type'
      DisplayWidth = 30
      FieldName = 'cMembershipType'
      Origin = 'cMembershipType'
      Size = 64
    end
    object qryFindMemberFirstName: TWideStringField
      FieldName = 'FirstName'
      Origin = 'FirstName'
      Visible = False
      Size = 128
    end
    object qryFindMemberLastName: TWideStringField
      FieldName = 'LastName'
      Origin = 'LastName'
      Visible = False
      Size = 128
    end
    object qryFindMemberGenderID: TIntegerField
      FieldName = 'GenderID'
      Origin = 'GenderID'
      Visible = False
    end
    object qryFindMemberMemberShipTypeID: TIntegerField
      FieldName = 'MemberShipTypeID'
      Origin = 'MemberShipTypeID'
      Visible = False
    end
    object qryFindMemberIsSwimmer: TBooleanField
      FieldName = 'IsSwimmer'
      Origin = 'IsSwimmer'
      Visible = False
    end
  end
  object dsFindMember: TDataSource
    DataSet = qryFindMember
    Left = 534
    Top = 24
  end
  object qAssertMemberID: TFDQuery
    ActiveStoredUsage = [auDesignTime]
    IndexFieldNames = 'MemberID'
    Connection = SCMConnection
    SQL.Strings = (
      'SELECT MemberID, MembershipNum FROM Member WHERE SwimClubID = 1')
    Left = 72
    Top = 312
  end
  object qryEntrantDataCount: TFDQuery
    ActiveStoredUsage = [auDesignTime]
    Connection = SCMConnection
    UpdateOptions.AssignedValues = [uvEDelete, uvEInsert, uvEUpdate]
    UpdateOptions.EnableDelete = False
    UpdateOptions.EnableInsert = False
    UpdateOptions.EnableUpdate = False
    SQL.Strings = (
      'USE SwimClubMeet;'
      ''
      'DECLARE @MemberID as INTEGER;'
      'SET @MemberID = :MEMBERID; -- 57;'
      ''
      'SELECT Count(EntrantID) as TOT FROM Entrant WHERE'
      
        'MemberID = @MemberID AND (RaceTime IS NOT NULL OR (dbo.SwimTimeT' +
        'oMilliseconds(RaceTime) > 0));')
    Left = 80
    Top = 376
    ParamData = <
      item
        Name = 'MEMBERID'
        DataType = ftInteger
        ParamType = ptInput
        Value = 57
      end>
  end
end
