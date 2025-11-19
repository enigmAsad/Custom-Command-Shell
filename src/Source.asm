INCLUDE irvine32.inc
ExitProcess PROTO, dwExitCode:DWORD
SetConsoleTitleA PROTO, lpConsoleTitle:PTR BYTE
DeleteFileA PROTO,
    lpFileName:PTR BYTE

GetFileAttributesA PROTO,
    lpFileName:PTR BYTE

CreateFileA PROTO,
    lpFileName:PTR BYTE, dwDesiredAccess:DWORD, dwShareMode:DWORD,
    lpSecurityAttributes:DWORD, dwCreationDisposition:DWORD,
    dwFlagsAndAttributes:DWORD, hTemplateFile:DWORD

WriteFile PROTO,
    hFile:DWORD, lpBuffer:PTR BYTE, nNumberOfBytesToWrite:DWORD,
    lpNumberOfBytesWritten:PTR DWORD, lpOverlapped:DWORD

ReadFile PROTO,
    hFile:DWORD, lpBuffer:PTR BYTE, nNumberOfBytesToRead:DWORD,
    lpNumberOfBytesRead:PTR DWORD, lpOverlapped:DWORD

CloseHandle PROTO, hObject:DWORD

GetLocalTime PROTO, lpSystemTime:PTR SYSTEMTIME

.data
    prompt BYTE "myShell> ", 0
    inputBuffer BYTE 128 DUP(0)
    filename BYTE 128 DUP(0)
    fileContent BYTE 256 DUP(0)
    readFilename BYTE 128 DUP(0)  ;
    fileBuffer BYTE 1024 DUP(0) ;
    deleteFilename BYTE 128 DUP(0)
    exitCommand BYTE "exit", 0
    helpCommand BYTE "help", 0
    clearCommand BYTE "clear", 0
    versionCommand BYTE "version", 0
    timeCommand BYTE "time", 0
    dateCommand BYTE "date", 0
    colorCommand BYTE "color", 0
    echoCommand BYTE "echo ", 0

    helpTitle    BYTE "=================== MyShell Help ===================", 13, 10, 0
    helpBasic    BYTE "Basic Commands:", 13, 10
                 BYTE "  help     - Show this help message", 13, 10
                 BYTE "  exit     - Exit the shell", 13, 10
                 BYTE "  clear    - Clear the screen", 13, 10
                 BYTE "  version  - Show shell version", 13, 10, 0

    helpDisplay  BYTE "Display Commands:", 13, 10
                 BYTE "  time     - Show current system time", 13, 10
                 BYTE "  date     - Show current system date", 13, 10, 0
                 
    helpCustom   BYTE "File I/O Operations:", 13, 10
                 BYTE "  create   - Create a text file", 13, 10
                 BYTE "  read     - Read a text file", 13, 10
                 BYTE "  delete   - Delete a text file", 13, 10, 0
                 
    helpFooter   BYTE "=================================================", 13, 10, 0
    versionMessage BYTE "myShell version 1.0", 0
    unknownCommand BYTE "Unknown command.", 0
    createCommand BYTE "create", 0
    readCommand BYTE "read", 0
    filenamePrompt BYTE "Enter filename to create: ", 0
    contentPrompt BYTE "Enter file content: ", 0
    createSuccessMsg BYTE "File created successfully.", 0
    createErrorMsg BYTE "Error creating file.", 0
    readFilenamePrompt BYTE "Enter filename to read: ", 0
    fileReadErrorMsg BYTE "Error opening file.", 0
    fileReadContentMsg BYTE "File contents: ", 0
    fileEmptyMsg BYTE "File is empty.", 0
    deleteCommand BYTE "delete", 0
    deleteFilenamePrompt BYTE "Enter filename to delete: ", 0
    deleteSuccessMsg BYTE "File deleted successfully.", 0
    deleteErrorMsg BYTE "Error deleting file.", 0
    fileNotFoundMsg BYTE "File not found.", 0
    windowTitle BYTE "myShell", 0    

INVALID_FILE_ATTRIBUTES EQU -1    ; 0FFFFFFFFh

.data?
sysTime SYSTEMTIME <>

.code
main PROC
    INVOKE SetConsoleTitleA, ADDR windowTitle
    call Clrscr

shellLoop:
    mov edx, OFFSET prompt
    call WriteString
    
    mov edx, OFFSET inputBuffer
    mov ecx, SIZEOF inputBuffer
    call ReadString
  
    call processCommand
    
    jmp shellLoop
main ENDP

processCommand PROC
    mov edi, OFFSET inputBuffer
    call StripNewline

    ; Compare with exit command
    mov esi, OFFSET inputBuffer
    mov edi, OFFSET exitCommand
    call CompareStrings
    cmp eax, 1          
    je exitShell         

    ; Compare with help command
    mov esi, OFFSET inputBuffer
    mov edi, OFFSET helpCommand
    call CompareStrings
    cmp eax, 1
    je displayHelpGG

    ; Compare with clear command
    mov esi, OFFSET inputBuffer
    mov edi, OFFSET clearCommand
    call CompareStrings
    cmp eax, 1
    je clearScreen

    ; Compare with version command
    mov esi, OFFSET inputBuffer
    mov edi, OFFSET versionCommand
    call CompareStrings
    cmp eax, 1
    je displayVersion

    ; Compare with time command
    mov esi, OFFSET inputBuffer
    mov edi, OFFSET timeCommand
    call CompareStrings
    cmp eax, 1
    je displayTimeGG

    ; Compare with date command
    mov esi, OFFSET inputBuffer
    mov edi, OFFSET dateCommand
    call CompareStrings
    cmp eax, 1
    je displayDateGG

    ; Compare with create command
    mov esi, OFFSET inputBuffer
    mov edi, OFFSET createCommand
    call CompareStrings
    cmp eax, 1
    je createFileFromShell

    ; Compare with read command
    mov esi, OFFSET inputBuffer
    mov edi, OFFSET readCommand
    call CompareStrings
    cmp eax, 1
    je readFileFromShell

    ; Compare with delete command
    mov esi, OFFSET inputBuffer
    mov edi, OFFSET deleteCommand
    call CompareStrings
    cmp eax, 1
    je deleteFileFromShell

    ; If no command matches
    mov edx, OFFSET unknownCommand
    call WriteString
    call Crlf
    jmp continueShell

displayHelpGG:
    call displayHelp     
    jmp continueShell

displayTimeGG:
    call displayTime     
    jmp continueShell

displayDateGG:
    call displayDate      
    jmp continueShell

createFileFromShell:
    call CreateDynamicTextFile
    jmp continueShell

readFileFromShell:
    call ReadDynamicTextFile
    jmp continueShell

deleteFileFromShell:
    call DeleteDynamicTextFile
    jmp continueShell

displayVersion:
    mov edx, OFFSET versionMessage
    call WriteString
    call Crlf
    jmp continueShell

clearScreen:
    call Clrscr
    jmp continueShell

continueShell:
    ret

processCommand ENDP

CompareStrings PROC
    push ecx            
    push esi
    push edi

compareLoop:
    mov cl, [esi]      
    mov ch, [edi]      

    cmp cl, 0
    jne checkMatch
    cmp ch, 0
    jne notEqual
    jmp equal          

checkMatch:
    cmp cl, ch        
    jne notEqual       
    
    inc esi            
    inc edi
    jmp compareLoop    

notEqual:
    pop edi            
    pop esi
    pop ecx
    mov eax, 0        
    ret

equal:
    pop edi            
    pop esi
    pop ecx
    mov eax, 1       
    ret

CompareStrings ENDP

exitShell:
    exit

StripNewline PROC
    push ecx           
    push edi
    
    mov ecx, 128
findNullOrNewline:
    cmp byte ptr [edi], 0    
    je stripDone
    cmp byte ptr [edi], 0Dh  
    je stripIt
    inc edi
    loop findNullOrNewline
    jmp stripDone

stripIt:
    mov byte ptr [edi], 0   

stripDone:
    pop edi            
    pop ecx
    ret
StripNewline ENDP

displayHelp PROC
    pushad                  

    mov eax, lightGray     
    call SetTextColor
    mov edx, OFFSET helpTitle
    call WriteString

    mov eax, lightCyan     
    call SetTextColor
    mov edx, OFFSET helpBasic
    call WriteString
    
    mov eax, lightGreen    
    call SetTextColor
    mov edx, OFFSET helpDisplay
    call WriteString
    
    mov eax, lightMagenta  
    call SetTextColor
    mov edx, OFFSET helpCustom
    call WriteString
    
    mov eax, lightGray     
    call SetTextColor
    mov edx, OFFSET helpFooter
    call WriteString

    mov eax, lightGray     
    call SetTextColor
    
    popad                   
    ret
displayHelp ENDP

displayTime PROC
    INVOKE GetLocalTime, ADDR sysTime
    movzx eax, sysTime.wHour
    call WriteDec
    mov al, ':'
    call WriteChar
    movzx eax, sysTime.wMinute
    call WriteDec
    mov al, ':'
    call WriteChar
    movzx eax, sysTime.wSecond
    call WriteDec
    call Crlf
    ret
displayTime ENDP

displayDate PROC
    INVOKE GetLocalTime, ADDR sysTime
    movzx eax, sysTime.wMonth
    call WriteDec
    mov al, '/'
    call WriteChar
    movzx eax, sysTime.wDay
    call WriteDec
    mov al, '/'
    call WriteChar
    movzx eax, sysTime.wYear
    call WriteDec
    call Crlf
    ret
displayDate ENDP

CreateDynamicTextFile PROC

    LOCAL fileHandle:DWORD
    LOCAL bytesWritten:DWORD
    mov edx, OFFSET filenamePrompt
    call WriteString

    mov edx, OFFSET filename
    mov ecx, SIZEOF filename
    call ReadString

    mov edx, OFFSET contentPrompt
    call WriteString
    
    mov edx, OFFSET fileContent
    mov ecx, SIZEOF fileContent
    call ReadString

    INVOKE CreateFileA, 
        ADDR filename,           
        GENERIC_WRITE,           
        0,                       
        NULL,                    
        CREATE_ALWAYS,           
        FILE_ATTRIBUTE_NORMAL,  
        0                       

    cmp eax, INVALID_HANDLE_VALUE
    je fileCreateError

    mov fileHandle, eax

    INVOKE WriteFile,
        fileHandle,              
        ADDR fileContent,        
        LENGTHOF fileContent,    
        ADDR bytesWritten,       
        NULL                     

    .IF eax == 0
        jmp fileWriteError
    .ENDIF

    INVOKE CloseHandle, fileHandle

    mov edx, OFFSET createSuccessMsg
    call WriteString
    call Crlf
    ret

fileCreateError:
    mov edx, OFFSET createErrorMsg
    call WriteString
    call Crlf
    ret

fileWriteError:
    mov edx, OFFSET createErrorMsg
    call WriteString
    call Crlf
    INVOKE CloseHandle, fileHandle
    ret

CreateDynamicTextFile ENDP

ReadDynamicTextFile PROC

    LOCAL fileHandle:DWORD
    LOCAL bytesRead:DWORD

    mov edx, OFFSET readFilenamePrompt
    call WriteString

    mov edx, OFFSET readFilename
    mov ecx, SIZEOF readFilename
    call ReadString

    INVOKE CreateFileA, 
        ADDR readFilename,    
        GENERIC_READ,         
        FILE_SHARE_READ,      
        NULL,                 
        OPEN_EXISTING,        
        FILE_ATTRIBUTE_NORMAL,
        0                     

    cmp eax, INVALID_HANDLE_VALUE
    je fileOpenError

    mov fileHandle, eax

    mov edi, OFFSET fileBuffer
    mov ecx, LENGTHOF fileBuffer
    mov al, 0
    rep stosb

    INVOKE ReadFile, 
        fileHandle,           
        ADDR fileBuffer,      
        LENGTHOF fileBuffer,  
        ADDR bytesRead,       
        NULL                  

    .IF eax == 0
        jmp fileReadError
    .ENDIF

    mov eax, bytesRead
    .IF eax == 0
        mov edx, OFFSET fileEmptyMsg
        call WriteString
        call Crlf
        jmp fileReadDone
    .ENDIF

    mov edx, OFFSET fileReadContentMsg
    call WriteString
    call Crlf

    mov edx, OFFSET fileBuffer
    call WriteString
    call Crlf

fileReadDone:
    INVOKE CloseHandle, fileHandle
    ret

fileOpenError:
    mov edx, OFFSET fileReadErrorMsg
    call WriteString
    call Crlf
    ret

fileReadError:
    mov edx, OFFSET fileReadErrorMsg
    call WriteString
    call Crlf
    
    INVOKE CloseHandle, fileHandle
    ret

ReadDynamicTextFile ENDP

DeleteDynamicTextFile PROC
    mov edx, OFFSET deleteFilenamePrompt
    call WriteString
    
    mov edx, OFFSET deleteFilename
    mov ecx, SIZEOF deleteFilename
    call ReadString
    
    INVOKE GetFileAttributesA, ADDR deleteFilename
    cmp eax, INVALID_FILE_ATTRIBUTES    
    je fileNotFound
    
    INVOKE DeleteFileA, ADDR deleteFilename
    
    test eax, eax           
    jz deleteFailed
    
    mov edx, OFFSET deleteSuccessMsg
    call WriteString
    call Crlf
    jmp deleteEnd

fileNotFound:
    mov edx, OFFSET fileNotFoundMsg
    call WriteString
    call Crlf
    jmp deleteEnd

deleteFailed:
    mov edx, OFFSET deleteErrorMsg
    call WriteString
    call Crlf

deleteEnd:
    ret
DeleteDynamicTextFile ENDP

END main