# PowerShell script to load .env and run dbt
# Usage: .\run_dbt.ps1 debug
# Usage: .\run_dbt.ps1 run --select stg_customers

param(
    [Parameter(ValueFromRemainingArguments=$true)]
    [string[]]$DbtArgs = @("debug")
)

Write-Host "Loading environment variables from .env..." -ForegroundColor Green

# Read .env file and set environment variables
if (Test-Path ".env") {
    Get-Content ".env" | ForEach-Object {
        if ($_ -match '^\s*([^#][^=]+)=(.+)$') {
            $name = $matches[1].Trim()
            $value = $matches[2].Trim()
            [Environment]::SetEnvironmentVariable($name, $value, "Process")
            Write-Host "  Set $name" -ForegroundColor Gray
        }
    }
    Write-Host "Environment variables loaded successfully!" -ForegroundColor Green
} else {
    Write-Host "ERROR: .env file not found!" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Running dbt $DbtArgs..." -ForegroundColor Cyan
Write-Host ""

# Activate virtual environment if it exists
if (Test-Path "..\.venv\Scripts\Activate.ps1") {
    & "..\.venv\Scripts\Activate.ps1"
}

# Run dbt command with profiles-dir set to current directory
& dbt @DbtArgs --profiles-dir .

Write-Host ""
Write-Host "Done!" -ForegroundColor Green
