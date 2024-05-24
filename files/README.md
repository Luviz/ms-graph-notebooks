# OneDrive file suite

Here is a collection of tools that allows for a different way of managing a users oneDrive.
Some of these tool may allow interactions with SharePoint libraries.

These script are written for Powershell 5.1, and use only built in modules that comes with Powershell on windows.
The Script are written in a way that the can just be copy pasted in any windows environment and executed. 

## Get-OneDriveRapport

This tool can generate a CSV rapport of all files for a users files.

[Permissions](./service-principle-read.md)

### How to Run

Simply update variables at the top of the file and set the user id.
Then you can run the script and pipe the output to a ConvertTo-Csv, and you should be able to import the CSV in to an excel spreadsheet for a close look at your files.

```powershell
.\files\get-onedriveReport.ps1 | ConvertTo-Csv -NoTypeInformation > .\onedrv-files-test-one.csv
```

## Remove-oneDriveFiles

Here is a simple tool that reads a csv files that contains `userId` and `fileId` and removes them.

you will need write permissions to use this

[Permissions](./service-principle-read-write.md)

### How to Run

Go through the rapport generate by the previous script and remove any files that should not be deleted. 
Then you can export the remaining files to a csv, and target them.  

```powershell
.\files\remove-oneDriveFiles.ps1 -CsvPath .\onedrv-files-test-one.csv
```
There is a confirmations step, so you wont be deleting you files by mistake.

Note that this is a soft delete so you files will be in the Recycling bin to recover them, for permanent removal read [Remove-oneDriveFilePermanent](#remove-onedrivefilepermanent). 

## Remove-oneDriveFilePermanent

Same as `Remove-oneDriveFiles` but it by passes the Recycling bin.