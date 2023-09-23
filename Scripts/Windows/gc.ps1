param(
[Parameter(Mandatory=$true)] [string]$repoUrl,
[Parameter(Mandatory=$false)] [string]$workspaceFolder = ""
)

if ($workspaceFolder.Length -eq 0 -or $workspaceFolder -eq $null) {
    $workspaceFolder = Join-Path -path $HOME -ChildPath "workspace"
    Write-Host "Using default Workspace folder: $($workspaceFolder)" -ForegroundColor Yellow
}

$repoArr = $repoUrl -split('/')
$repoHostName = $repoArr[2]

switch ($repoHostName) {
    {$_ -match "@dev.azure.com"} {
        # Write-Host "Azure DevOps Repo"
        switch (($repoArr[2] -split('@'))[0]) {
            "rpc-tyche" {
                $company = "AON"
                break
            }
            "cloud-discovery-tool" {
                $company = "Version_1"
                break
            }
            Default {
                $company = ($repoArr[2] -split('@'))[0]
            }
        }
        $org = $repoArr[3]
        $project = $repoArr[4]
        $repoName = $repoArr[6]

        Write-Host "Repo URL : $($repoUrl)" -ForegroundColor DarkGray
        Write-Host "Organization : $($company)" -ForegroundColor Green
        Write-Host "ADO Org : $($org)" -ForegroundColor Green
        Write-Host "Project : $($project)" -ForegroundColor Green
        Write-Host "Repo Name : $($repoName)"-ForegroundColor Green
        break
    }
    {$_ -match "github.com"} {
        # Write-Host "Github Repo"
        switch ($repoArr[2] -replace "github.com") {
            {$_.Length -eq 0 -or $_ -eq "www."} {
                $company = "PublicGithub"
                break
            }
            "KnownHostNamePrefix." {
                $company = "ComapnyHostingGithub"
                break
            }
            Default {
                $gitHostPrefix = $repoArr[2] -replace "github.com"
                $company = $gitHostPrefix.Substring(0,$gitHostPrefix.Length-1)
            }
        }
        $org = $repoArr[3]
        $project = ""
        $repoName = $repoArr[4] -replace ".git"

        Write-Host "Repo URL : $($repoUrl)" -ForegroundColor DarkGray
        Write-Host "Git Host : $($company)" -ForegroundColor Green
        Write-Host "Git Org : $($org)" -ForegroundColor Green
        # Write-Host "Project : $($project)" -ForegroundColor Green
        Write-Host "Repo Name : $($repoName)"-ForegroundColor Green
        break
    }
}

Read-Host "Enter or Ctrl+C here"

if (!(Test-Path $workspaceFolder)) {
    Write-Host "Workspace Path $($workspaceFolder) not found." -ForegroundColor Yellow
    Write-Host "Creating workspace folder: $($workspaceFolder)" -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $workspaceFolder -Force | Out-Null
}

$repoFolder = Join-Path -Path $workspaceFolder -ChildPath $company | Join-Path -ChildPath $org | Join-Path -ChildPath $project | Join-Path -ChildPath $repoName
if (!(Test-Path $repoFolder)) {
    Write-Host "Creating repo folder: $($repoFolder)" --ForegroundColor Green
    New-Item -ItemType Directory -Path $repoFolder -Force | Out-Null
}

# Clone the repo into repository folder
git clone "$($repoUrl)" "$($repoFolder)"






