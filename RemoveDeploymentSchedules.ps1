#  In case you goof and need to remove all the deployment schedules.

# Variables - Required
$AutomationAccount=""
$ResourceGroupName=""
$TenantID=""
$SubscriptionID=""

Connect-AzAccount -Tenant $TenantID -SubscriptionId $SubscriptionID

$ScheduleConfig = @(
[pscustomobject]@{ScheduleName='1st Monday UTC0 - Windows Update';OS='Windows';DayofWeek='Monday';TagName='UpdateWindow';TagValue='MON1UTC0';StartTime='00:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='1st Monday UTC0 - Linux Update';OS='Linux';DayofWeek='Monday';TagName='UpdateWindow';TagValue='MON1UTC0';StartTime='00:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='2nd Monday UTC0 - Windows Update';OS='Windows';DayofWeek='Monday';TagName='UpdateWindow';TagValue='MON2UTC0';StartTime='00:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='2nd Monday UTC0 - Linux Update';OS='Linux';DayofWeek='Monday';TagName='UpdateWindow';TagValue='MON2UTC0';StartTime='00:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='3rd Monday UTC0 - Windows Update';OS='Windows';DayofWeek='Monday';TagName='UpdateWindow';TagValue='MON3UTC0';StartTime='00:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='3rd Monday UTC0 - Linux Update';OS='Linux';DayofWeek='Monday';TagName='UpdateWindow';TagValue='MON3UTC0';StartTime='00:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='1st Monday UTC8 - Windows Update';OS='Windows';DayofWeek='Monday';TagName='UpdateWindow';TagValue='MON1UTC8';StartTime='08:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='1st Monday UTC8 - Linux Update';OS='Linux';DayofWeek='Monday';TagName='UpdateWindow';TagValue='MON1UTC8';StartTime='08:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='2nd Monday UTC8 - Windows Update';OS='Windows';DayofWeek='Monday';TagName='UpdateWindow';TagValue='MON2UTC8';StartTime='08:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='2nd Monday UTC8 - Linux Update';OS='Linux';DayofWeek='Monday';TagName='UpdateWindow';TagValue='MON2UTC8';StartTime='08:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='3rd Monday UTC8 - Windows Update';OS='Windows';DayofWeek='Monday';TagName='UpdateWindow';TagValue='MON3UTC8';StartTime='08:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='3rd Monday UTC8 - Linux Update';OS='Linux';DayofWeek='Monday';TagName='UpdateWindow';TagValue='MON3UTC8';StartTime='08:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='1st Monday UTC16 - Windows Update';OS='Windows';DayofWeek='Monday';TagName='UpdateWindow';TagValue='MON1UTC16';StartTime='16:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='1st Monday UTC16 - Linux Update';OS='Linux';DayofWeek='Monday';TagName='UpdateWindow';TagValue='MON1UTC16';StartTime='16:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='2nd Monday UTC16 - Windows Update';OS='Windows';DayofWeek='Monday';TagName='UpdateWindow';TagValue='MON2UTC16';StartTime='16:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='2nd Monday UTC16 - Linux Update';OS='Linux';DayofWeek='Monday';TagName='UpdateWindow';TagValue='MON2UTC16';StartTime='16:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='3rd Monday UTC16 - Windows Update';OS='Windows';DayofWeek='Monday';TagName='UpdateWindow';TagValue='MON3UTC16';StartTime='16:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='3rd Monday UTC16 - Linux Update';OS='Linux';DayofWeek='Monday';TagName='UpdateWindow';TagValue='MON3UTC16';StartTime='16:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='1st Tuesday UTC0 - Windows Update';OS='Windows';DayofWeek='Tuesday';TagName='UpdateWindow';TagValue='TUE1UTC0';StartTime='00:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='1st Tuesday UTC0 - Linux Update';OS='Linux';DayofWeek='Tuesday';TagName='UpdateWindow';TagValue='TUE1UTC0';StartTime='00:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='2nd Tuesday UTC0 - Windows Update';OS='Windows';DayofWeek='Tuesday';TagName='UpdateWindow';TagValue='TUE2UTC0';StartTime='00:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='2nd Tuesday UTC0 - Linux Update';OS='Linux';DayofWeek='Tuesday';TagName='UpdateWindow';TagValue='TUE2UTC0';StartTime='00:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='3rd Tuesday UTC0 - Windows Update';OS='Windows';DayofWeek='Tuesday';TagName='UpdateWindow';TagValue='TUE3UTC0';StartTime='00:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='3rd Tuesday UTC0 - Linux Update';OS='Linux';DayofWeek='Tuesday';TagName='UpdateWindow';TagValue='TUE3UTC0';StartTime='00:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='1st Tuesday UTC8 - Windows Update';OS='Windows';DayofWeek='Tuesday';TagName='UpdateWindow';TagValue='TUE1UTC8';StartTime='08:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='1st Tuesday UTC8 - Linux Update';OS='Linux';DayofWeek='Tuesday';TagName='UpdateWindow';TagValue='TUE1UTC8';StartTime='08:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='2nd Tuesday UTC8 - Windows Update';OS='Windows';DayofWeek='Tuesday';TagName='UpdateWindow';TagValue='TUE2UTC8';StartTime='08:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='2nd Tuesday UTC8 - Linux Update';OS='Linux';DayofWeek='Tuesday';TagName='UpdateWindow';TagValue='TUE2UTC8';StartTime='08:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='3rd Tuesday UTC8 - Windows Update';OS='Windows';DayofWeek='Tuesday';TagName='UpdateWindow';TagValue='TUE3UTC8';StartTime='08:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='3rd Tuesday UTC8 - Linux Update';OS='Linux';DayofWeek='Tuesday';TagName='UpdateWindow';TagValue='TUE3UTC8';StartTime='08:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='1st Tuesday UTC16 - Windows Update';OS='Windows';DayofWeek='Tuesday';TagName='UpdateWindow';TagValue='TUE1UTC16';StartTime='16:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='1st Tuesday UTC16 - Linux Update';OS='Linux';DayofWeek='Tuesday';TagName='UpdateWindow';TagValue='TUE1UTC16';StartTime='16:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='2nd Tuesday UTC16 - Windows Update';OS='Windows';DayofWeek='Tuesday';TagName='UpdateWindow';TagValue='TUE2UTC16';StartTime='16:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='2nd Tuesday UTC16 - Linux Update';OS='Linux';DayofWeek='Tuesday';TagName='UpdateWindow';TagValue='TUE2UTC16';StartTime='16:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='3rd Tuesday UTC16 - Windows Update';OS='Windows';DayofWeek='Tuesday';TagName='UpdateWindow';TagValue='TUE3UTC16';StartTime='16:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='3rd Tuesday UTC16 - Linux Update';OS='Linux';DayofWeek='Tuesday';TagName='UpdateWindow';TagValue='TUE3UTC16';StartTime='16:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='1st Wednesday UTC0 - Windows Update';OS='Windows';DayofWeek='Wednesday';TagName='UpdateWindow';TagValue='WED1UTC0';StartTime='00:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='1st Wednesday UTC0 - Linux Update';OS='Linux';DayofWeek='Wednesday';TagName='UpdateWindow';TagValue='WED1UTC0';StartTime='00:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='2nd Wednesday UTC0 - Windows Update';OS='Windows';DayofWeek='Wednesday';TagName='UpdateWindow';TagValue='WED2UTC0';StartTime='00:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='2nd Wednesday UTC0 - Linux Update';OS='Linux';DayofWeek='Wednesday';TagName='UpdateWindow';TagValue='WED2UTC0';StartTime='00:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='3rd Wednesday UTC0 - Windows Update';OS='Windows';DayofWeek='Wednesday';TagName='UpdateWindow';TagValue='WED3UTC0';StartTime='00:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='3rd Wednesday UTC0 - Linux Update';OS='Linux';DayofWeek='Wednesday';TagName='UpdateWindow';TagValue='WED3UTC0';StartTime='00:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='1st Wednesday UTC8 - Windows Update';OS='Windows';DayofWeek='Wednesday';TagName='UpdateWindow';TagValue='WED1UTC8';StartTime='08:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='1st Wednesday UTC8 - Linux Update';OS='Linux';DayofWeek='Wednesday';TagName='UpdateWindow';TagValue='WED1UTC8';StartTime='08:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='2nd Wednesday UTC8 - Windows Update';OS='Windows';DayofWeek='Wednesday';TagName='UpdateWindow';TagValue='WED2UTC8';StartTime='08:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='2nd Wednesday UTC8 - Linux Update';OS='Linux';DayofWeek='Wednesday';TagName='UpdateWindow';TagValue='WED2UTC8';StartTime='08:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='3rd Wednesday UTC8 - Windows Update';OS='Windows';DayofWeek='Wednesday';TagName='UpdateWindow';TagValue='WED3UTC8';StartTime='08:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='3rd Wednesday UTC8 - Linux Update';OS='Linux';DayofWeek='Wednesday';TagName='UpdateWindow';TagValue='WED3UTC8';StartTime='08:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='1st Wednesday UTC16 - Windows Update';OS='Windows';DayofWeek='Wednesday';TagName='UpdateWindow';TagValue='WED1UTC16';StartTime='16:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='1st Wednesday UTC16 - Linux Update';OS='Linux';DayofWeek='Wednesday';TagName='UpdateWindow';TagValue='WED1UTC16';StartTime='16:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='2nd Wednesday UTC16 - Windows Update';OS='Windows';DayofWeek='Wednesday';TagName='UpdateWindow';TagValue='WED2UTC16';StartTime='16:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='2nd Wednesday UTC16 - Linux Update';OS='Linux';DayofWeek='Wednesday';TagName='UpdateWindow';TagValue='WED2UTC16';StartTime='16:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='3rd Wednesday UTC16 - Windows Update';OS='Windows';DayofWeek='Wednesday';TagName='UpdateWindow';TagValue='WED3UTC16';StartTime='16:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='3rd Wednesday UTC16 - Linux Update';OS='Linux';DayofWeek='Wednesday';TagName='UpdateWindow';TagValue='WED3UTC16';StartTime='16:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='1st Thursday UTC0 - Windows Update';OS='Windows';DayofWeek='Thursday';TagName='UpdateWindow';TagValue='THU1UTC0';StartTime='00:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='1st Thursday UTC0 - Linux Update';OS='Linux';DayofWeek='Thursday';TagName='UpdateWindow';TagValue='THU1UTC0';StartTime='00:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='2nd Thursday UTC0 - Windows Update';OS='Windows';DayofWeek='Thursday';TagName='UpdateWindow';TagValue='THU2UTC0';StartTime='00:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='2nd Thursday UTC0 - Linux Update';OS='Linux';DayofWeek='Thursday';TagName='UpdateWindow';TagValue='THU2UTC0';StartTime='00:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='3rd Thursday UTC0 - Windows Update';OS='Windows';DayofWeek='Thursday';TagName='UpdateWindow';TagValue='THU3UTC0';StartTime='00:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='3rd Thursday UTC0 - Linux Update';OS='Linux';DayofWeek='Thursday';TagName='UpdateWindow';TagValue='THU3UTC0';StartTime='00:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='1st Thursday UTC8 - Windows Update';OS='Windows';DayofWeek='Thursday';TagName='UpdateWindow';TagValue='THU1UTC8';StartTime='08:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='1st Thursday UTC8 - Linux Update';OS='Linux';DayofWeek='Thursday';TagName='UpdateWindow';TagValue='THU1UTC8';StartTime='08:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='2nd Thursday UTC8 - Windows Update';OS='Windows';DayofWeek='Thursday';TagName='UpdateWindow';TagValue='THU2UTC8';StartTime='08:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='2nd Thursday UTC8 - Linux Update';OS='Linux';DayofWeek='Thursday';TagName='UpdateWindow';TagValue='THU2UTC8';StartTime='08:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='3rd Thursday UTC8 - Windows Update';OS='Windows';DayofWeek='Thursday';TagName='UpdateWindow';TagValue='THU3UTC8';StartTime='08:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='3rd Thursday UTC8 - Linux Update';OS='Linux';DayofWeek='Thursday';TagName='UpdateWindow';TagValue='THU3UTC8';StartTime='08:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='1st Thursday UTC16 - Windows Update';OS='Windows';DayofWeek='Thursday';TagName='UpdateWindow';TagValue='THU1UTC16';StartTime='16:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='1st Thursday UTC16 - Linux Update';OS='Linux';DayofWeek='Thursday';TagName='UpdateWindow';TagValue='THU1UTC16';StartTime='16:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='2nd Thursday UTC16 - Windows Update';OS='Windows';DayofWeek='Thursday';TagName='UpdateWindow';TagValue='THU2UTC16';StartTime='16:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='2nd Thursday UTC16 - Linux Update';OS='Linux';DayofWeek='Thursday';TagName='UpdateWindow';TagValue='THU2UTC16';StartTime='16:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='3rd Thursday UTC16 - Windows Update';OS='Windows';DayofWeek='Thursday';TagName='UpdateWindow';TagValue='THU3UTC16';StartTime='16:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='3rd Thursday UTC16 - Linux Update';OS='Linux';DayofWeek='Thursday';TagName='UpdateWindow';TagValue='THU3UTC16';StartTime='16:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='1st Friday UTC0 - Windows Update';OS='Windows';DayofWeek='Friday';TagName='UpdateWindow';TagValue='FRI1UTC0';StartTime='00:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='1st Friday UTC0 - Linux Update';OS='Linux';DayofWeek='Friday';TagName='UpdateWindow';TagValue='FRI1UTC0';StartTime='00:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='2nd Friday UTC0 - Windows Update';OS='Windows';DayofWeek='Friday';TagName='UpdateWindow';TagValue='FRI2UTC0';StartTime='00:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='2nd Friday UTC0 - Linux Update';OS='Linux';DayofWeek='Friday';TagName='UpdateWindow';TagValue='FRI2UTC0';StartTime='00:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='3rd Friday UTC0 - Windows Update';OS='Windows';DayofWeek='Friday';TagName='UpdateWindow';TagValue='FRI3UTC0';StartTime='00:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='3rd Friday UTC0 - Linux Update';OS='Linux';DayofWeek='Friday';TagName='UpdateWindow';TagValue='FRI3UTC0';StartTime='00:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='1st Friday UTC8 - Windows Update';OS='Windows';DayofWeek='Friday';TagName='UpdateWindow';TagValue='FRI1UTC8';StartTime='08:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='1st Friday UTC8 - Linux Update';OS='Linux';DayofWeek='Friday';TagName='UpdateWindow';TagValue='FRI1UTC8';StartTime='08:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='2nd Friday UTC8 - Windows Update';OS='Windows';DayofWeek='Friday';TagName='UpdateWindow';TagValue='FRI2UTC8';StartTime='08:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='2nd Friday UTC8 - Linux Update';OS='Linux';DayofWeek='Friday';TagName='UpdateWindow';TagValue='FRI2UTC8';StartTime='08:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='3rd Friday UTC8 - Windows Update';OS='Windows';DayofWeek='Friday';TagName='UpdateWindow';TagValue='FRI3UTC8';StartTime='08:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='3rd Friday UTC8 - Linux Update';OS='Linux';DayofWeek='Friday';TagName='UpdateWindow';TagValue='FRI3UTC8';StartTime='08:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='1st Friday UTC16 - Windows Update';OS='Windows';DayofWeek='Friday';TagName='UpdateWindow';TagValue='FRI1UTC16';StartTime='16:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='1st Friday UTC16 - Linux Update';OS='Linux';DayofWeek='Friday';TagName='UpdateWindow';TagValue='FRI1UTC16';StartTime='16:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='2nd Friday UTC16 - Windows Update';OS='Windows';DayofWeek='Friday';TagName='UpdateWindow';TagValue='FRI2UTC16';StartTime='16:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='2nd Friday UTC16 - Linux Update';OS='Linux';DayofWeek='Friday';TagName='UpdateWindow';TagValue='FRI2UTC16';StartTime='16:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='3rd Friday UTC16 - Windows Update';OS='Windows';DayofWeek='Friday';TagName='UpdateWindow';TagValue='FRI3UTC16';StartTime='16:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='3rd Friday UTC16 - Linux Update';OS='Linux';DayofWeek='Friday';TagName='UpdateWindow';TagValue='FRI3UTC16';StartTime='16:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='1st Saturday UTC0 - Windows Update';OS='Windows';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT1UTC0';StartTime='00:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='1st Saturday UTC0 - Linux Update';OS='Linux';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT1UTC0';StartTime='00:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='2nd Saturday UTC0 - Windows Update';OS='Windows';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT2UTC0';StartTime='00:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='2nd Saturday UTC0 - Linux Update';OS='Linux';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT2UTC0';StartTime='00:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='3rd Saturday UTC0 - Windows Update';OS='Windows';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT3UTC0';StartTime='00:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='3rd Saturday UTC0 - Linux Update';OS='Linux';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT3UTC0';StartTime='00:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='1st Saturday UTC8 - Windows Update';OS='Windows';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT1UTC8';StartTime='08:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='1st Saturday UTC8 - Linux Update';OS='Linux';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT1UTC8';StartTime='08:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='2nd Saturday UTC8 - Windows Update';OS='Windows';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT2UTC8';StartTime='08:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='2nd Saturday UTC8 - Linux Update';OS='Linux';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT2UTC8';StartTime='08:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='3rd Saturday UTC8 - Windows Update';OS='Windows';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT3UTC8';StartTime='08:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='3rd Saturday UTC8 - Linux Update';OS='Linux';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT3UTC8';StartTime='08:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='1st Saturday UTC16 - Windows Update';OS='Windows';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT1UTC16';StartTime='16:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='1st Saturday UTC16 - Linux Update';OS='Linux';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT1UTC16';StartTime='16:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='2nd Saturday UTC16 - Windows Update';OS='Windows';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT2UTC16';StartTime='16:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='2nd Saturday UTC16 - Linux Update';OS='Linux';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT2UTC16';StartTime='16:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='3rd Saturday UTC16 - Windows Update';OS='Windows';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT3UTC16';StartTime='16:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='3rd Saturday UTC16 - Linux Update';OS='Linux';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT3UTC16';StartTime='16:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='1st Sunday UTC0 - Windows Update';OS='Windows';DayofWeek='Sunday';TagName='UpdateWindow';TagValue='SUN1UTC0';StartTime='00:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='1st Sunday UTC0 - Linux Update';OS='Linux';DayofWeek='Sunday';TagName='UpdateWindow';TagValue='SUN1UTC0';StartTime='00:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='2nd Sunday UTC0 - Windows Update';OS='Windows';DayofWeek='Sunday';TagName='UpdateWindow';TagValue='SUN2UTC0';StartTime='00:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='2nd Sunday UTC0 - Linux Update';OS='Linux';DayofWeek='Sunday';TagName='UpdateWindow';TagValue='SUN2UTC0';StartTime='00:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='3rd Sunday UTC0 - Windows Update';OS='Windows';DayofWeek='Sunday';TagName='UpdateWindow';TagValue='SUN3UTC0';StartTime='00:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='3rd Sunday UTC0 - Linux Update';OS='Linux';DayofWeek='Sunday';TagName='UpdateWindow';TagValue='SUN3UTC0';StartTime='00:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='1st Sunday UTC8 - Windows Update';OS='Windows';DayofWeek='Sunday';TagName='UpdateWindow';TagValue='SUN1UTC8';StartTime='08:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='1st Sunday UTC8 - Linux Update';OS='Linux';DayofWeek='Sunday';TagName='UpdateWindow';TagValue='SUN1UTC8';StartTime='08:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='2nd Sunday UTC8 - Windows Update';OS='Windows';DayofWeek='Sunday';TagName='UpdateWindow';TagValue='SUN2UTC8';StartTime='08:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='2nd Sunday UTC8 - Linux Update';OS='Linux';DayofWeek='Sunday';TagName='UpdateWindow';TagValue='SUN2UTC8';StartTime='08:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='3rd Sunday UTC8 - Windows Update';OS='Windows';DayofWeek='Sunday';TagName='UpdateWindow';TagValue='SUN3UTC8';StartTime='08:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='3rd Sunday UTC8 - Linux Update';OS='Linux';DayofWeek='Sunday';TagName='UpdateWindow';TagValue='SUN3UTC8';StartTime='08:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='1st Sunday UTC16 - Windows Update';OS='Windows';DayofWeek='Sunday';TagName='UpdateWindow';TagValue='SUN1UTC16';StartTime='16:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='1st Sunday UTC16 - Linux Update';OS='Linux';DayofWeek='Sunday';TagName='UpdateWindow';TagValue='SUN1UTC16';StartTime='16:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='2nd Sunday UTC16 - Windows Update';OS='Windows';DayofWeek='Sunday';TagName='UpdateWindow';TagValue='SUN2UTC16';StartTime='16:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='2nd Sunday UTC16 - Linux Update';OS='Linux';DayofWeek='Sunday';TagName='UpdateWindow';TagValue='SUN2UTC16';StartTime='16:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='3rd Sunday UTC16 - Windows Update';OS='Windows';DayofWeek='Sunday';TagName='UpdateWindow';TagValue='SUN3UTC16';StartTime='16:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='3rd Sunday UTC16 - Linux Update';OS='Linux';DayofWeek='Sunday';TagName='UpdateWindow';TagValue='SUN3UTC16';StartTime='16:00';DaysofWeekOccurrence='Third'}
)

$ScheduleNames=$ScheduleConfig.ScheduleName

foreach($ScheduleName in $ScheduleNames){

    Remove-AzAutomationSoftwareUpdateConfiguration -ResourceGroupName $ResourceGroupName -AutomationAccountName $AutomationAccount -Name $ScheduleName

}
