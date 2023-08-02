##################################################
#Edgar the Virus Hunter - Powershell Edition v1.0#
#Author: u/MessAdmin                             #
##################################################


#Scan state array
$scanarray = @(
'[)...................]'
'[))..................]'
'[))).................]'
'[))))................]'
'[)))))...............]'
'[))))))..............]'
'[))))))).............]'
'[))))))))............]'
'[)))))))))...........]'
'[))))))))))..........]'
'[))))))))))).........]'
'[))))))))))))........]'
'[))))))))))))).......]'
'[))))))))))))))......]'
'[))))))))))))))).....]'
'[))))))))))))))))....]'
'[)))))))))))))))))...]'
'[))))))))))))))))))..]'
'[))))))))))))))))))).]'
'[))))))))))))))))))))]'
)

#Splash Screen
cls

'    XXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
'  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
' XXXXXXXXXXXXXXXXXX         XXXXXXXX'
'XXXXXXXXXXXXXXXX              XXXXXXX'
'XXXXXXXXXXXXX                   XXXXX'
' XXX     _________ _________     XXX      '
'  XX    I  _xxxxx I xxxxx_  I    XX        '
' ( X----I         I         I----X )        '   
'( +I    I      00 I 00      I    I+ )'
' ( I    I    __0  I  0__    I    I )'
'  (I    I______ /   \_______I    I)'
'   I           ( ___ )           I'
'   I    _  :::::::::::::::  _    i'
'    \    \___ ::::::::: ___/    /'
'     \_      \_________/      _/'
'       \        \___,        /'
'         \                 /'
'          |\             /|'
'          |  \_________/  |'
'       ======================'
'       |---Edgar the Virus---'
'       |-------Hunter-------|'
'       |Programmed entirely-|'
"       |in mom's basement---|"
'       |by Edgar------(C)1982'
'       ======================'

#Splash SFX
[Console]::Beep(1567.98,90)
[Console]::Beep(1567.98,90)
[Console]::Beep(1760,90)
[Console]::Beep(1567.98,90)
[Console]::Beep(1760,90)
[Console]::Beep(1975.53,90)

Read-Host 'Press ENTER to continue.'
cls

#Scanning...

Foreach($state in $scanarray){
cls
'=========================='
'|---Virus Protection-----|'
'|-----version .0001------|'
'|------------------------|'
'|Last scan was NEVER ago.|'
'|------------------------|'
'|-------scanning...------|'
"|--$state|"
'=========================='
Start-Sleep -Milliseconds 500
}
cls

#Scan Complete

##GFX
'================'
'|Scan Complete!|'
'|--------------|'
'|---423,827----|'
'|Viruses Found-|'
'|--------------|'
'|A New Record!!|'
'================'

##SFX
[Console]::Beep(783.99,700)

Start-Sleep -Seconds 8
cls

#Flagrant System Error

##SFX
[Console]::Beep(329.628,150)
[Console]::Beep(415.30,50)
[Console]::Beep(445,700)

##GFX
While($true){
cls
'          FLAGRANT SYSTEM ERROR          '
''
'             Computer over.              '
'            Virus = Very Yes.            '
Start-Sleep -Seconds 10
}