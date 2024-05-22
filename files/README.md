# OneDrive file suite

Here is a collection of tools that allows for a different way of managing a users oneDrive.
Some of these tool may allow interactions with SharePoint libraries.

## Get-OneDriveRapport

This tool can generate a CSV rapport of all files for a users files.

[Permissions](./service-principle-read.md)

### How to Run

Simply update variables at the top of the file and set the user id.
Then you can run the script and pipe the output to a ConvertTo-Csv, and you should be able to import the CSV in to an excel spreadsheet for a close look at your files.

```powershell
.\files\get-onedriveReport.ps1 | ConvertTo-Csv -NoTypeInformation > .\onedrv-files-test-one.csv
```

### TODO

- [ ] Move the cmdlets to a GraphOneDriveSuite Module

