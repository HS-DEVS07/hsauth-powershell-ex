class UserData {
    [string]$Username
    [string]$ExpiresAt
    [string]$IP
    [string]$HWID
}

class HSAuthApp {
    [string]$Name
    [string]$OwnerId
    [string]$Secret
    [string]$Version
    [string]$ApiUrl
    [string]$SessionId
    [bool]$Initialized
    [UserData]$UserData
    [string]$Message

    HSAuthApp([string]$name, [string]$ownerId, [string]$secret, [string]$version = "1.0") {
        $this.Name = $name
        $this.OwnerId = $ownerId
        $this.Secret = $secret
        $this.Version = $version
        $this.ApiUrl = "https://auth.hsdevs.pro/api/1.3/"
        $this.UserData = [UserData]::new()
    }

    [bool] Init() {
        $body = @{
            type = "init"
            name = $this.Name
            ownerid = $this.OwnerId
            ver = $this.Version
        }
        try {
            $resp = Invoke-RestMethod -Uri $this.ApiUrl -Method Post -Body $body
            if ($resp.success) {
                $this.SessionId = $resp.sessionid
                $this.Initialized = $true
                return $true
            }
            $this.Message = $resp.message
        } catch {
            $this.Message = $_.Exception.Message
        }
        return $false
    }

    [bool] License([string]$key) {
        if (-not $this.Initialized) {
            $ok = $this.Init()
            if (-not $ok) { return $false }
        }
        $body = @{
            type = "license"
            key = $key
            sessionid = $this.SessionId
            name = $this.Name
            ownerid = $this.OwnerId
        }
        try {
            $resp = Invoke-RestMethod -Uri $this.ApiUrl -Method Post -Body $body
            if ($resp.success) {
                $this.UserData.Username = $resp.info.username
                $this.UserData.ExpiresAt = $resp.info.expiry
                return $true
            }
            $this.Message = $resp.message
        } catch {
            $this.Message = $_.Exception.Message
        }
        return $false
    }
}
