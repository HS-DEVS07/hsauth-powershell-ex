# HS DEVS AUTH — PowerShell SDK

Official PowerShell automation module for HS DEVS AUTH.

## Usage

```powershell
Import-Module .\HSAuth.psm1

$auth = [HSAuthApp]::new("AppName", "OwnerID", "Secret", "1.0")
if ($auth.License("YOUR_KEY")) {
    Write-Host "Success! Valid until $($auth.UserData.ExpiresAt)" -ForegroundColor Green
}
```
