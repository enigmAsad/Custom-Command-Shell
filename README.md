# Custom-Command-Shell

A lightweight, MASM-based command-line shell that leverages the Irvine32 library to provide a custom console interface, file management utilities, and system information commands.

## Table of Contents

- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
- [Architecture](#architecture)
- [Contributing](#contributing)
- [License](#license)

## Features

- **System Commands**:
  - `time`: Display current system time.
  - `date`: Display current system date.
  - `version`: Show shell version information.
  - `clear`: Clear the console screen.
  - `exit`: Terminate the shell session.

- **File Operations**:
  - `create`: Create new text files with custom content.
  - `read`: Read and display contents of existing text files.
  - `delete`: Remove files from the filesystem.

- **Interactive UI**:
  - Color-coded command output.
  - Interactive prompts for file handling.

## Prerequisites

Before you begin, ensure you have the following installed:

- **Visual Studio 2019/2022**: With "Desktop development with C++" workload.
- **MASM**: Microsoft Macro Assembler (included with Visual Studio).
- **Irvine32 Library**: Required for input/output operations.
  - Download and install from [Assembly Language for x86 Processors](http://www.asmirvine.com/).
  - Ensure the library is at `C:\irvine` or update the project paths accordingly.

## Installation

1. **Clone the Repository**
   ```bash
   git clone https://github.com/yourusername/Custom-Command-Shell.git
   cd Custom-Command-Shell
   ```

2. **Open the Solution**
   - Open `CustomCommandShell.VS/CustomCommandShell.sln` in Visual Studio.

3. **Configure Dependencies**
   - Ensure the project properties point to the correct Irvine32 include and library paths if they are not in the default `C:\irvine` location.

## Usage

### Building the Project

You can build the project directly from Visual Studio or via the Developer PowerShell:

```powershell
msbuild .\CustomCommandShell.VS\CustomCommandShell.sln /p:Configuration=Debug /p:Platform=Win32
```

### Running the Shell

After a successful build, execute the binary:

```powershell
.\build\Win32\Debug\CustomCommandShell.exe
```

### Example Session

```text
myShell> help
=================== MyShell Help ===================
Basic Commands:
  help     - Show this help message
  exit     - Exit the shell
...

myShell> time
14:30:45

myShell> create
Enter filename to create: test.txt
Enter file content: Hello World!
File created successfully.

myShell> read
Enter filename to read: test.txt
File contents: 
Hello World!
```

## Architecture

The project is structured to separate source code, build artifacts, and documentation.

```
Custom-Command-Shell/
├── CustomCommandShell.VS/   # Visual Studio solution (.sln) and project (.vcxproj)
├── src/                     # Main Assembly source code (Source.asm)
├── build/                   # Compiled binaries and intermediate files
├── docs/                    # Documentation and design notes
└── tests/                   # Test scripts (planned)
```

### Core Logic (`src/Source.asm`)
- **Main Loop**: Continuously prompts for user input (`myShell> `).
- **Command Processing**: Compares input against known command strings (`help`, `time`, `create`, etc.).
- **Procedures**: Modular procedures handle specific tasks (e.g., `CreateDynamicTextFile`, `displayTime`).

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository.
2. Create a new branch (`git checkout -b feature/AmazingFeature`).
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`).
4. Push to the branch (`git push origin feature/AmazingFeature`).
5. Open a Pull Request.

## License

Distributed under the MIT License. See `LICENSE` for more information.
