# Custom-Command-Shell

A MASM-based command-line shell that relies on the Irvine32 library to provide basic command execution, simple file management, and a console user interface.

## Project Structure

```
Custom-Command-Shell/
├── CustomCommandShell.VS/        # Visual Studio solution and project files
├── src/                          # MASM source code
│   └── Source.asm
├── docs/                         # Documentation assets
├── tests/                        # Test harnesses and scripts
├── build/                        # Generated build outputs (ignored by git)
└── README.md
```

## Prerequisites

- Visual Studio with the Desktop development with C++ workload (v143 toolset or newer)
- Microsoft Macro Assembler (MASM) tooling installed via Visual Studio
- Irvine32 library installed (expected at `C:\irvine`)

## Build

From a Developer PowerShell for VS terminal:

```
msbuild .\CustomCommandShell.VS\CustomCommandShell.sln ^
  /p:Configuration=Debug /p:Platform=Win32
```

Build artifacts are written to `build\<Platform>\<Configuration>\`.

## Run

After a successful build, launch the executable:

```
.\build\Win32\Debug\CustomCommandShell.exe
```

Adjust the configuration/platform in the path if you build a different target.

## Testing

The `tests/` directory is reserved for future automated harnesses. Add regression scripts or unit-style tests here as the feature set grows.