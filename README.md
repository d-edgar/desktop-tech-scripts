<!-- https://github.com/ikatyang/emoji-cheat-sheet/blob/master/README.md -->

# Overview
Collection of various scripts for macOS and Windows, I will include a To-Do list of items I want to write down and get out of my head/google.

<details>
<summary>To-Do List</summary>

| Done | Description|
|------|------------|
|     :white_check_mark:| Windows useful script and CMD dump|
|  Soon:tm:   | macOS script and command dump|
|  Soon:tm:   |Linux script and command dump|
|  Soon:tm:   |PDQ command and jobs|
|  Soon:tm:   |FileWave command and jobs|
|  Soon:tm:   |jamf config profiles and scripts|

 </details>
 
 <details>
 <summary>Software to DOWNLOAD NOW</summary>
 
 - https://github.com/ProfileCreator/ProfileCreator.git
 - https://github.com/notepad-plus-plus/notepad-plus-plus
 
 </details>


# Windows OS Commands/Scripts/Anything
Collection of windows scripting used in desktop tech world. Some simple commands and things used regularly are located below.

#### Random commands I find myself using more often then I realize when troubleshooting
```
whoami
net user <username>
systeminfo
net config Workstation 
net users
```
Turn off Hibernate in Windows
```
powercfg -h off
```
List of processes and services running (can't open task manager, having issues with displays, etc...)
```
wmic service list full > services.txt
wmic process > processes.txt
```
## Standard commands with references to the "man" pages
### Simple networking commands to get you a good idea of what is going on, and "flush" some issues out[^1].

```
ipconfig /all
ipconfig /flushdns
ipconfig /renew
```

### SFC[^2] Scans and file repair

Verify and Repair
```
/scannow
```
Verify only, but DOESN'T repair (just in case high profile computer, issues with a dying drive, etc...)
```
/scannow verifyonly
```

### Shutdown[^3] computer, and other commands for shutdown
```
shutdown /s
```
Just shut the computer up and restart (you've had enough, I have to)
```
shutdown /r /f
```
### CHKDSK[^4] Commands and comments
You just want to check a disk and repair
```
chkdsk d: /f
```
The following table lists the exit codes that chkdsk reports after it has finished.

|Exit code|	Description|
|---------| -----------|
|0	|No errors were found.
|1	|Errors were found and fixed.
|2	|Performed disk cleanup (such as garbage collection) or did not perform cleanup because /f was not specified.
|3	|Could not check the disk, errors could not be fixed, or errors were not fixed because /f was not specified.

### Copy[^5] VS. MV[^6]
One will copy the files and move it to a location of your choosing, the other will only MOVE the files to another location leaving the folder you orginally started from empty. Choose wisely.

Move all files and stop prompting about overriding
```
move -y C:\Users\INSERTNAME C:\Users\Old\INSERTNAME
```

Copy all files to another location
```
copy -y C:\Users\INSERTNAME C:\Users\Old\INSERTNAME
```
Alternatively you can recursively copy via xcopy as well in CMD
```
xcopy some_source_dir new_destination_dir\ /E/H
```
You can see more options by running:
```
xcopy /?
```
### Remove a directory with rmdir[^7]
To remove a directory and all of its contents, you can use rmdir.
```
rmdir some_directory /Q/S
```

#### The important options are...
|Flag| Description|
|------|------|
|`/Q `|Do not prompt with "Are you sure?"|
|`/S `|Delete all contents and sub-directories|

```
Run rmdir /? for more help.
```

# macOS Commands/Scripts
Collection of various things I have used over the years for the macOS specific operating system.

### Mobile account delete[^8]
Deletes mobile accounts after a local account has been migrated.
*

```SH
#!/bin/bash

# This script works well for removing local accounts that are older than 1 day. 
# Obviously the 1 day timeframe can be modified (-mtime +1).  

# Runs using Launch Daemon - /Library/LaunchDaemons/edu.org.deleteaccounts.plist
# version .7

DATE=`date "+%Y-%m-%d %H:%M:%S"`

# Don't delete local accounts
keep1="/Users/administrator"

currentuser=`ls -l /dev/console | cut -d " " -f 4`
keep2=/Users/$currentuser

USERLIST=`/usr/bin/find /Users -type d -maxdepth 1 -mindepth 1 -mtime +1`

for a in $USERLIST ; do
    [[ "$a" == "$keep1" ]] && continue  #skip admin
    [[ "$a" == "$keep2" ]] && continue  #skip current user
    

# Log results
echo ${DATE} - "Deleting account and home directory for" $a >> "/Library/Logs/deleted user accounts.log"
    
# Delete the account
/usr/bin/dscl . -delete $a  
    
# Delete the home directory
# dscl . list /Users UniqueID | awk '$2 > 500 { print $1 }' | grep -v Shared | grep -v admin | grep -v admin1 | grep -v .localized
/bin/rm -rf $a

done 
exit 0
```


[^1]: https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/ipconfig
[^2]: https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/sfc
[^3]: https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/shutdown
[^4]: https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/chkdsk?tabs=event-viewer
[^5]: https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/copy
[^6]: https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/move
[^7]: https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/rmdir
[^8]: https://github.com/oondi/mac_mobile_delete/blob/e21962745f0a087153a28046cf930e3493c04759/local_account_delete.sh
