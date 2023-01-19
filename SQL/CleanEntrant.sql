USE SwimClubMeet;

DECLARE @MemberID AS INTEGER;
SET @MemberID = 0;
UPDATE [SwimClubMeet].[dbo].[Entrant]
SET [MemberID] = NULL
  , [RaceTime] = NULL
  , [TimeToBeat] = NULL
  , [PersonalBest] = NULL
  , [IsDisqualified] = 0
  , [IsScratched] = 0
WHERE MemberID = @MemberID;


