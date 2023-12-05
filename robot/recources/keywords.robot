*** Settings ***
Documentation       Testi avainsanoja.

*** Keywords ***
# Opintosuunnittelu ja Tarkastelu
OpTy_HaeOpintopisteetJaKeskiarvo
    [Documentation]         Hae opitopisteet ja keskiarvo

    ClickElement            ${USERMENU}
    ClickText               Opiskelijan työpöytä
    ClickText               HOPS
    ${pisteet}=             GetText                     Suoritettuja opintopisteitä:    between=Suoritettuja opintopisteitä: ???
    ${keskiarvo}=           GetText                     Keskiarvo:                      between=Keskiarvo: ???
    LogScreenShot

    [Return]  ${pisteet}  ${keskiarvo}

