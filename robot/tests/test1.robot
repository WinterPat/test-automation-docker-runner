*** Settings ***
Documentation               Opinnäytetyö demo testi
...                     
Resource                    ${CURDIR}${/}resources.robot
Test Timeout                90 minutes
Suite Setup                 OMA Suite Setup
Suite Teardown              OMA Suite Teardown
Test Setup                  OMA Test Setup
Test Teardown               OMA Test Teardown
Force Tags                  testi_1


*** Variables ***
# Suite inputs
${SITE}                     https://www.google.com/

# Suite output
${KESKIARVO}                ${NONE}
${OPINTOPISTEET}            ${NONE}


*** Test Cases ***
Gofore_Com_Testi_1   
    Go To          ${SITE}
    ClickText      Accept all
    TypeText       //*[@name\="q"]             Gofore
    ClickText      Google Search
    VerifyText     Gofore: We offer expert knowledge in digitalisation
    ClickText      Gofore: We offer expert knowledge in digitalisation
    ScrollTo       News
    ClickText      News
    ClickText      The building blocks of a great digital society – this is how Finland leads the way
    VerifyText     The building blocks of a great digital society – this is how Finland leads the way
    Sleep          5s

Verkkokauppa_Com_Testi_2
    [Documentation]
    [Tags]
    Go To          ${SITE}
    TypeText       //*[@name\="q"]             Verkkokauppa
    ClickText      Google Search
    VerifyText     Verkkokauppa.com - todennäköisesti aina halvempi
    LogScreenshot
    ClickText      Verkkokauppa.com - todennäköisesti aina halvempi
    LogScreenshot
    Sleep          10

Twitch_Com_Testi_3
    [Documentation]
    [Tags]
    Go To          ${SITE}
    TypeText       //*[@name\="q"]             Twitch.tv
    ClickText      Google Search
    VerifyText     Twitch is an interactive livestreaming service for content spanning gaming, entertainment, sports, music, and more.
    LogScreenshot
    ClickText      //*[@class\="LC20lb MBeuO DKV0Md"]
    LogScreenshot
    Sleep          30