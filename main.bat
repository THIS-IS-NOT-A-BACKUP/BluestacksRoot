@echo off

set XML_FILE=%ProgramData%\BlueStacks_nxt\Engine\Rvc64\Rvc64.bstk
set CONF_FILE=%ProgramData%\BlueStacks_nxt\bluestacks.conf
set TEMP_FILE=%CONF_FILE%.tmp

rem Display user options
echo 1. Apply changes
echo 2. Undo XML changes
echo 3. Undo Root
set /p OPTION=Enter option number: 

rem Process user choice
if "%OPTION%" == "1" (
    goto apply_changes
) else if "%OPTION%" == "2" (
    goto undo_xml_changes
) else if "%OPTION%" == "3" (
    goto undo_conf_changes
) else (
    echo Invalid option.
    pause
    exit /b 1
)

:apply_changes
rem Create a backup of the original XML file
copy "%XML_FILE%" "%XML_FILE%.bak" /Y > nul

rem Make changes to the temporary XML file using PowerShell
copy "%XML_FILE%" "%TEMP_FILE%" /Y > nul
powershell -Command "(Get-Content '%TEMP_FILE%') -replace 'type=\"ReadOnly\"', 'type=\"Normal\"' | Set-Content '%TEMP_FILE%'"

rem Replace the original XML file with the modified temporary XML file
move /Y "%TEMP_FILE%" "%XML_FILE%" > nul

rem Create a backup of the original bluestacks.conf file
copy "%CONF_FILE%" "%CONF_FILE%.bak" /Y > nul

rem Make changes to the temporary bluestacks.conf file using PowerShell
copy "%CONF_FILE%" "%TEMP_FILE%" /Y > nul
powershell -Command "(Get-Content '%TEMP_FILE%') -replace 'bst.instance.Rvc64.enable_root_access=\"0\"', 'bst.instance.Rvc64.enable_root_access=\"1\"' | Set-Content '%TEMP_FILE%'"
powershell -Command "(Get-Content '%TEMP_FILE%') -replace 'bst.feature.rooting=\"0\"', 'bst.feature.rooting=\"1\"' | Set-Content '%TEMP_FILE%'"

rem Replace the original bluestacks.conf file with the modified temporary bluestacks.conf file
move /Y "%TEMP_FILE%" "%CONF_FILE%" > nul

echo Changes applied successfully.
pause
exit /b 0

:undo_xml_changes
rem Restore the original XML file from the backup file
copy "%XML_FILE%.bak" "%XML_FILE%" /Y > nul

echo XML changes undone successfully.
pause
exit /b 0

:undo_conf_changes
rem Restore the original bluestacks.conf file from the backup file
copy "%CONF_FILE%.bak" "%CONF_FILE%" /Y > nul

echo bluestacks.conf changes undone successfully.
pause
exit /b 0
