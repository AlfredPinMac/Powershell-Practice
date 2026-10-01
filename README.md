# Cybersecurity Lab: Port Checker (Linux & Windows)

This repository provides port checking scripts for both **Linux (via Docker container)** and **Windows (via native PowerShell)** to verify whether a specific TCP port is **open** or **closed**.

---

## 📁 Project Structure

- `Dockerfile`: Container image definition based on Ubuntu 24.04 with network diagnostic tools.
- `check_port.sh`: Bash script to test TCP ports inside the Linux container.
- `Check-Port.ps1`: PowerShell script to test TCP ports natively on Windows.

---

## 🪟 Part 1: Windows (PowerShell)

### Requirements
- Windows PowerShell 5.1 or PowerShell 7+.

### Syntax
```powershell
.\Check-Port.ps1 -Port <PORT> [-HostName <HOST/IP>] [-TimeoutMs <MILLISECONDS>]
```
*Or using positional arguments:*
```powershell
.\Check-Port.ps1 <PORT> [<HOST/IP>]
```

### Examples & Test Cases on Windows

#### 1. Check an open port on a remote host:
```powershell
.\Check-Port.ps1 80 google.com
.\Check-Port.ps1 443 scanme.nmap.org
```

#### 2. Check a closed port on localhost:
```powershell
.\Check-Port.ps1 59999
```

#### 3. Simulate an open local port using PowerShell:
Open a listener in one PowerShell window:
```powershell
$listener = [System.Net.Sockets.TcpListener]8080; $listener.Start()
```
In another PowerShell window, run the script:
```powershell
.\Check-Port.ps1 8080
```
*(Stop the listener when done: `$listener.Stop()`)*

---

## 🐧 Part 2: Linux (Docker Container)

### Prerequisites
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) installed and running.

### Step 1: Build the Docker Image
```powershell
docker build -t lab-ciberseguridad .
```

### Step 2: Run the Interactive Container
```powershell
docker run --rm -it lab-ciberseguridad
```

### Step 3: Test the Script inside Linux (`/lab`)

#### Syntax
```bash
./check_port.sh <PORT> [HOST/IP]
```

#### Test Cases

1. **Check an open remote port:**
   ```bash
   ./check_port.sh 80 google.com
   ./check_port.sh 443 scanme.nmap.org
   ```

2. **Check a closed local port:**
   ```bash
   ./check_port.sh 9999
   ```

3. **Simulate a local open port with Netcat:**
   ```bash
   # Start background listener
   nc -l -p 8080 &

   # Check port (OPEN)
   ./check_port.sh 8080

   # Kill listener
   killall nc

   # Check port again (CLOSED)
   ./check_port.sh 8080
   ```

4. **Validation and Error Handling:**
   ```bash
   ./check_port.sh
   ./check_port.sh abc
   ./check_port.sh 70000
   ```

### Exit Container
```bash
exit
```
