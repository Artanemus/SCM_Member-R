USE SwimClubMeet;

DECLARE @MemberID as INTEGER;
SET @MemberID = 57;

SELECT Count(EntrantID) as TOT FROM Entrant WHERE
MemberID = @MemberID AND (RaceTime IS NOT NULL OR (dbo.SwimTimeToMilliseconds(RaceTime) > 0));