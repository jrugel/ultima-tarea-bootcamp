# Powershell scripting for Azure management

Basic Azure resource explorer based in Powershell scripting

### How to use?
This PowerShell script allows you check and set some properties of your Azure resources that are grouped in a Resource Group

### Requirememts
- Windows enviroment (tested in a clean W10 installation)
- Powershell or PSCore installed (installed by default in W8.1 and newer)
- Az Powershell installed (check [THIS](https://github.com/jnzambranob/Bootcamp-tools-installer.git))

### Instructions
1. Clone this repo or download the script file: [Script Link](https://github.com/jnzambranob/Powershell-scripting-for-azure-management/raw/main/rgviewer.ps1)(Right-click in the link and choose "Save link as")
2. Allow the PowerShell script execution running this command in a PowerShell terminal:
```powershell
Set-ExecutionPolicy -ExecutionPolicy ByPass -Scope CurrentUser
```
  >This is mandatory and has to be done because the script execution is disabled by default for security reasons.

3. Run the script directly from PowerShell with the command:
```powershell
.\rgviewer.ps1
```
>Remember to open the script from the folder where the file is located, Also, the script could be executed from the file explorer, just right-clicking the script file and clicking in the option "Run with PowerShell".

4. Follow the instructions of the script.

### Known Issues
- Sometimes, the Azure Web Authentication will not work the first time if you have activated the 2-factor auth (In the second auth, the script will work normally)
- The tag function could not work sometimes tagging service plans (Microsoft.Web/serverFarms), this problem will occur also in the web version of the Azure Resource Manager (Azure Portal)
