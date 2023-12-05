*** Settings ***
Documentation               Avainsanoja liittyen kirjautumiseen, selain asetuksiin, testi asetuksiin ja navigaatioihin.
...                         Myös vakio muuttujat.
Library                     QWeb
Resource                    ${CURDIR}${/}keywords.robot

*** Variables ***
# Testi muuttujia
${DEFAULT_USERNAME}         ${NONE}
${DEFAULT_PASSWORD}         ${NONE}

# Selain muuttujia
${DEFAULT_BROWSER}          chrome
${DEFAULT_TIMEOUT}          30s
${DRAW_BOX}                 True

# Navigaatio muutujia
${OMA_URL}                  https://oma.metropolia.fi/
${USERMENU}                 xpath\=//*[@class\="username"]

*** Keywords ***
OMA Suite Setup
    [Documentation]         Avaa selain, aseta resoluutio, aseta avainsanojen aikakatkaisu 150s ja aseta hakutila.
    Set Library Search Order        QWeb
    SetConfig               ClickToFocus          True
    SetConfig               DefaultTimeout        ${default_timeout}
    Open Browser            about:blank           ${DEFAULT_BROWSER}   -no-sandbox, -disable-dev-shm-usage, -disable-gpu
    MaximizeWindow
    IF  '${DRAW_BOX}' == 'True'
        SetConfig               SearchMode        draw
    END
    LogScreenshot           Selaimen_alustus.png
    Sleep                   5

OMA Suite Teardown
    [Documentation]         kirjaudu ulso ja sulje selain. 
    Close All Browsers
    Sleep                   2s

OMA Test Setup
    [Documentation]         Aseta QWeb asetuksia.
    SetConfig               LineBreak             None
    SetConfig               CssSelectors          True
    SetConfig               CheckInputValue       True

OMA Test Teardown
    [Documentation]         Ota kuvakaapaus kun testi epäonnistuu.
    IF    '${TEST STATUS}' == 'FAIL'
        LogScreenshot           screenshot_failed_${TEST NAME}.png
    END

Login_OMA
    [Documentation]         Kirjaudu OMA metropolia palveluun.
    GoTo                    ${OMA_URL}
    TypeText                Username                    ${DEFAULT_USERNAME}
    TypeText                Password                    ${DEFAULT_PASSWORD}
    ClickText               Login
    VerifyNoText            The password you entered was incorrect.
    VerifyNoText            The username you entered cannot be identified.
    VerifyText              Näytä työtilat
    LogScreenshot

Logout_OMA
    [Documentation]         Kirjaudu ulos OMA metropolia palvelusta.
    GoTo                    ${OMA_URL}
    ClickElement            ${USERMENU}
    ClickText               Kirjaudu ulos

Main_Page
    [Documentation]         Palaa etusivulle.
    GoTo                    ${OMA_URL}
    
Appstate
    [Documentation]         Varmista testin aloitus piste.
    [Arguments]             ${app}
    IF  '${app}' == 'Login_OMA'
        Login_OMA
    ELSE IF  '${app}' == 'Main_Page'
        Main_Page
    END