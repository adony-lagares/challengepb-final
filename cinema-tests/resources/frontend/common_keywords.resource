*** Settings ***
Library    Browser
Resource   ../../variables/global_variables.robot
Resource   ../../variables/api_variables.robot

*** Keywords ***
Iniciar Navegador
    New Browser    chromium    headless=false
    New Context    viewport={'width': 1920, 'height': 1080}
    New Page    ${BASE_WEB_URL}

Encerrar Navegador
    Close Browser

Esperar E Clicar
    [Arguments]    ${locator}
    Wait For Elements State    ${locator}    visible    timeout=10s
    Click    ${locator}

Gerar Email Aleatorio
    ${random}=    Generate Random String    8    [LETTERS][NUMBERS]
    ${email}=    Set Variable    test_${random}@example.com
    RETURN    ${email}

Aguardar Elemento
    [Arguments]    ${locator}    ${timeout}=10s
    Wait For Elements State    ${locator}    visible    timeout=${timeout}

Preencher Campo
    [Arguments]    ${locator}    ${texto}
    Wait For Elements State    ${locator}    visible    timeout=10s
    Fill Text    ${locator}    ${texto}

Verificar Texto Na Pagina
    [Arguments]    ${texto}
    Wait For Elements State    text=${texto}    visible    timeout=10s