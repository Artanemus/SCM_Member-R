USE SwimClubMeet;


DECLARE @SwimClubID AS Integer;
SET @SwimClubID = 1; --:SWIMCLUBID;

SELECT [SwimClubID],
       [NickName],
       [Caption],
       [Email],
       [ContactNum],
       [WebSite],
       [HeatAlgorithm],
       [EnableTeamEvents],
       [EnableSwimOThon],
       [EnableExtHeatTypes],
       [EnableMembershipStr],
       [NumOfLanes],
       [LenOfPool],
       [StartOfSwimSeason],
       [CreatedOn],
       SUBSTRING(CONCAT(SwimClub.Caption, ' (', SwimClub.NickName, ')'), 0, 60) AS DetailStr
FROM SwimCLub
WHERE Swimclub.SwimClubID = 1;
