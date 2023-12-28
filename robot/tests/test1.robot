*** Settings ***
Library     Browser


*** Test Cases ***
Gofore
    New Browser             chromium    headless=No  devtools=True
    New Context             viewport={'width': 1920, 'height': 1080}
    New Page                https://www.google.com
    Set Browser Timeout     30.0 sec
    Get Page Source
    Click                   xpath=/html/body/div[2]/div[3]/div[3]/span/div/div/div/div[3]/div[1]/button[2]/div
    Sleep  2

    Fill Text    //*[@id="APjFqb"]    verkkokauppa.com
    Click    //input[1]
    Click    //h3[@class="LC20lb MBeuO DKV0Md"]
    Click    //span[@class="sc-dCFHLb bdultG sc-282kdl-3 knIkQt"]
    Click    xpath=(//div[@class="sc-1n5lsnz-0 gbnwYU"])[2]
    Click    xpath=(//div[@class="sc-1n5lsnz-0 gbnwYU"])[2]
    Click    xpath=(//div[@class="sc-1n5lsnz-0 gbnwYU"])[3]
    Click    xpath=(//div[@class="sc-1n5lsnz-0 gbnwYU"])[4]
    Click    //a[@title="Apple MacBook Pro 14” M3 Max 36 Gt, 1 Tt 2023 -kannettava, tähtimusta (MRX53)"]

    #Type Text               //*[@id="APjFqb"]          Gofore
    #Click                   xpath=/html/body/div[1]/div[3]/form/div[1]/div[1]/div[2]/div[2]/div[6]/center/input[1]
    #Click                   text="Gofore: Eettisen digimaailman pioneeri"
    #Click                   text="Allow cookies"
    #Click                   xpath=//*[@id="colophon"]/div/div[2]/ul/li[1]/a
    #


    
    

