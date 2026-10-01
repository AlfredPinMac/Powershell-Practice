<#
.SYNOPSIS
    Checks whether a specific TCP port is open or closed.
.DESCRIPTION
    This PowerShell script tests TCP connectivity to a given port and host using System.Net.Sockets.TcpClient.
.PARAMETER Port
    The TCP port number to check (1 - 65535). Mandatory.
.PARAMETER HostName
    The target IP address or hostname. Defaults to '127.0.0.1'.
.PARAMETER TimeoutMs
    Connection timeout in milliseconds. Defaults to 2000 ms (2 seconds).
.EXAMPLE
    .\Check-Port.ps1 -Port 80 -HostName "google.com"
.EXAMPLE
    .\Check-Port.ps1 443 scanme.nmap.org
.EXAMPLE
    .\Check-Port.ps1 22
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, Position = 0, HelpMessage = "Enter a port number between 1 and 65535")]
    [ValidateRange(1, 65535)]
    [int]$Port,

    [Parameter(Position = 1)]
    [string]$HostName = "127.0.0.1",

    [int]$TimeoutMs = 2000
)

Write-Host "[*] Checking port $Port on host $HostName..." -ForegroundColor Cyan

$tcpClient = New-Object System.Net.Sockets.TcpClient
$asyncResult = $null

try {
    # Initiate asynchronous connection attempt
    $asyncResult = $tcpClient.BeginConnect($HostName, $Port, $null, $null)
    
    # Wait for the specified timeout
    $success = $asyncResult.AsyncWaitHandle.WaitOne($TimeoutMs, $false)

    if ($success -and $tcpClient.Connected) {
        $tcpClient.EndConnect($asyncResult)
        Write-Host "[+] Port $Port is OPEN on $HostName." -ForegroundColor Green
        exit 0
    }
    else {
        Write-Host "[-] Port $Port is CLOSED (or not responding) on $HostName." -ForegroundColor Red
        exit 1
    }
}
catch {
    Write-Host "[-] Port $Port is CLOSED (or not responding) on $HostName." -ForegroundColor Red
    exit 1
}
finally {
    if ($null -ne $asyncResult) {
        $asyncResult.AsyncWaitHandle.Close()
    }
    $tcpClient.Close()
    $tcpClient.Dispose()
}
