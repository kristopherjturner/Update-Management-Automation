###################################
#  This script is will create deployment schedules for Update Management.
#  Current Version:  .01000001 01111010 01110101 01110010 01100101
#  Date Written:   8-29-2019
#  Created By:    Kristopher J. Turner (The Country Cloud Boy)
#  Uses the Az Module and not the AzureRM module
#####################################

#  Need Authentication Step if not running within Azure CloudShell
#  If not using Cloudshell use the current version of Azure PowerShell
#  Use the AZ Module and not AzureRM Module

#  If running within Azure PowerShell uncomment the line below.  If running within Azure CloudShell do not comment out.

# Variables - Required
$AutomationAccount=""
$ResourceGroupName=""
$TenantID=""
$SubscriptionID=""

Connect-AzAccount -Tenant $TenantID -SubscriptionId $SubscriptionID

# Build the array
$ScheduleConfig = @(
[pscustomobject]@{ScheduleName='1st Monday UTC0 - Windows Update';Reboot='IfRequired';OS='Windows';DayofWeek='Monday';TagName='UpdateWindow';TagValue='MON1UTC0';StartTime='00:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='1st Monday UTC0 - Linux Update';Reboot='IfRequired';OS='Linux';DayofWeek='Monday';TagName='UpdateWindow';TagValue='MON1UTC0';StartTime='00:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='2nd Monday UTC0 - Windows Update';Reboot='IfRequired';OS='Windows';DayofWeek='Monday';TagName='UpdateWindow';TagValue='MON2UTC0';StartTime='00:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='2nd Monday UTC0 - Linux Update';Reboot='IfRequired';OS='Linux';DayofWeek='Monday';TagName='UpdateWindow';TagValue='MON2UTC0';StartTime='00:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='3rd Monday UTC0 - Windows Update';Reboot='IfRequired';OS='Windows';DayofWeek='Monday';TagName='UpdateWindow';TagValue='MON3UTC0';StartTime='00:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='3rd Monday UTC0 - Linux Update';Reboot='IfRequired';OS='Linux';DayofWeek='Monday';TagName='UpdateWindow';TagValue='MON3UTC0';StartTime='00:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='1st Monday UTC8 - Windows Update';Reboot='IfRequired';OS='Windows';DayofWeek='Monday';TagName='UpdateWindow';TagValue='MON1UTC8';StartTime='08:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='1st Monday UTC8 - Linux Update';Reboot='IfRequired';OS='Linux';DayofWeek='Monday';TagName='UpdateWindow';TagValue='MON1UTC8';StartTime='08:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='2nd Monday UTC8 - Windows Update';Reboot='IfRequired';OS='Windows';DayofWeek='Monday';TagName='UpdateWindow';TagValue='MON2UTC8';StartTime='08:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='2nd Monday UTC8 - Linux Update';Reboot='IfRequired';OS='Linux';DayofWeek='Monday';TagName='UpdateWindow';TagValue='MON2UTC8';StartTime='08:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='3rd Monday UTC8 - Windows Update';Reboot='IfRequired';OS='Windows';DayofWeek='Monday';TagName='UpdateWindow';TagValue='MON3UTC8';StartTime='08:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='3rd Monday UTC8 - Linux Update';Reboot='IfRequired';OS='Linux';DayofWeek='Monday';TagName='UpdateWindow';TagValue='MON3UTC8';StartTime='08:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='1st Monday UTC16 - Windows Update';Reboot='IfRequired';OS='Windows';DayofWeek='Monday';TagName='UpdateWindow';TagValue='MON1UTC16';StartTime='16:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='1st Monday UTC16 - Linux Update';Reboot='IfRequired';OS='Linux';DayofWeek='Monday';TagName='UpdateWindow';TagValue='MON1UTC16';StartTime='16:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='2nd Monday UTC16 - Windows Update';Reboot='IfRequired';OS='Windows';DayofWeek='Monday';TagName='UpdateWindow';TagValue='MON2UTC16';StartTime='16:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='2nd Monday UTC16 - Linux Update';Reboot='IfRequired';OS='Linux';DayofWeek='Monday';TagName='UpdateWindow';TagValue='MON2UTC16';StartTime='16:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='3rd Monday UTC16 - Windows Update';Reboot='IfRequired';OS='Windows';DayofWeek='Monday';TagName='UpdateWindow';TagValue='MON3UTC16';StartTime='16:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='3rd Monday UTC16 - Linux Update';Reboot='IfRequired';OS='Linux';DayofWeek='Monday';TagName='UpdateWindow';TagValue='MON3UTC16';StartTime='16:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='1st Tuesday UTC0 - Windows Update';Reboot='IfRequired';OS='Windows';DayofWeek='Tuesday';TagName='UpdateWindow';TagValue='TUE1UTC0';StartTime='00:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='1st Tuesday UTC0 - Linux Update';Reboot='IfRequired';OS='Linux';DayofWeek='Tuesday';TagName='UpdateWindow';TagValue='TUE1UTC0';StartTime='00:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='2nd Tuesday UTC0 - Windows Update';Reboot='IfRequired';OS='Windows';DayofWeek='Tuesday';TagName='UpdateWindow';TagValue='TUE2UTC0';StartTime='00:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='2nd Tuesday UTC0 - Linux Update';Reboot='IfRequired';OS='Linux';DayofWeek='Tuesday';TagName='UpdateWindow';TagValue='TUE2UTC0';StartTime='00:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='3rd Tuesday UTC0 - Windows Update';Reboot='IfRequired';OS='Windows';DayofWeek='Tuesday';TagName='UpdateWindow';TagValue='TUE3UTC0';StartTime='00:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='3rd Tuesday UTC0 - Linux Update';Reboot='IfRequired';OS='Linux';DayofWeek='Tuesday';TagName='UpdateWindow';TagValue='TUE3UTC0';StartTime='00:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='1st Tuesday UTC8 - Windows Update';Reboot='IfRequired';OS='Windows';DayofWeek='Tuesday';TagName='UpdateWindow';TagValue='TUE1UTC8';StartTime='08:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='1st Tuesday UTC8 - Linux Update';Reboot='IfRequired';OS='Linux';DayofWeek='Tuesday';TagName='UpdateWindow';TagValue='TUE1UTC8';StartTime='08:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='2nd Tuesday UTC8 - Windows Update';Reboot='IfRequired';OS='Windows';DayofWeek='Tuesday';TagName='UpdateWindow';TagValue='TUE2UTC8';StartTime='08:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='2nd Tuesday UTC8 - Linux Update';Reboot='IfRequired';OS='Linux';DayofWeek='Tuesday';TagName='UpdateWindow';TagValue='TUE2UTC8';StartTime='08:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='3rd Tuesday UTC8 - Windows Update';Reboot='IfRequired';OS='Windows';DayofWeek='Tuesday';TagName='UpdateWindow';TagValue='TUE3UTC8';StartTime='08:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='3rd Tuesday UTC8 - Linux Update';Reboot='IfRequired';OS='Linux';DayofWeek='Tuesday';TagName='UpdateWindow';TagValue='TUE3UTC8';StartTime='08:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='1st Tuesday UTC16 - Windows Update';Reboot='IfRequired';OS='Windows';DayofWeek='Tuesday';TagName='UpdateWindow';TagValue='TUE1UTC16';StartTime='16:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='1st Tuesday UTC16 - Linux Update';Reboot='IfRequired';OS='Linux';DayofWeek='Tuesday';TagName='UpdateWindow';TagValue='TUE1UTC16';StartTime='16:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='2nd Tuesday UTC16 - Windows Update';Reboot='IfRequired';OS='Windows';DayofWeek='Tuesday';TagName='UpdateWindow';TagValue='TUE2UTC16';StartTime='16:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='2nd Tuesday UTC16 - Linux Update';Reboot='IfRequired';OS='Linux';DayofWeek='Tuesday';TagName='UpdateWindow';TagValue='TUE2UTC16';StartTime='16:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='3rd Tuesday UTC16 - Windows Update';Reboot='IfRequired';OS='Windows';DayofWeek='Tuesday';TagName='UpdateWindow';TagValue='TUE3UTC16';StartTime='16:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='3rd Tuesday UTC16 - Linux Update';Reboot='IfRequired';OS='Linux';DayofWeek='Tuesday';TagName='UpdateWindow';TagValue='TUE3UTC16';StartTime='16:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='1st Wednesday UTC0 - Windows Update';Reboot='IfRequired';OS='Windows';DayofWeek='Wednesday';TagName='UpdateWindow';TagValue='WED1UTC0';StartTime='00:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='1st Wednesday UTC0 - Linux Update';Reboot='IfRequired';OS='Linux';DayofWeek='Wednesday';TagName='UpdateWindow';TagValue='WED1UTC0';StartTime='00:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='2nd Wednesday UTC0 - Windows Update';Reboot='IfRequired';OS='Windows';DayofWeek='Wednesday';TagName='UpdateWindow';TagValue='WED2UTC0';StartTime='00:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='2nd Wednesday UTC0 - Linux Update';Reboot='IfRequired';OS='Linux';DayofWeek='Wednesday';TagName='UpdateWindow';TagValue='WED2UTC0';StartTime='00:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='3rd Wednesday UTC0 - Windows Update';Reboot='IfRequired';OS='Windows';DayofWeek='Wednesday';TagName='UpdateWindow';TagValue='WED3UTC0';StartTime='00:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='3rd Wednesday UTC0 - Linux Update';Reboot='IfRequired';OS='Linux';DayofWeek='Wednesday';TagName='UpdateWindow';TagValue='WED3UTC0';StartTime='00:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='1st Wednesday UTC8 - Windows Update';Reboot='IfRequired';OS='Windows';DayofWeek='Wednesday';TagName='UpdateWindow';TagValue='WED1UTC8';StartTime='08:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='1st Wednesday UTC8 - Linux Update';Reboot='IfRequired';OS='Linux';DayofWeek='Wednesday';TagName='UpdateWindow';TagValue='WED1UTC8';StartTime='08:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='2nd Wednesday UTC8 - Windows Update';Reboot='IfRequired';OS='Windows';DayofWeek='Wednesday';TagName='UpdateWindow';TagValue='WED2UTC8';StartTime='08:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='2nd Wednesday UTC8 - Linux Update';Reboot='IfRequired';OS='Linux';DayofWeek='Wednesday';TagName='UpdateWindow';TagValue='WED2UTC8';StartTime='08:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='3rd Wednesday UTC8 - Windows Update';Reboot='IfRequired';OS='Windows';DayofWeek='Wednesday';TagName='UpdateWindow';TagValue='WED3UTC8';StartTime='08:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='3rd Wednesday UTC8 - Linux Update';Reboot='IfRequired';OS='Linux';DayofWeek='Wednesday';TagName='UpdateWindow';TagValue='WED3UTC8';StartTime='08:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='1st Wednesday UTC16 - Windows Update';Reboot='IfRequired';OS='Windows';DayofWeek='Wednesday';TagName='UpdateWindow';TagValue='WED1UTC16';StartTime='16:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='1st Wednesday UTC16 - Linux Update';Reboot='IfRequired';OS='Linux';DayofWeek='Wednesday';TagName='UpdateWindow';TagValue='WED1UTC16';StartTime='16:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='2nd Wednesday UTC16 - Windows Update';Reboot='IfRequired';OS='Windows';DayofWeek='Wednesday';TagName='UpdateWindow';TagValue='WED2UTC16';StartTime='16:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='2nd Wednesday UTC16 - Linux Update';Reboot='IfRequired';OS='Linux';DayofWeek='Wednesday';TagName='UpdateWindow';TagValue='WED2UTC16';StartTime='16:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='3rd Wednesday UTC16 - Windows Update';Reboot='IfRequired';OS='Windows';DayofWeek='Wednesday';TagName='UpdateWindow';TagValue='WED3UTC16';StartTime='16:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='3rd Wednesday UTC16 - Linux Update';Reboot='IfRequired';OS='Linux';DayofWeek='Wednesday';TagName='UpdateWindow';TagValue='WED3UTC16';StartTime='16:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='1st Thursday UTC0 - Windows Update';Reboot='IfRequired';OS='Windows';DayofWeek='Thursday';TagName='UpdateWindow';TagValue='THU1UTC0';StartTime='00:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='1st Thursday UTC0 - Linux Update';Reboot='IfRequired';OS='Linux';DayofWeek='Thursday';TagName='UpdateWindow';TagValue='THU1UTC0';StartTime='00:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='2nd Thursday UTC0 - Windows Update';Reboot='IfRequired';OS='Windows';DayofWeek='Thursday';TagName='UpdateWindow';TagValue='THU2UTC0';StartTime='00:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='2nd Thursday UTC0 - Linux Update';Reboot='IfRequired';OS='Linux';DayofWeek='Thursday';TagName='UpdateWindow';TagValue='THU2UTC0';StartTime='00:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='3rd Thursday UTC0 - Windows Update';Reboot='IfRequired';OS='Windows';DayofWeek='Thursday';TagName='UpdateWindow';TagValue='THU3UTC0';StartTime='00:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='3rd Thursday UTC0 - Linux Update';Reboot='IfRequired';OS='Linux';DayofWeek='Thursday';TagName='UpdateWindow';TagValue='THU3UTC0';StartTime='00:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='1st Thursday UTC8 - Windows Update';Reboot='IfRequired';OS='Windows';DayofWeek='Thursday';TagName='UpdateWindow';TagValue='THU1UTC8';StartTime='08:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='1st Thursday UTC8 - Linux Update';Reboot='IfRequired';OS='Linux';DayofWeek='Thursday';TagName='UpdateWindow';TagValue='THU1UTC8';StartTime='08:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='2nd Thursday UTC8 - Windows Update';Reboot='IfRequired';OS='Windows';DayofWeek='Thursday';TagName='UpdateWindow';TagValue='THU2UTC8';StartTime='08:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='2nd Thursday UTC8 - Linux Update';Reboot='IfRequired';OS='Linux';DayofWeek='Thursday';TagName='UpdateWindow';TagValue='THU2UTC8';StartTime='08:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='3rd Thursday UTC8 - Windows Update';Reboot='IfRequired';OS='Windows';DayofWeek='Thursday';TagName='UpdateWindow';TagValue='THU3UTC8';StartTime='08:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='3rd Thursday UTC8 - Linux Update';Reboot='IfRequired';OS='Linux';DayofWeek='Thursday';TagName='UpdateWindow';TagValue='THU3UTC8';StartTime='08:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='1st Thursday UTC16 - Windows Update';Reboot='IfRequired';OS='Windows';DayofWeek='Thursday';TagName='UpdateWindow';TagValue='THU1UTC16';StartTime='16:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='1st Thursday UTC16 - Linux Update';Reboot='IfRequired';OS='Linux';DayofWeek='Thursday';TagName='UpdateWindow';TagValue='THU1UTC16';StartTime='16:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='2nd Thursday UTC16 - Windows Update';Reboot='IfRequired';OS='Windows';DayofWeek='Thursday';TagName='UpdateWindow';TagValue='THU2UTC16';StartTime='16:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='2nd Thursday UTC16 - Linux Update';Reboot='IfRequired';OS='Linux';DayofWeek='Thursday';TagName='UpdateWindow';TagValue='THU2UTC16';StartTime='16:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='3rd Thursday UTC16 - Windows Update';Reboot='IfRequired';OS='Windows';DayofWeek='Thursday';TagName='UpdateWindow';TagValue='THU3UTC16';StartTime='16:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='3rd Thursday UTC16 - Linux Update';Reboot='IfRequired';OS='Linux';DayofWeek='Thursday';TagName='UpdateWindow';TagValue='THU3UTC16';StartTime='16:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='1st Friday UTC0 - Windows Update';Reboot='IfRequired';OS='Windows';DayofWeek='Friday';TagName='UpdateWindow';TagValue='FRI1UTC0';StartTime='00:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='1st Friday UTC0 - Linux Update';Reboot='IfRequired';OS='Linux';DayofWeek='Friday';TagName='UpdateWindow';TagValue='FRI1UTC0';StartTime='00:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='2nd Friday UTC0 - Windows Update';Reboot='IfRequired';OS='Windows';DayofWeek='Friday';TagName='UpdateWindow';TagValue='FRI2UTC0';StartTime='00:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='2nd Friday UTC0 - Linux Update';Reboot='IfRequired';OS='Linux';DayofWeek='Friday';TagName='UpdateWindow';TagValue='FRI2UTC0';StartTime='00:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='3rd Friday UTC0 - Windows Update';Reboot='IfRequired';OS='Windows';DayofWeek='Friday';TagName='UpdateWindow';TagValue='FRI3UTC0';StartTime='00:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='3rd Friday UTC0 - Linux Update';Reboot='IfRequired';OS='Linux';DayofWeek='Friday';TagName='UpdateWindow';TagValue='FRI3UTC0';StartTime='00:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='1st Friday UTC8 - Windows Update';Reboot='IfRequired';OS='Windows';DayofWeek='Friday';TagName='UpdateWindow';TagValue='FRI1UTC8';StartTime='08:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='1st Friday UTC8 - Linux Update';Reboot='IfRequired';OS='Linux';DayofWeek='Friday';TagName='UpdateWindow';TagValue='FRI1UTC8';StartTime='08:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='2nd Friday UTC8 - Windows Update';Reboot='IfRequired';OS='Windows';DayofWeek='Friday';TagName='UpdateWindow';TagValue='FRI2UTC8';StartTime='08:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='2nd Friday UTC8 - Linux Update';Reboot='IfRequired';OS='Linux';DayofWeek='Friday';TagName='UpdateWindow';TagValue='FRI2UTC8';StartTime='08:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='3rd Friday UTC8 - Windows Update';Reboot='IfRequired';OS='Windows';DayofWeek='Friday';TagName='UpdateWindow';TagValue='FRI3UTC8';StartTime='08:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='3rd Friday UTC8 - Linux Update';Reboot='IfRequired';OS='Linux';DayofWeek='Friday';TagName='UpdateWindow';TagValue='FRI3UTC8';StartTime='08:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='1st Friday UTC16 - Windows Update';Reboot='IfRequired';OS='Windows';DayofWeek='Friday';TagName='UpdateWindow';TagValue='FRI1UTC16';StartTime='16:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='1st Friday UTC16 - Linux Update';Reboot='IfRequired';OS='Linux';DayofWeek='Friday';TagName='UpdateWindow';TagValue='FRI1UTC16';StartTime='16:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='2nd Friday UTC16 - Windows Update';Reboot='IfRequired';OS='Windows';DayofWeek='Friday';TagName='UpdateWindow';TagValue='FRI2UTC16';StartTime='16:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='2nd Friday UTC16 - Linux Update';Reboot='IfRequired';OS='Linux';DayofWeek='Friday';TagName='UpdateWindow';TagValue='FRI2UTC16';StartTime='16:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='3rd Friday UTC16 - Windows Update';Reboot='IfRequired';OS='Windows';DayofWeek='Friday';TagName='UpdateWindow';TagValue='FRI3UTC16';StartTime='16:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='3rd Friday UTC16 - Linux Update';Reboot='IfRequired';OS='Linux';DayofWeek='Friday';TagName='UpdateWindow';TagValue='FRI3UTC16';StartTime='16:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='1st Saturday UTC0 - Windows Update';Reboot='IfRequired';OS='Windows';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT1UTC0';StartTime='00:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='1st Saturday UTC0 - Linux Update';Reboot='IfRequired';OS='Linux';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT1UTC0';StartTime='00:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='2nd Saturday UTC0 - Windows Update';Reboot='IfRequired';OS='Windows';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT2UTC0';StartTime='00:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='2nd Saturday UTC0 - Linux Update';Reboot='IfRequired';OS='Linux';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT2UTC0';StartTime='00:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='3rd Saturday UTC0 - Windows Update';Reboot='IfRequired';OS='Windows';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT3UTC0';StartTime='00:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='3rd Saturday UTC0 - Linux Update';Reboot='IfRequired';OS='Linux';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT3UTC0';StartTime='00:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='1st Saturday UTC8 - Windows Update';Reboot='IfRequired';OS='Windows';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT1UTC8';StartTime='08:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='1st Saturday UTC8 - Linux Update';Reboot='IfRequired';OS='Linux';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT1UTC8';StartTime='08:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='2nd Saturday UTC8 - Windows Update';Reboot='IfRequired';OS='Windows';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT2UTC8';StartTime='08:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='2nd Saturday UTC8 - Linux Update';Reboot='IfRequired';OS='Linux';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT2UTC8';StartTime='08:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='3rd Saturday UTC8 - Windows Update';Reboot='IfRequired';OS='Windows';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT3UTC8';StartTime='08:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='3rd Saturday UTC8 - Linux Update';Reboot='IfRequired';OS='Linux';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT3UTC8';StartTime='08:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='1st Saturday UTC16 - Windows Update';Reboot='IfRequired';OS='Windows';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT1UTC16';StartTime='16:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='1st Saturday UTC16 - Linux Update';Reboot='IfRequired';OS='Linux';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT1UTC16';StartTime='16:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='2nd Saturday UTC16 - Windows Update';Reboot='IfRequired';OS='Windows';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT2UTC16';StartTime='16:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='2nd Saturday UTC16 - Linux Update';Reboot='IfRequired';OS='Linux';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT2UTC16';StartTime='16:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='3rd Saturday UTC16 - Windows Update';Reboot='IfRequired';OS='Windows';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT3UTC16';StartTime='16:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='3rd Saturday UTC16 - Linux Update';Reboot='IfRequired';OS='Linux';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT3UTC16';StartTime='16:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='1st Sunday UTC0 - Windows Update';Reboot='IfRequired';OS='Windows';DayofWeek='Sunday';TagName='UpdateWindow';TagValue='SUN1UTC0';StartTime='00:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='1st Sunday UTC0 - Linux Update';Reboot='IfRequired';OS='Linux';DayofWeek='Sunday';TagName='UpdateWindow';TagValue='SUN1UTC0';StartTime='00:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='2nd Sunday UTC0 - Windows Update';Reboot='IfRequired';OS='Windows';DayofWeek='Sunday';TagName='UpdateWindow';TagValue='SUN2UTC0';StartTime='00:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='2nd Sunday UTC0 - Linux Update';Reboot='IfRequired';OS='Linux';DayofWeek='Sunday';TagName='UpdateWindow';TagValue='SUN2UTC0';StartTime='00:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='3rd Sunday UTC0 - Windows Update';Reboot='IfRequired';OS='Windows';DayofWeek='Sunday';TagName='UpdateWindow';TagValue='SUN3UTC0';StartTime='00:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='3rd Sunday UTC0 - Linux Update';Reboot='IfRequired';OS='Linux';DayofWeek='Sunday';TagName='UpdateWindow';TagValue='SUN3UTC0';StartTime='00:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='1st Sunday UTC8 - Windows Update';Reboot='IfRequired';OS='Windows';DayofWeek='Sunday';TagName='UpdateWindow';TagValue='SUN1UTC8';StartTime='08:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='1st Sunday UTC8 - Linux Update';Reboot='IfRequired';OS='Linux';DayofWeek='Sunday';TagName='UpdateWindow';TagValue='SUN1UTC8';StartTime='08:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='2nd Sunday UTC8 - Windows Update';Reboot='IfRequired';OS='Windows';DayofWeek='Sunday';TagName='UpdateWindow';TagValue='SUN2UTC8';StartTime='08:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='2nd Sunday UTC8 - Linux Update';Reboot='IfRequired';OS='Linux';DayofWeek='Sunday';TagName='UpdateWindow';TagValue='SUN2UTC8';StartTime='08:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='3rd Sunday UTC8 - Windows Update';Reboot='IfRequired';OS='Windows';DayofWeek='Sunday';TagName='UpdateWindow';TagValue='SUN3UTC8';StartTime='08:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='3rd Sunday UTC8 - Linux Update';Reboot='IfRequired';OS='Linux';DayofWeek='Sunday';TagName='UpdateWindow';TagValue='SUN3UTC8';StartTime='08:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='1st Sunday UTC16 - Windows Update';Reboot='IfRequired';OS='Windows';DayofWeek='Sunday';TagName='UpdateWindow';TagValue='SUN1UTC16';StartTime='16:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='1st Sunday UTC16 - Linux Update';Reboot='IfRequired';OS='Linux';DayofWeek='Sunday';TagName='UpdateWindow';TagValue='SUN1UTC16';StartTime='16:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='2nd Sunday UTC16 - Windows Update';Reboot='IfRequired';OS='Windows';DayofWeek='Sunday';TagName='UpdateWindow';TagValue='SUN2UTC16';StartTime='16:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='2nd Sunday UTC16 - Linux Update';Reboot='IfRequired';OS='Linux';DayofWeek='Sunday';TagName='UpdateWindow';TagValue='SUN2UTC16';StartTime='16:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='3rd Sunday UTC16 - Windows Update';Reboot='IfRequired';OS='Windows';DayofWeek='Sunday';TagName='UpdateWindow';TagValue='SUN3UTC16';StartTime='16:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='3rd Sunday UTC16 - Linux Update';Reboot='IfRequired';OS='Linux';DayofWeek='Sunday';TagName='UpdateWindow';TagValue='SUN3UTC16';StartTime='16:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='1st Saturday UTC0 - Windows Update - No Reboot';Reboot='Never';OS='Windows';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT1UTC0-NR';StartTime='00:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='1st Saturday UTC0 - Linux Update - No Reboot';Reboot='Never';OS='Linux';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT1UTC0-NR';StartTime='00:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='2nd Saturday UTC0 - Windows Update - No Reboot';Reboot='Never';OS='Windows';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT2UTC0-NR';StartTime='00:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='2nd Saturday UTC0 - Linux Update - No Reboot';Reboot='Never';OS='Linux';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT2UTC0-NR';StartTime='00:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='3rd Saturday UTC0 - Windows Update - No Reboot';Reboot='Never';OS='Windows';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT3UTC0-NR';StartTime='00:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='3rd Saturday UTC0 - Linux Update - No Reboot';Reboot='Never';OS='Linux';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT3UTC0-NR';StartTime='00:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='1st Saturday UTC8 - Windows Update - No Reboot';Reboot='Never';OS='Windows';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT1UTC8-NR';StartTime='08:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='1st Saturday UTC8 - Linux Update - No Reboot';Reboot='Never';OS='Linux';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT1UTC8-NR';StartTime='08:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='2nd Saturday UTC8 - Windows Update - No Reboot';Reboot='Never';OS='Windows';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT2UTC8-NR';StartTime='08:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='2nd Saturday UTC8 - Linux Update - No Reboot';Reboot='Never';OS='Linux';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT2UTC8-NR';StartTime='08:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='3rd Saturday UTC8 - Windows Update - No Reboot';Reboot='Never';OS='Windows';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT3UTC8-NR';StartTime='08:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='3rd Saturday UTC8 - Linux Update - No Reboot';Reboot='Never';OS='Linux';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT3UTC8-NR';StartTime='08:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='1st Saturday UTC16 - Windows Update - No Reboot';Reboot='Never';OS='Windows';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT1UTC16-NR';StartTime='16:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='1st Saturday UTC16 - Linux Update - No Reboot';Reboot='Never';OS='Linux';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT1UTC16-NR';StartTime='16:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='2nd Saturday UTC16 - Windows Update - No Reboot';Reboot='Never';OS='Windows';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT2UTC16-NR';StartTime='16:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='2nd Saturday UTC16 - Linux Update - No Reboot';Reboot='Never';OS='Linux';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT2UTC16-NR';StartTime='16:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='3rd Saturday UTC16 - Windows Update - No Reboot';Reboot='Never';OS='Windows';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT3UTC16-NR';StartTime='16:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='3rd Saturday UTC16 - Linux Update - No Reboot';Reboot='Never';OS='Linux';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT3UTC16-NR';StartTime='16:00';DaysofWeekOccurrence='Third'}
)

#  Schedule Deployments Start Here

$scope = "/subscriptions/$((Get-AzContext).subscription.id)"
$QueryScope = @($scope)

$WindowsSchedules = $ScheduleConfig | Where-Object {$_.OS -eq "Windows"}
$LinuxSchedules = $ScheduleConfig | Where-Object {$_.OS -eq "Linux"}

foreach($WindowsSchedule in $WindowsSchedules){

$tag = @{$WindowsSchedule.TagName=$WindowsSchedule.TagValue}
$azq = New-AzAutomationUpdateManagementAzureQuery -ResourceGroupName $ResourceGroupName `
                                       -AutomationAccountName $AutomationAccount `
                                       -Scope $QueryScope `
                                       -Tag $tag

$AzureQueries = @($azq)

$date=((get-date).AddDays(1)).ToString("yyyy-MM-dd")
$time=$WindowsSchedule.Starttime
$datetime= $date + "t" + $time

$startTime = [DateTimeOffset]"$datetime"
$duration = New-TimeSpan -Hours 2




$schedule = New-AzAutomationSchedule -ResourceGroupName $ResourceGroupName `
                                                  -AutomationAccountName $AutomationAccount `
                                                  -Name $WindowsSchedule.ScheduleName `
                                                  -StartTime $StartTime `
                                                  -DayofWeek $WindowsSchedule.DayofWeek `
                                                  -DayofWeekOccurrence $WindowsSchedule.DaysofWeekOccurrence `
                                                  -MonthInterval 1 `
                                                  -ForUpdateConfiguration

New-AzAutomationSoftwareUpdateConfiguration -ResourceGroupName $ResourceGroupName `
                                                 -AutomationAccountName $AutomationAccount `
                                                 -Schedule $schedule `
                                                 -Windows `
                                                 -Azurequery $AzureQueries `
                                                 -IncludedUpdateClassification Critical,Security,Updates,UpdateRollup,Definition `
                                                 -Duration $duration `
                                                 -RebootSetting $WindowsSchedule.Reboot
}

foreach ($LinuxSchedule in $LinuxSchedules){

$tag = @{$LinuxSchedule.TagName=$LinuxSchedule.TagValue}
$azq = New-AzAutomationUpdateManagementAzureQuery -ResourceGroupName $ResourceGroupName `
                                       -AutomationAccountName $AutomationAccount `
                                       -Scope $QueryScope `
                                       -Tag $tag

$AzureQueries = @($azq)

$date=((get-date).AddDays(1)).ToString("yyyy-MM-dd")
$time=$LinuxSchedule.Starttime
$datetime= $date + "t" + $time

$startTime = [DateTimeOffset]"$datetime"
$duration = New-TimeSpan -Hours 2
$schedule = New-AzAutomationSchedule -ResourceGroupName $ResourceGroupName `
                                                  -AutomationAccountName $AutomationAccount `
                                                  -Name $LinuxSchedule.ScheduleName `
                                                  -StartTime $StartTime `
                                                  -DayofWeek $LinuxSchedule.DayofWeek `
                                                  -DayofWeekOccurrence $LinuxSchedule.DaysofWeekOccurrence `
                                                  -MonthInterval 1 `
                                                  -ForUpdateConfiguration

New-AzAutomationSoftwareUpdateConfiguration -ResourceGroupName $ResourceGroupName `
                                                 -AutomationAccountName $AutomationAccount `
                                                 -Schedule $schedule `
                                                 -Linux `
                                                 -Azurequery $AzureQueries `
                                                 -IncludedPackageClassification Critical,Security `
                                                 -Duration $duration `
                                                 -RebootSetting $LinuxSchedule.Reboot
}

Write-host "That is all folks!"