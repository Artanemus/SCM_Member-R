USE SwimClubMeet;

DECLARE @MemberID as Integer;
SET @MemberID = 0;

DELETE FROM [SwimClubMeet].[dbo].[ContactNum]
    WHERE MemberID = @MemberID;