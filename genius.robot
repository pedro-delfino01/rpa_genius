*** Settings ***
Library           OperatingSystem
Library           RPA.Browser.Selenium
Library           Collections


*** Tasks ***
Coletar Dados
    [Documentation]    Coleta dados de uma página web
    Open Available Browser    https://genius.com/
    Maximize Browser Window
    ${title}=    Get Title
    Log    Título da página: ${title}
    Click Element When Visible    xpath=//a/span[contains(text(),'Charts')]
    Wait Until Page Contains Element    xpath=//h2[contains(text(),'Charts')]
    WHILE    True    limit=9    on_limit=pass
        TRY
            # Verifica se o botão "Load More" está visível e clica nele,
            ${verify_element}=    Run Keyword And Ignore Error    Is Element Visible    xpath=//div[@id="top-songs"]//div/div[contains(text(),"Load More")]    timeout=10s
            # Scroll Element Into View    xpath=//div[@id="top-songs"]//div/div[contains(text(),"Load More")]
            Click Element When Visible    xpath=//div[@id="top-songs"]//div/div[contains(text(),"Load More")]

        EXCEPT    message
            Log    Erro ao clicar em "Load More".
        END
        
    END
    Scroll Element Into View    xpath=//div[@id="top-songs"]//div[@class="PageGridFull-sc-6a49b2f6-0 iWqdWA"]
    ${count_songs}    Get Element Count    xpath=//div[@id="top-songs"]//div[@class="PageGridFull-sc-6a49b2f6-0 iWqdWA"]/a
    Create File    path=songs_data.csv    content=Position,Title,Artist,URL
    ${song_data}=    Create List
    Log    Total de músicas coletadas: ${count_songs}
    FOR    ${index}    IN RANGE    1    ${count_songs}+1
        ${song_position}    Set Variable    ${index}
        ${song_title}=    Get Text    xpath=//div[@id="top-songs"]//div[@class="PageGridFull-sc-6a49b2f6-0 iWqdWA"]/a[${index}]//h3/div[1]
        ${song_url}=    Get Element Attribute    xpath=//div[@id="top-songs"]//div[@class="PageGridFull-sc-6a49b2f6-0 iWqdWA"]/a[${index}]    href
        ${song_artist}=    Get Text    xpath=//div[@id="top-songs"]//div[@class="PageGridFull-sc-6a49b2f6-0 iWqdWA"]/a[${index}]/h4
        ${line}    Set Variable    ${song_position}, ${song_title}, ${song_artist}, ${song_url}
        Append To List    ${song_data}    ${line}
    END
    Log    Dados coletados: ${song_data}
    FOR    ${line}    IN    @{song_data}
        Log    ${line}
        Append To File    path=songs_data.csv    content=${line}\\n
    END
    Close Browser