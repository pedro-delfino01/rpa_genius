*** Settings ***
Library           OperatingSystem
Library           RPA.Browser.Selenium
Library           Collections
Library           DateTime
Library           RPA.Excel.Files
Library           String

*** Tasks ***
Coletar Dados do Genius
    [Documentation]    Coleta dados de músicas do site Genius e salva em arquivos CSV e Excel
    [Tags]    coleta    genius
    TRY
        ${data_execution}    Get Execution Date
        Log    Data de execução: ${data_execution}
        ${lista_dados_csv}    ${lista_dados_xlsx}    Coletar Dados
        Create CSV File    ${data_execution}    ${lista_dados_csv}
        Create Excel File    ${data_execution}    ${lista_dados_xlsx}
    EXCEPT
        Fail    Erro durante a execução.
    END


*** Keywords ***
Coletar Dados
    [Documentation]    Coleta dados de uma página web
    ${list_xlsx}=    Create List
    ${song_data_csv}=    Create List
    ${song_data_xlsx}=    Create List
    Open Available Browser    https://genius.com/
    Maximize Browser Window
    ${title}=    Get Title
    Click Element When Visible    xpath=//a/span[contains(text(),'Charts')]
    Wait Until Page Contains Element    xpath=//h2[contains(text(),'Charts')]
    WHILE    True
        TRY
            # Verifica se o botão "Load More" está visível e clica nele,
            ${verify_element}=    Run Keyword And Ignore Error    Is Element Visible    xpath=//div[@id="top-songs"]//div/div[contains(text(),"Load More")]    timeout=10s
            IF    $verify_element[1] == $True
                Scroll Element Into View    xpath=//div[@id="top-songs"]//div/div[contains(text(),"Load More")]
                Click Element When Visible    xpath=//div[@id="top-songs"]//div/div[contains(text(),"Load More")]
            ELSE
                Log    Botão "Load More" não encontrado ou não está habilitado.
            END
            Scroll Element Into View    xpath=//h2[contains(text(), "Videos")]
            ${count_songs}    Get Element Count    xpath=//div[@id="top-songs"]//div[@class="PageGridFull-sc-6a49b2f6-0 iWqdWA"]/a
            IF    $count_songs == 100
                BREAK
            END
        EXCEPT
            Log    Erro ao clicar em "Load More".
        END
        
    END
    Scroll Element Into View    xpath=//div[@id="top-songs"]//div[@class="PageGridFull-sc-6a49b2f6-0 iWqdWA"]
    ${count_songs}    Get Element Count    xpath=//div[@id="top-songs"]//div[@class="PageGridFull-sc-6a49b2f6-0 iWqdWA"]/a
    Log    Total de músicas coletadas: ${count_songs}
    FOR    ${index}    IN RANGE    1    ${count_songs}+1
        ${song_position}    Set Variable    ${index}
        # Scroll Element Into View    locator=xpath=//div[@id="top-songs"]//div[@class="PageGridFull-sc-6a49b2f6-0 iWqdWA"]/a[${index}]
        ${song_title}=    Get Text    xpath=//div[@id="top-songs"]//div[@class="PageGridFull-sc-6a49b2f6-0 iWqdWA"]/a[${index}]//h3/div[1]
        ${song_url}=    Get Element Attribute    xpath=//div[@id="top-songs"]//div[@class="PageGridFull-sc-6a49b2f6-0 iWqdWA"]/a[${index}]    href
        ${song_artist}=    Get Text    xpath=//div[@id="top-songs"]//div[@class="PageGridFull-sc-6a49b2f6-0 iWqdWA"]/a[${index}]/h4
        ${song_data_xlsx}    Create List    ${song_position}    ${song_title}    ${song_artist}    ${song_url}
        Log    ${song_data_xlsx}
        ${line_csv}    Set Variable    ${song_position}, '${song_title}', '${song_artist}', '${song_url}'
        Append To List    ${list_xlsx}    ${song_data_xlsx}
        Append To List    ${song_data_csv}    ${line_csv}
    END
    Close Browser
    RETURN    ${song_data_csv}    ${list_xlsx}

Get Execution Date
    [Documentation]    Obtém a data de execução formatada
    ${date}    Get Current Date    result_format=%d-%m-%Y_%H-%M-%S
    RETURN    ${date}

Create CSV File
    [Documentation]    Cria um arquivo CSV com os dados coletados
    [Arguments]    ${data_execution}    ${song_data}    
    Create File    path=data/songs_data_${data_execution}.csv    content=Position,Title,Artist,URL\n
    FOR    ${line}    IN    @{song_data}
        Append To File    path=data/songs_data_${data_execution}.csv    content=${line}\n
    END

Create Excel File
    [Documentation]    Cria um arquivo Excel com os dados coletados
    [Arguments]    ${data_execution}    ${song_data}
    ${directory}    Run Keyword and Ignore Error    Directory Should Exist    path=excel
    IF    '${directory}[0]' == 'FAIL'
        Create Directory    path=excel
    END
    ${path}    Set Variable    excel/songs_data_${data_execution}.xlsx
    Create Workbook    path=${CURDIR}/excel/songs_data_${data_execution}.xlsx
    Set Cell Value    row=1    column=A    value=Position
    Set Cell Value    row=1    column=B    value=Title
    Set Cell Value    row=1    column=C    value=Artist
    Set Cell Value    row=1    column=D    value=URL
    FOR    ${line}    IN    @{song_data}
        ${empty_row}    Find Empty Row
        ${song_position}=    Get From List    ${line}    0
        ${song_title}=    Get From List    ${line}    1
        ${song_artist}=    Get From List    ${line}    2
        ${song_url}=    Get From List    ${line}    3
        Set Cell Value    row=${empty_row}    column=A    value=${song_position}
        Set Cell Value    row=${empty_row}    column=B    value=${song_title}
        Set Cell Value    row=${empty_row}    column=C    value=${song_artist}
        Set Cell Value    row=${empty_row}    column=D    value=${song_url}
    END
    Save Workbook
    Close Workbook