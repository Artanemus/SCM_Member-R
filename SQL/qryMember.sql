USE [SwimClubMeet]

DECLARE @HideInActive BIT;
DECLARE @HideArchived BIT;
DECLARE @HideNonSwimmers BIT;
DECLARE @SwimClubID INTEGER;

SET @HideInActive = 0; -- :HIDE_INACTIVE;
SET @HideArchived = 0; -- :HIDE_ARCHIVED;
SET @HideNonSwimmers = 0; -- :HIDE_NONSWIMMERS;
SET @SwimClubID = 1; --:SWIMCLUBID; 

SELECT [MemberID],
       [MembershipNum],
       [MembershipStr],
       [MembershipDue],
       [FirstName],
       [LastName],
       [DOB],
       dbo.SwimmerAge(GETDATE(), [DOB]) AS SwimmerAge,
       [IsActive],
       IsSwimmer,
       IsArchived,
       [Email],
       [GenderID],
       [SwimClubID],
       [MembershipTypeID],
       CONCAT(Member.FirstName, ' ', UPPER(Member.LastName)) AS FName,
       HouseID,
       CreatedOn,
       ArchivedOn
FROM [dbo].[Member]
WHERE (IsActive >= CASE
                       WHEN @HideInActive = 1 THEN
                           1
                       ELSE
                           0
                   END
      )
      AND (IsArchived <= CASE
                             WHEN @HideArchived = 1 THEN
                                 0
                             ELSE
                                 1
                         END
          )
      AND (IsSwimmer >= CASE
                            WHEN @HideNonSwimmers = 1 THEN
                                1
                            ELSE
                                0
                        END
          )
      OR
      (
          IsArchived IS NULL
          AND @HideArchived = 0
      )
      OR
      (
          IsActive IS NULL
          AND @HideInActive = 0
      )
      OR
      (
          IsSwimmer IS NULL
          AND @HideNonSwimmers = 0
      );




