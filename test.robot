*** Settings ***
Library    SeleniumLibrary
Library    String
*** Variables ***
${URL}    https://www.verkkokauppa.com/
${Browser}    Firefox
# Nazanin Fallah, Mona Achaaoud, Dawid Popek
*** Test Cases ***
TC_UI_1
    [Documentation]    Testing if all products have an icon //Dawid
    
    Open Browser    ${URL}    ${Browser}
    Sleep    2sec
    Click Element    css:div[class='header']>label
    Sleep    2sec
    ${elements}=    Get WebElements    css:ul[class='sidebar-category-list']>li
    ${elementslenght}=    Get Length    ${elements}
    FOR    ${i}    IN RANGE    1    ${elementslenght}
        IF    ${i} == ${26}
            ${i}=    Evaluate    ${i}+${1}
        END
        Element Should Be Visible    css:ul[class='sidebar-category-list']>li:nth-child(${i})>a>span>svg
    END
    Sleep    1s
    Close All Browsers
TC_UI_2
    [Documentation]    Test if you can find topics "Esittely" and "Lisätiedot" from product page //Mona
    Open Browser    ${URL}    ${Browser}
    Sleep    2sec
    Click Element    css:div>ol[class="Carousel-sc-1juqqra-2 RIKlb"]>li
    Sleep    2sec
    Page Should Contain    Esittely
    Page Should Contain    Lisätiedot
    Sleep    1s
    Close All Browsers

TC_UI_3
    [Documentation]    Adding a product to the bastket / check if the product is in our "shopping cart" //Mona

    Open Browser    ${URL}    ${Browser}
    Sleep    2sec
    Click Element    css:div[class="sc-yeoxbb-1 cYbvuI"]
    Click Button    css:Button[class="Button-sc-mt7im1-0 gpqHYV sc-1fb8oq9-0 guGhVJ"]
    Click Element    css:#checkout
    Sleep    1s
    Click Element    css:div[class="sc-am2rgn-0 kzTweN"]>a
    Page Should Contain Element    css:div>article
    Sleep    1s
    Close All Browsers    

TC_UI_4
    [Documentation]    Check if you are able to go to registration page from the login page //Nazanin
    Open Browser    ${URL}    ${Browser}
    Maximize Browser Window
    Sleep    2sec
    Click Element    css:#allow-cookies
    Sleep    3sec
    Double Click Element    css:#account
    Sleep    4sec
    Page Should Contain    Luo uusi asiakkuus
    Click Element    css:#register-button
    Click Element    css:#register-button
    Sleep    2sec
    ${url} =  Execute Javascript  return window.location.href;
    Should Be Equal    https://www.verkkokauppa.com/fi/account/create?next=%2Ffi%2Faccount%2Fcustomer    ${url}
    Sleep    1s
    Close All Browsers    
Test_UI_5
    [Documentation]    Search Samsung /click on first product and check if you can find brand "Samsung" in a product information //Mona
    Open Browser    ${URL}    ${Browser}
    Sleep    2sec
    ${keyword}=    Set Variable    Samsung
    Input Text    css:input[type="search"]    ${keyword}
    Sleep    2sec
    Click Button    css:button[aria-label="Hae"]
    Sleep    2sec
    Click Element    css:div.sc-1p6yk7n-0:nth-child(1) > ol:nth-child(1) > li:nth-child(1)
    Sleep    2sec
    Click Element    css:#tabs-page-select-tab1
    Sleep    0.5sec
    ${brand}=    Get Text    css:div.product-details__category:nth-child(1) > table:nth-child(2) > tbody:nth-child(2) > tr:nth-child(1) > td:nth-child(2) > a:nth-child(1)
    Should Be Equal    ${keyword}    ${brand}
    Sleep    1s
    Close All Browsers    
TC_Usability_1
    [Documentation]    From "all new products" select RANDOM filter / Page should contain the extact n numbers of products (n represents a number next to the filter "numberofP") //Dawid
    Open Browser    ${URL}    ${Browser}
    Maximize Browser Window
    Sleep    2sec
    Click Element    css:#allow-cookies
    Click Element    css:a[class="Button-sc-mt7im1-0 sc-1xt0o2a-0 cXWcDq gWbznf"]
    Sleep    2.5sec
    ${filters}=    Get WebElements    css:section>ol>li>label>span>div>span:nth-child(1)
    ${randomFilter}=    Evaluate    random.choice($filters)    random  
    Input Text    css:#filter-title    ${randomFilter.text} 
    Click Element    css:section>ol>li>label>span 
    ${numberofP}=    Get Text    css:section>ol>li>label>span>div>span:nth-child(2)
    Sleep    1.5sec
    ${GetLenght}=    Get WebElements    css:ol[class="sc-15vrf2o-2 gtpmBu"]>li
    ${Length}=    Get Length    ${GetLenght}
    ${n}=    Set Variable    ${0}
    ${selector}=    Set Variable    ${1}
    IF    ${Length} == ${1}
        ${Products}=    Get WebElements    css:div>ol>li>article
        ${ProductsLenght}=    Get Length    ${Products}
        ${n}=    Evaluate    ${n}+${ProductsLenght}
    ELSE
        FOR    ${i}    IN RANGE    1    ${Length}+1    
        ${Products}=    Get WebElements    css:div>ol>li>article
        ${ProductsLenght}=    Get Length    ${Products}
        ${n}=    Evaluate    ${n}+${ProductsLenght}
            IF    ${i} != ${Length}
                ${selector}=    Evaluate    ${selector}+1
                Click Element    css:nav>ol>li:nth-child(${selector})
                Sleep    2sec
            ELSE
                Exit For Loop
            END
        END
    END
    
    Should Be Equal As Strings    ${numberofP}    ${n}
    Sleep    1s
    Close All Browsers    
TC_UI_6
    [Documentation]    Clicking one of the store localizations presented on site/ check if it redirect us to correct page (Helsinki = Verkkokauppa.com Helsinki) //Dawid
    Open Browser    ${URL}    ${Browser}
    Maximize Browser Window
    Sleep    2sec
    Click Element    css:#allow-cookies
    Execute Javascript    window.scrollTo(0, 4444);
    Sleep    1s
    Execute Javascript    window.scrollTo(4444, 9999);
    Sleep    1s
    ${loc}=    Get WebElements    css:aside>div>ul>li
    ${randomloc}=    Evaluate    random.choice($loc)    random
    ${text}=    Get Regexp Matches    ${randomloc.text}    (?<=0 ).*
    Click Element    ${randomloc}
    Page Should Contain    Verkkokauppa.com ${text}[0]
    Sleep    1s
    Close All Browsers   
TC_UI_7
    [Documentation]    Searching keyword Motorola / Filter by price < / Check if the Price is the same in both list and inside the element //Dawid
    Open Browser    ${URL}    ${Browser}
    Maximize Browser Window
    ${keyword}=    Set Variable    Motorola
    Sleep    2sec
    Click Element    css:#allow-cookies
    Input Text    css:input[type="search"]    ${keyword}
    Sleep    2sec
    Click Button    css:button[aria-label="Hae"]
    Sleep    2sec
    Select From List By Value    css:#sort    price:asc
    Sleep    2sec
    ${listPrice}=    Get Text    css:div.sc-1p6yk7n-0:nth-child(1) > ol:nth-child(1) > li:nth-child(1) > article:nth-child(1) > div:nth-child(2) > div:nth-child(1) > div:nth-child(2) > div:nth-child(1) > div:nth-child(3) > h2:nth-child(1) > span:nth-child(1) > data:nth-child(1)
    Click Element    css:div.sc-1p6yk7n-0:nth-child(1) > ol:nth-child(1) > li:nth-child(1)
    Sleep    2sec
    ${priceInside}=    Get Text    css:span.Price-sc-1eckydb-2:nth-child(2) > data:nth-child(1)
    Should Be Equal    ${listPrice}    ${priceInside}
    Sleep    1s
    Close All Browsers
TC_UI_8
    [Documentation]   Test if all product categories have an "landing page" //Nazanin
    Open Browser    ${URL}    ${Browser}
    Sleep    2s
    Click Element    css:#app > div > header > div > label > svg.icon-sc-td2w5n-0.sc-uv1rq8-0.jRbjWq
    Sleep    2s
    ${name}=    Get Text   css:#app > div > div > aside > nav > div > div.sidebar-category-list__content > ul > li:nth-child(1) > a > span.UI-sc-1m8dr2d-12.sc-1tlhs3i-1.kbcdPu.HBsRJ  
    Click Element    css:#app > div > div > aside > nav > div > div.sidebar-category-list__content > ul > li:nth-child(1) > a
    Sleep    1s
    Element Should Contain    css:#main > header > div.sc-l5gsrj-3.leDfDo > h1    ${name}
    Page Should Contain Element    css:#main > header > div.sc-l5gsrj-3.leDfDo > h1 > svg
    Sleep    1s
    Close All Browsers
TC_UI_9
    [Documentation]    Test if we can find our search keyword in a product page / make screenshot of the product //Nazanin
    Open Browser    ${URL}    ${Browser}
    Sleep    2s
    Input Text    css:#app > div > header > div > nav > form > div > input    ps5
    Sleep   1s
    Click Element   css:#app > div > header > div > nav > form > div > div > button.Button-sc-mt7im1-0.IconButton-sc-12838oi-0.sc-93rccr-2.QXKkW.glDAmc.dBrvnp    
    Sleep    2.5s
    Capture Element Screenshot    css:#main > div > div.sc-1tg0wl0-0.sc-1tg0wl0-3.hCkRYa > div:nth-child(1) > ol > li:nth-child(1)
    Click Element    css:#main > div > div.sc-1tg0wl0-0.sc-1tg0wl0-3.hCkRYa > div:nth-child(1) > ol > li:nth-child(1)
    Sleep    1s   
    Run Keyword And Warn On Failure    Page Should Contain        ps5    there is no keyword "ps5"
    Sleep    1s
    Close All Browsers    