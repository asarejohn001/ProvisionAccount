# Note
This is a subcode from my [MicrosoftEntra_AzureAD](https://github.com/asarejohn001/MicrosoftEntra_AzureAD) respiratory.

## Script to create user accounts
Using [PowerShell 7](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell?view=powershell-7.4) and the [Microsoft Graph SDK](https://learn.microsoft.com/en-us/graph/sdks/sdks-overview), the [UserAccountProvision script](UserAccountProvision.ps1) will create a user account in Microsoft Entra.
It will
1. 1. Install [Microsoft Graph](https://learn.microsoft.com/en-us/powershell/microsoftgraph/installation?view=graph-powershell-1.0). If you already have it installed, you can skip or comment it out.
2. Import the Microsft Graph module.
3. Define the permission scope you need to create the user accounts.
4. [Connect](https://learn.microsoft.com/en-us/powershell/microsoftgraph/get-started?view=graph-powershell-1.0) to Microsoft Grapgh.
5. Saved the CSV file containing the new hire info into a variable.
6. Declare a path to log any errors and success. This will help the investigation task.
> [!IMPORTANT]  
> Make sure you change the path to where you saved your CSV file and created your Txt file for the logs.
7. Create a variable to import the CSV file.
8. Another variable to track errors so we can create a log file later.
9. Loops through the [csv file](New%20Hires.csv) and create each user account using the information from the file.
10. Disconnects from Microsoft Graph
