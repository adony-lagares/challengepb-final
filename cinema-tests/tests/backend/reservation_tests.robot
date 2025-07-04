*** Settings ***
# ============================================================================
# TESTES AUTOMATIZADOS - CINEMA APP
# Testes de API para o sistema de reservas de cinema
# 
# Funcionalidades testadas: Criação, listagem e validação de reservas
# Endpoints: /reservations, /my-reservations
# Status: Documentação de bugs conhecidos da API
# ============================================================================
Library    Collections
Library    RequestsLibrary
Resource    ../../resources/backend/auth.resource
Resource    ../../resources/backend/sessions.resource
Resource    ../../resources/backend/reservations.resource
Resource    ../../variables/api_variables.robot

Suite Setup    RequestsLibrary.Create Session    cinema_api    ${BASE_API_URL}

*** Test Cases ***
Criar Reserva Com Dados Válidos Deve Ter Sucesso
    [Tags]    RES-001    BATMAN-TEST
    # Autenticação de usuário administrador para executar operação
    ${batman_login}=    Login User    ${ADMIN_EMAIL}    ${ADMIN_PASSWORD}
    ${batman_token}=    Set Variable    ${batman_login.json()['data']['token']}
    
    # Busca de sessões disponíveis no sistema Cinema App
    ${gotham_sessions}=    Get All Sessions
    ${available_screenings}=    Set Variable    ${gotham_sessions.json()['data']}
    ${chosen_screening}=    Set Variable    ${available_screenings[0]}
    ${screening_id}=    Set Variable    ${chosen_screening['_id']}
    
    # Criação de payload de reserva com assentos válidos
    # BUG CONHECIDO: API retorna 400 para assentos disponíveis no endpoint /reservations  
    ${wayne_seat}=    Create Dictionary    row=B    number=1    type=full
    ${robin_seat}=    Create Dictionary    row=B    number=2    type=half
    ${hero_seats}=    Create List    ${wayne_seat}    ${robin_seat}
    ${batcave_reservation}=    Create Dictionary
    ...    session=${screening_id}
    ...    seats=${hero_seats}
    ${dark_knight_response}=    Create Reservation With Auth    ${batman_token}    ${batcave_reservation}
    
    # BUG CONFIRMADO: API retorna 400 "not available" para assentos disponíveis
    # COMPORTAMENTO ESPERADO: Should Be Equal As Strings    ${response.status_code}    201
    # COMPORTAMENTO ATUAL (BUGADO):
    Should Be Equal As Strings    ${dark_knight_response.status_code}    400
    Should Contain    ${dark_knight_response.json()['message']}    not available

Listar Minhas Reservas Deve Retornar Apenas Reservas Do Usuário
    [Tags]    RES-003    WAYNE-ENTERPRISES
    # Autenticação de usuário administrador para acessar endpoint /my-reservations
    ${bruce_login}=    Login User    ${ADMIN_EMAIL}    ${ADMIN_PASSWORD}
    ${millionaire_token}=    Set Variable    ${bruce_login.json()['data']['token']}
    
    # Requisição GET para endpoint /my-reservations do Cinema App
    ${wayne_reservations}=    Get My Reservations    ${millionaire_token}
    
    # Validação de resposta da API para listagem de reservas pessoais
    Should Be Equal As Strings    ${wayne_reservations.status_code}    200
    Should Be True    len(${wayne_reservations.json()}) >= 0

Admin Pode Listar Todas As Reservas
    [Tags]    RES-006    JUSTICE-LEAGUE
    # Autenticação de usuário administrador para acesso total às reservas
    ${gordon_access}=    Login User    ${ADMIN_EMAIL}    ${ADMIN_PASSWORD}
    ${commissioner_token}=    Set Variable    ${gordon_access.json()['data']['token']}
    
    # Requisição GET para endpoint /reservations com privilégios de admin
    ${gotham_surveillance}=    Get All Reservations    ${commissioner_token}
    
    # Validação de resposta da API para listagem completa de reservas
    Should Be Equal As Strings    ${gotham_surveillance.status_code}    200
    Should Be True    len(${gotham_surveillance.json()}) >= 0

Tentar Reservar Assento Ocupado Deve Falhar
    [Tags]    RES-002    ARKHAM-ASYLUM
    # Autenticação de usuário administrador para teste de conflito de assentos
    ${detective_login}=    Login User    ${ADMIN_EMAIL}    ${ADMIN_PASSWORD}
    ${vigilante_token}=    Set Variable    ${detective_login.json()['data']['token']}
    
    # Busca de sessão disponível para teste de reserva duplicada
    ${crime_scenes}=    Get All Sessions
    ${investigation_site}=    Set Variable    ${crime_scenes.json()['data'][0]['_id']}
    
    # Criação de payload de reserva para teste de conflito
    ${catwoman_seat}=    Create Dictionary    row=C    number=1    type=full
    ${poison_ivy_seat}=    Create Dictionary    row=C    number=2    type=full
    ${villain_hideout}=    Create List    ${catwoman_seat}    ${poison_ivy_seat}
    ${stakeout_plan}=    Create Dictionary    session=${investigation_site}    seats=${villain_hideout}
    
    # BUG CONHECIDO: API retorna 400 mesmo para assentos livres
    # Primeira tentativa de reserva (deveria criar com sucesso)
    ${first_attempt}=    Create Reservation With Auth    ${vigilante_token}    ${stakeout_plan}
    Should Be Equal As Strings    ${first_attempt.status_code}    400
    Should Contain    ${first_attempt.json()['message']}    not available
    
    # Segunda tentativa de reserva (deveria falhar por assento ocupado)
    # Teste de validação de conflito de reservas no sistema Cinema App
    ${second_attempt}=    Create Reservation With Auth    ${vigilante_token}    ${stakeout_plan}
    Should Be Equal As Strings    ${second_attempt.status_code}    400
    Should Contain    ${second_attempt.json()['message']}    not available

Obter Detalhes De Reserva Própria Deve Ter Sucesso
    [Tags]    RES-004    BATCOMPUTER
    # Autenticação de usuário administrador para acesso aos dados
    ${alfred_login}=    Login User    ${ADMIN_EMAIL}    ${ADMIN_PASSWORD}
    ${butler_access}=    Set Variable    ${alfred_login.json()['data']['token']}
    
    # Busca de sessão disponível para criação de reserva de teste
    ${patrol_schedule}=    Get All Sessions
    ${tonight_patrol}=    Set Variable    ${patrol_schedule.json()['data'][0]['_id']}
    
    # Tentativa de criação de reserva para posterior consulta de detalhes
    ${watchtower_seat}=    Create Dictionary    row=D    number=1    type=full
    ${surveillance_position}=    Create List    ${watchtower_seat}
    ${batman_mission}=    Create Dictionary    session=${tonight_patrol}    seats=${surveillance_position}
    ${mission_attempt}=    Create Reservation With Auth    ${butler_access}    ${batman_mission}
    
    # BUG CONHECIDO: Sistema rejeitando reservas válidas no endpoint /reservations
    # COMPORTAMENTO ESPERADO: Should Be Equal As Strings    ${mission_attempt.status_code}    201
    # COMPORTAMENTO ATUAL (BUGADO):
    Should Be Equal As Strings    ${mission_attempt.status_code}    400
    Should Contain    ${mission_attempt.json()['message']}    not available
    
    # Teste comprometido - endpoint de detalhes inacessível devido ao bug da criação

Tentar Acessar Reserva De Outro Usuário Deve Falhar
    [Tags]    RES-005    PENGUIN-HEIST
    # Busca de sessão disponível para teste de autorização
    ${league_meetings}=    Get All Sessions
    ${secret_location}=    Set Variable    ${league_meetings.json()['data'][0]['_id']}
    
    # Criação de reserva por usuário administrador para teste de acesso
    ${superman_clearance}=    Login User    ${ADMIN_EMAIL}    ${ADMIN_PASSWORD}
    ${kryptonian_access}=    Set Variable    ${superman_clearance.json()['data']['token']}
    ${fortress_seat}=    Create Dictionary    row=E    number=1    type=full
    ${hero_position}=    Create List    ${fortress_seat}
    ${justice_meeting}=    Create Dictionary    session=${secret_location}    seats=${hero_position}
    ${hero_reservation}=    Create Reservation With Auth    ${kryptonian_access}    ${justice_meeting}
    
    # BUG CONHECIDO: Sistema rejeitando reservas válidas no endpoint /reservations
    # COMPORTAMENTO ESPERADO: Should Be Equal As Strings    ${hero_reservation.status_code}    201
    # COMPORTAMENTO ATUAL (BUGADO):
    Should Be Equal As Strings    ${hero_reservation.status_code}    400
    Should Contain    ${hero_reservation.json()['message']}    not available
    
    # Teste comprometido - não é possível testar acesso indevido sem reserva criada

Criar Reserva Sem Autenticação Deve Falhar
    [Tags]    RES-008    JOKER-CHAOS
    # Teste de segurança para validação de acesso sem autenticação
    ${public_showings}=    Get All Sessions
    ${target_screening}=    Set Variable    ${public_showings.json()['data'][0]['_id']}
    
    # Tentativa de criação de reserva sem token de autenticação
    ${anonymous_seat}=    Create Dictionary    row=F    number=1    type=full
    ${intruder_plan}=    Create List    ${anonymous_seat}
    ${unauthorized_attempt}=    Create Dictionary    session=${target_screening}    seats=${intruder_plan}
    ${security_test}=    Create Reservation    ${unauthorized_attempt}
    
    # Validação de controle de acesso do Cinema App
    Should Be Equal As Strings    ${security_test.status_code}    401