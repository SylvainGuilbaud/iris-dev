# IRIS Dev Environment Setup Script

This script sets up the IRIS development environment by installing necessary packages, configuring settings, and importing required files.

## Steps

1. **Install Required Packages**
   - Use IPM (InterSystems Package Manager) to install the following packages:
     - webterminal
     - classexplorer
     - dsw
     - swagger-ui
     - readonly-interoperability

2. **Enable Statistics and Monitoring**
   - Enable SAM (Service Availability Monitoring) for the IRISAPP namespace.
   - Enable production statistics.

3. **Import Required Files**
   - Import the `%ZSTART.mac` file from the source directory.
   - Import the `common.inc` file from the source directory.
4. **Set Namespace**
   - Set the current namespace to `IRISAPP`.
5. **Import Source Files**
   - Import all source files from the `src` directory into the IRISAPP namespace.
6. **Merge Configuration**
   - Merge the `merge.cpf` configuration file into the IRIS instance.
7. **Start IRIS Instance**
   - Start the IRIS instance and run the `iris.script` to execute the setup commands.

## Usage on Linux / MacOS

To run this script on Linux or MacOS, execute the following command in the terminal:

```bash on Linux or MacOS
./start.sh
```

## Usage on Windows PowerShell

To run this script on Windows with PowerShell, execute the following command in the terminal:
```bash on Windows
pwsh ./start.ps1
```

```bash on Windows
.\start.ps1
```

## Usage on Windows Command Prompt

```cmd
start.cmd
```

```batch
start.bat
```