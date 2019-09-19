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
  C.  The thrid phase will build an array based off of an CSV file provided. This array has 8 customizable settings that can be added to or removed based off of need.  However, currently this is how some of the variables are created in order to make the PowerShell script more dynamic. The headers are ScheduleName, Reboot, OS, DayofWeek, TagName,TagValue, StartTime, and DaysofWeekOccurence.  Once the array is built it will then create schedules based off of Window or Linux OS's.  Pulling the paramater values from the previously created array.
  
Once the script is done, you should have newly created deloyment schedules that will be populated with VM's dynamicly based off of the tag value you have given the tag. In my case we use UpdateWindow for the tag.   Examples below is a listing of tag values base off of Deployment Schedules we are providing each subscription.  

Tag:  MON1UTCO
Windows Deployment Schedule Name:  1st Monday UTCO - Windows Update
Linux Deployiment Schedule Name:   1st Monday UTCO - Linux Update

Tag:  MON2UTC16
Windows Deplyment Schedule Name:   2nd Monday UTC16 - Windows Update
Linux Deployment Schedule Name:    2nd Monday UTC16 - Linux Update

Currently in the csv file provided we have 127  deployment schedules.  1 being NOUPDATES, 63 Windows Schedules and 63 Linux schedules. This will give the owner of the VM an oppuntitiy to pick one of 3 times slots daily that ranges for the first 3 weeks. If the owner of the VM doesn't change the Tag from Default then the machine doesn't get patched.  If the owner of the VM changes the value to NOUPDATES that machine won't get patched either.  In this case those machines will need some kind of exception for not being included in the automated update management solution.  
  
  ScheduleName - 
  
  
