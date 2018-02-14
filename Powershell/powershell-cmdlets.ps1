<#
    .Synopsis
    This commandlet will run a given command on the specified server.
    .DESCRIPTION
    This commandlet will run a given command on the specified server. You may use Powershell commands or standard console commands. Arguments are allowed.
    .EXAMPLE
    Send-Command -ComputerName localhost -User 'joe' -Password 'GoodPassword1234!' -Command 'Get-ChildItem C:\'
    .EXAMPLE
    Send-Command -ComputerName AnotherComputer -User 'domain.local\joe' -Password 'GoodPassword1234!' -Command "tasklist"
#>
function Send-Command
{
    [CmdletBinding()]
    [Alias()]
    Param
    (
        # ComputerName - The computer to connect to. FQDN.
        [String]
        [Parameter(Mandatory=$true,
                   Position=0)]
        $ComputerName,

        # User - the username to connect with. Include domain name if required.
        [String]
        [Parameter(Mandatory=$true,
                   Position=1)]
        $User,
        
        # Password - This is the users password in plaintext.
        [String]
        [Parameter(Mandatory=$true,
                   Position=2)]
        $Password,
        
        # Command - The command to run on the remote machine.
        [String]
        [Parameter(Mandatory=$true,
                   Position=3)]
        $Command
        
    )

    Try
    {
      # Take the username and plain text password and create a PSCredential object to use when passing the command to
      # another computer.
      $secureStringPassword = ConvertTo-SecureString $Password -AsPlainText -Force
      $credentials = New-Object System.Management.Automation.PSCredential ($User, $secureStringPassword)
      
      # Break the command in to the actual command and a list of arguments. This is because of the way Invoke-Command executes a variable in the scriptblock
      $cmdParts = $command.Split(' ')
      $cmd = $cmdParts[0]
      if($cmdParts.Count -gt 1) { $cmdArgs = $cmdParts[1..($cmdParts.Count - 1)] }
      else { $cmdArgs = $null }
      
      # Run the command on the remote machine and store the results
      $commandResult = Invoke-Command -ComputerName $ComputerName -Credential $credentials -ScriptBlock { & $Using:cmd $Using:cmdArgs } -ErrorVariable errorResult -ErrorAction SilentlyContinue
      
      
      # Invoke-Command handles errors thrown at the remote host as output and will not be caught by Try..Catch locally.
      # Instead we will store any error events in the $errorResult variable report them locally
      if($errorResult) 
      { 
        $commandResult = $null
        Write-Host "Error executing command on remote host. Error Details: $($Error[0])"
      
      }
      
    }
    Catch [System.Management.Automation.RuntimeException]
    {
      $commandResult = $null
      Write-Host "Error connecting to remote host. Error Details: $($Error[0])"
    }
    Catch 
    {
      $commandResult = $null
      Write-Host "Unknown Error: $($Error[0])"
    }
    

    
    # Return the function result. This will be the result of the executed command or $false if an error was encountered.
    Return $commandResult



}



<#
    .Synopsis
    Will save event logs from the specified event log to a file.
    .DESCRIPTION
    Will save event logs from the specified event log to a file.
    Files are saved in CSV format.
    The default log used is the Application log.
    .EXAMPLE
    Save-EventLog -File 'C:\temp\events.csv'
    .EXAMPLE
    Save-EventLog -File 'C:\temp\events.csv' -LogType System
#>
function Save-EventLog
{
    [CmdletBinding()]
    [Alias()]
    Param
    (
        # File - location to save data to
        [String]
        [ValidateScript({Test-Path $_ -IsValid})]
        [Parameter(Mandatory=$true,
                   Position=0)]
        $File,

        # LogType - optional parameter to specify the log to save
        [String]
        [ValidateSet("Application","System","Security")] 
        $LogType = "Application"
    )

    Try
    {
      # Get Log events in to a variable
      Write-Verbose "Retrieving logs from $LogType event log."
      $events = Get-EventLog -LogName $LogType
    }
    Catch
    {
      Write-Output "Error retrieving event logs. Error details: $($Error[0])"
      return $null
    }
    
    
    Try
    {
      # Try and save the result to a csv file
      Write-Verbose "Attempting to save data to $File"
      $events | Export-Csv -Path $File -NoTypeInformation
    }
    Catch
    {
      Write-Output "Error saving event log data to $File. Error details: $($Error[0])"
      return $null  
    }
  
  
}


<#
    .Synopsis
    Will return a list of installed applications
    .DESCRIPTION
    Will return a list of installed applications
    .EXAMPLE
    Get-InstalledApplications
    .EXAMPLE
    Get-InstalledApplications | Out-GridView
    .EXAMPLE
    Get-InstalledApplications | Format-Table -AutoSize -Property Name, Caption, Version, Vendor
#>
function Get-InstalledApplications
{
  # There are three methods (and probably more) to get this information.
  #
  # The first is a simple Get-WmiObject -Class Win32_Product
  # The disadvatage of this is that it can be slow on some systems.
  #
  # The second is Get-WmiObject -Class Win32Reg_AddRemovePrograms.
  # However, this required the SCCM agent be installed on the machine.
  #
  # The third is to directly query the registry at 
  # HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall.
  #
  # For the sake of simplicity, I will be using the first method.
  # I will also just return an object of the results as this is preferred over formatting
  # the data and flattening it to text. Examples of formatting of this function can
  # be found in the examples.
  
  
  
  $installedApplications = Get-WmiObject -Class Win32_Product
  
  return $installedApplications
}