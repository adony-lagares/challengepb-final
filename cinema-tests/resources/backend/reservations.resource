*** Settings ***
Library    RequestsLibrary
Library    String
Resource   ../../variables/api_variables.robot
Resource   ../../variables/global_variables.robot

*** Keywords ***

Criar Reserva
    [Arguments]    ${dados_reserva}
    ${response}=    POST    ${BASE_API_URL}${RESERVATIONS_ENDPOINT}    json=${dados_reserva}    expected_status=any
    RETURN    ${response}

Obter Reservas Do Usuario
    [Arguments]    ${id_usuario}
    ${response}=    GET    ${BASE_API_URL}${RESERVATIONS_ENDPOINT}?user_id=${id_usuario}
    RETURN    ${response}

Cancelar Reserva
    [Arguments]    ${id_reserva}
    ${response}=    DELETE    ${BASE_API_URL}${RESERVATIONS_ENDPOINT}/${id_reserva}
    RETURN    ${response}

Criar Reserva Com Autenticacao
    [Arguments]    ${token}    ${dados_reserva}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token}
    ${response}=    POST    ${BASE_API_URL}${RESERVATIONS_ENDPOINT}    json=${dados_reserva}    headers=${headers}    expected_status=any
    RETURN    ${response}

Obter Todas As Reservas
    [Arguments]    ${token}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token}
    ${response}=    GET    ${BASE_API_URL}${RESERVATIONS_ENDPOINT}    headers=${headers}    expected_status=any
    RETURN    ${response}

Obter Minhas Reservas
    [Arguments]    ${token}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token}
    ${response}=    GET    ${BASE_API_URL}${RESERVATIONS_ME_ENDPOINT}    headers=${headers}    expected_status=any
    RETURN    ${response}

Obter Reserva Por ID
    [Arguments]    ${token}    ${id_reserva}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token}
    ${url}=    Replace String    ${RESERVATIONS_ID_ENDPOINT}    {id}    ${id_reserva}
    ${response}=    GET    ${BASE_API_URL}${url}    headers=${headers}    expected_status=any
    RETURN    ${response}

# Aliases para compatibilidade
Create Reservation
    [Arguments]    ${reservation_data}
    ${response}=    Criar Reserva    ${reservation_data}
    RETURN    ${response}

Get User Reservations
    [Arguments]    ${user_id}
    ${response}=    Obter Reservas Do Usuario    ${user_id}
    RETURN    ${response}

Cancel Reservation
    [Arguments]    ${reservation_id}
    ${response}=    Cancelar Reserva    ${reservation_id}
    RETURN    ${response}

Create Reservation With Auth
    [Arguments]    ${token}    ${reservation_data}
    ${response}=    Criar Reserva Com Autenticacao    ${token}    ${reservation_data}
    RETURN    ${response}

Get All Reservations
    [Arguments]    ${token}
    ${response}=    Obter Todas As Reservas    ${token}
    RETURN    ${response}

Get My Reservations
    [Arguments]    ${token}
    ${response}=    Obter Minhas Reservas    ${token}
    RETURN    ${response}

Get Reservation By ID
    [Arguments]    ${token}    ${reservation_id}
    ${response}=    Obter Reserva Por ID    ${token}    ${reservation_id}
    RETURN    ${response}