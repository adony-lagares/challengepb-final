*** Settings ***
Library    RequestsLibrary
Library    String
Resource   ../../variables/api_variables.robot
Resource   ../../variables/global_variables.robot

*** Keywords ***

Status Deve Ser
    [Arguments]    ${status_esperado}    ${response}
    Should Be Equal As Strings    ${response.status_code}    ${status_esperado}

    
Obter Sessoes Do Filme
    [Arguments]    ${id_filme}
    ${params}=    Create Dictionary    movie=${id_filme}
    ${response}=    GET    ${BASE_API_URL}${SESSIONS_ENDPOINT}    params=${params}    expected_status=any
    RETURN    ${response}

Obter Sessao Por ID
    [Arguments]    ${id_sessao}
    ${response}=    GET    ${BASE_API_URL}${SESSIONS_ENDPOINT}/${id_sessao}
    RETURN    ${response}

Criar Sessao
    [Arguments]    ${dados_sessao}
    ${response}=    POST    ${BASE_API_URL}${SESSIONS_ENDPOINT}    json=${dados_sessao}
    RETURN    ${response}

Obter Todas As Sessoes
    ${response}=    GET    ${BASE_API_URL}${SESSIONS_ENDPOINT}
    RETURN    ${response}

Criar Sessao Com Autenticacao
    [Arguments]    ${token}    ${dados_sessao}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token}
    ${response}=    POST    ${BASE_API_URL}${SESSIONS_ENDPOINT}    json=${dados_sessao}    headers=${headers}    expected_status=any
    RETURN    ${response}

Resetar Assentos Da Sessao
    [Arguments]    ${token}    ${id_sessao}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token}
    ${url}=    Replace String    ${RESET_SEATS_ENDPOINT}    {id}    ${id_sessao}
    ${response}=    PUT    ${BASE_API_URL}${url}    headers=${headers}    expected_status=any
    RETURN    ${response}

# Aliases para compatibilidade
Get Movie Sessions
    [Arguments]    ${movie_id}
    ${response}=    Obter Sessoes Do Filme    ${movie_id}
    RETURN    ${response}

Get Session By ID
    [Arguments]    ${session_id}
    ${response}=    Obter Sessao Por ID    ${session_id}
    RETURN    ${response}

Create Session
    [Arguments]    ${session_data}
    ${response}=    Criar Sessao    ${session_data}
    RETURN    ${response}

Get All Sessions
    ${response}=    Obter Todas As Sessoes
    RETURN    ${response}

Create Session With Auth
    [Arguments]    ${token}    ${session_data}
    ${response}=    Criar Sessao Com Autenticacao    ${token}    ${session_data}
    RETURN    ${response}

Reset Session Seats
    [Arguments]    ${token}    ${session_id}
    ${response}=    Resetar Assentos Da Sessao    ${token}    ${session_id}
    RETURN    ${response}