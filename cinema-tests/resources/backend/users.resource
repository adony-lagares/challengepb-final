*** Settings ***
Library    RequestsLibrary
Library    String
Resource   ../../variables/api_variables.robot
Resource   ../../variables/global_variables.robot

*** Keywords ***

Status Deve Ser
    [Arguments]    ${status_esperado}    ${response}
    Should Be Equal As Strings    ${response.status_code}    ${status_esperado}

    
Criar Usuario
    [Arguments]    ${dados_usuario}
    ${response}=    POST    ${BASE_API_URL}${USERS_ENDPOINT}    json=${dados_usuario}    expected_status=any
    RETURN    ${response}

Obter Perfil Do Usuario Por ID
    [Arguments]    ${id_usuario}
    ${response}=    GET    ${BASE_API_URL}${USERS_ENDPOINT}/${id_usuario}    expected_status=any
    RETURN    ${response}

Atualizar Perfil Do Usuario Por ID
    [Arguments]    ${id_usuario}    ${dados_usuario}
    ${response}=    PUT    ${BASE_API_URL}${USERS_ENDPOINT}/${id_usuario}    json=${dados_usuario}    expected_status=any
    RETURN    ${response}

Obter Todos Os Usuarios
    [Arguments]    ${token}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token}
    ${response}=    GET    ${BASE_API_URL}${USERS_ENDPOINT}    headers=${headers}    expected_status=any
    RETURN    ${response}

Atualizar Usuario Como Admin
    [Arguments]    ${token}    ${id_usuario}    ${dados_usuario}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token}
    ${response}=    PUT    ${BASE_API_URL}${USERS_ENDPOINT}/${id_usuario}    json=${dados_usuario}    headers=${headers}    expected_status=any
    RETURN    ${response}

Deletar Usuario
    [Arguments]    ${token}    ${id_usuario}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token}
    ${response}=    DELETE    ${BASE_API_URL}${USERS_ENDPOINT}/${id_usuario}    headers=${headers}    expected_status=any
    RETURN    ${response}

# Aliases para compatibilidade
Create User
    [Arguments]    ${user_data}
    ${response}=    Criar Usuario    ${user_data}
    RETURN    ${response}

Get User Profile
    [Arguments]    ${user_id}
    ${response}=    Obter Perfil Do Usuario Por ID    ${user_id}
    RETURN    ${response}

Update User Profile
    [Arguments]    ${user_id}    ${user_data}
    ${response}=    Atualizar Perfil Do Usuario Por ID    ${user_id}    ${user_data}
    RETURN    ${response}

Get All Users
    [Arguments]    ${token}
    ${response}=    Obter Todos Os Usuarios    ${token}
    RETURN    ${response}

Update User By Admin
    [Arguments]    ${token}    ${user_id}    ${user_data}
    ${response}=    Atualizar Usuario Como Admin    ${token}    ${user_id}    ${user_data}
    RETURN    ${response}

Delete User
    [Arguments]    ${token}    ${user_id}
    ${response}=    Deletar Usuario    ${token}    ${user_id}
    RETURN    ${response}