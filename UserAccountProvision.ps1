<#
Name: John Asare
Date: 2024-07-20

User account provision. Read more about this script at https://github.com/asarejohn001/UserAccountProvisioning
#>

# Install the Microsoft.Graph if not already
#Install-Module Microsoft.Graph -Scope CurrentUser

# Import the Microsoft Graph PowerShell module
Import-Module Microsoft.Graph

# Define the scopes (permissions) needed for the connection
$scopes = @(
    "User.ReadWrite.All",
    "Directory.ReadWrite.All"
)

# Connect to Microsoft Graph
Connect-MgGraph -Scopes $scopes

# Path to the CSV file
$csvPath = "./New Hires.csv"

# Path to the error log file
$errorLogPath = "./Log.txt"

# Function to log errors with a timestamp
function Update-LogFile {
    param (
        [string]$message,
        [string]$logFilePath
    )
    $dateTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "$dateTime - $message"
    Add-Content -Path $logFilePath -Value $logMessage
}

# Import the CSV file
$users = Import-Csv -Path $csvPath

# Initialize error count
$errorCount = 0

# Loop through each user in the CSV
foreach ($user in $users) {
    try {
        # Create a password profile for the user
        $passwordProfile = @{
            forceChangePasswordNextSignIn = $true
            password = "InitialPassword123!" # Generate a more secure password as needed
        }

        # Generate user principal name (UPN) and mail nickname
        $upn = "$($user.FirstName).$($user.LastName)@yourdomain.com"
        $mailNickname = "$($user.FirstName)$($user.LastName)"

        # Create the user
        $userDetails = @{
            accountEnabled = $true
            displayName = "$($user.FirstName) $($user.LastName)"
            mailNickname = $mailNickname
            userPrincipalName = $upn
            jobTitle = $user.JobTitle
            companyName = $user.CompanyName
            department = $user.Department
            employeeId = $user.EmployeeID
            employeeType = $user.EmployeeType
            officeLocation = $user.OfficeLocation
            usageLocation = "US"
            passwordProfile = $passwordProfile
        }

        $newUser = New-MgUser -BodyParameter $userDetails
        $successMessage = "Successfully created account for $($user.FirstName) $($user.LastName): $($_.Exception.Message)"
        Update-LogFile -message $successMessage -logFilePath $errorLogPath
        Write-Host "Account created, check the log file"

        # Wait for the user to be fully created before updating
        Start-Sleep -Seconds 30

        # Update the user's employee hire date
        $hireDateDetails = @{
            employeeHireDate = $user.EmployeeHireDate
        }

        Update-MgUser -UserId $newUser.Id -BodyParameter $hireDateDetails

    } catch {
        # Log the error using the Log-Error function
        $errorMessage = "Error creating/updating user $($user.FirstName) $($user.LastName): $($_.Exception.Message)"
        Update-LogFile -message $errorMessage -logFilePath $errorLogPath
        $errorCount++
        Write-Host "Failed to create account, check log file"
    }
}

# Output final status
if ($errorCount -eq 0) {
    Write-Host "All users have been processed successfully."
} else {
    Write-Host "There were errors during user processing. Please check the log file at $errorLogPath for details."
}


# Disconnect from Microsoft Graph
Disconnect-Graph