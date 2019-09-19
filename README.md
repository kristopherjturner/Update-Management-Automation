# Update-Management-Automation
Azure Update Management Automation

The following is an overview how how to deploy an automated solution for Azure's Update Management. This solution will do the following:
1.  Manual deployment of Azure Policy for catching Azure VM's without a specific Tag and Tag Value.
2.  A Powershell script that will:
  A.  Discover all VM's within a Subscription.  If the VM doesn't already have a specific Tag then it will create that Tag and create a default value of "Default."  This tag value can be changed later in order to dynamicly assign the VM into a Deployment scheduled created within the process.
  B.  The next phase in the PowerShell script will run three configurations on each Windows VM discovered in the Subscription.  These three configuration changes are:
    1.  Configure VM's to pre-download updates
    2.  Disable automatic installation of updates on VM's.
    3.  Enable updates for other Microsoft products.
  C.  The thrid phase will build an array based off of an CSV file provided. This array has 8 customizable settings that can be added to or removed based off of need.  However, currently this is how some of the variables are created in order to make the PowerShell script more dynamic. The headers are ScheduleName, Reboot, OS, DayofWeek, TagName,TagValue, StartTime, and DaysofWeekOccurence.  
  
  
