*** Settings ***
Library    RequestsLibrary
Library    String
Resource   ../../variables/api_variables.robot
Resource   ../../variables/global_variables.robot

*** Keywords ***

Status Deve Ser
    [Arguments]    ${status_esperado}    ${response}
    Should Be Equal As Strings    ${response.status_code}    ${status_esperado}
    
Obter Todas As Salas
    ${response}=    GET    ${BASE_API_URL}${THEATERS_ENDPOINT}    expected_status=any
    RETURN    ${response}

Obter Sala Por ID
    [Arguments]    ${id_sala}
    ${response}=    GET    ${BASE_API_URL}${THEATERS_ENDPOINT}/${id_sala}    expected_status=any
    RETURN    ${response}

Obter Assentos Da Sala
    [Arguments]    ${id_sala}
    ${response}=    GET    ${BASE_API_URL}${THEATERS_ENDPOINT}/${id_sala}/seats    expected_status=any
    RETURN    ${response}

Criar Sala
    [Arguments]    ${token}    ${dados_sala}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token}
    ${response}=    POST    ${BASE_API_URL}${THEATERS_ENDPOINT}    json=${dados_sala}    headers=${headers}    expected_status=any
    RETURN    ${response}

Atualizar Sala
    [Arguments]    ${token}    ${id_sala}    ${dados_sala}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token}
    ${url}=    Replace String    ${THEATERS_ID_ENDPOINT}    {id}    ${id_sala}
    ${response}=    PUT    ${BASE_API_URL}${url}    json=${dados_sala}    headers=${headers}    expected_status=any
    RETURN    ${response}

Deletar Sala
    [Arguments]    ${token}    ${id_sala}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token}
    ${url}=    Replace String    ${THEATERS_ID_ENDPOINT}    {id}    ${id_sala}
    ${response}=    DELETE    ${BASE_API_URL}${url}    headers=${headers}    expected_status=any
    RETURN    ${response}