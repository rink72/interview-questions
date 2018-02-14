# Technical Questions

Scripts and commands for the interview questions

## Getting Started

The files are broken down by language used. Bash, Python and Powershell.

### Bash

There are three files in this folder. One for each of the tasks.
Each command will have some very basic help if input parameters are incorrect.

checkPorts.sh is for task one.

```
./checkPorts.sh -h localhost -p 80
./checkPorts.sh -h localhost -p 80 -p 30-100
```

replaceString.sh is for task two.

```
./replaceString.sh -f test.txt -e [1..9] -s car
```

insertLineString.sh is for task three.

```
./insertLineString.sh -f test.txt -n 3 -s line3
```

### Python

There are there files in this folder. Two for task one and one for task two.
These were all written in Python 3.6. I have the Anaconda install on my PC and any
modules I used in these scripts were available but I cannot be sure they are standard
for all installs.

socketServer.py is a standalone socket server.
socketTest.py are unit tests for the server when it is up and running

To start the socket server

```
python socketServer.py

```

And to then run unit tests against it

```
python socketTest.py
```


wordCount.py is for task two and take a file parameter. There is some basic help if you input incorrect parameters.

```
python wordCount.py --file c:\temp\test.txt
```



## PowerShell

There is a single PowerShell file that contains all scripts/functions for the tasks.
Each function has reasonable help that can be accessed using Get-Help COMMAND

To use the commands, first dot-source the file.

```
. ./powershell-cmdlets.ps1
```

For task one, you can use the following syntax to run it.

```
Send-Command -ComputerName AnotherComputer -User 'domain.local\joe' -Password 'GoodPassword1234!' -Command "tasklist"
Send-Command -ComputerName AnotherComputer -User 'domain.local\joe' -Password 'GoodPassword1234!' -Command "Get-ChildItem C:"
```

For task two, you can use the following syntax to run it.

This will save event logs from the specified event log to a file.
Files are saved in CSV format.
The default log used is the Application log but you can use Application, System or Security.

```
Save-EventLog -File 'C:\temp\events.csv'
Save-EventLog -File 'C:\temp\events.csv' -LogType System
```


For task three, you can use

```
    Get-InstalledApplications
    Get-InstalledApplications | Out-GridView
    Get-InstalledApplications | Format-Table -AutoSize -Property Name, Caption, Version, Vendor
```

