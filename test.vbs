Set objShell = CreateObject("WScript.Shell")
Set objArgs = WScript.Arguments

If objArgs.Count > 0 Then
    count = CInt(objArgs(0))
Else
    count = 1
End If

Set Sound = CreateObject("WMPlayer.OCX.7")
Sound.URL = "c:\windows\media\notify.wav"
Sound.Controls.play

response = MsgBox("This is message box number " & count, vbOKOnly, "Lovely message from Hagai Badichi")

If response = vbOK Then
    objShell.Run "wscript " & WScript.ScriptFullName & " " & (count + 1)
    objShell.Run "wscript " & WScript.ScriptFullName & " " & (count + 2)
End If
