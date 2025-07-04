# ══════════════════════════════════════════════════════════════════════════════
# TESTES AUTOMATIZADOS - CINEMA APP - GERENCIAMENTO DE FILMES
# 
# Funcionalidades testadas: CRUD de filmes, controle de autorização
# Endpoints: /movies, /movies/{id} (GET, POST, DELETE)
# Status: Documentação de bugs conhecidos da API
# ══════════════════════════════════════════════════════════════════════════════

*** Settings ***
Library    RequestsLibrary
Library    Collections
Resource    ../../resources/backend/movies.resource
Resource    ../../resources/backend/auth.resource
Resource    ../../variables/api_variables.robot
Resource    ../../variables/global_variables.robot

Suite Setup    Create Session    cinema_api    ${BASE_API_URL}

*** Test Cases ***
MOV-001: Wayne Enterprises Cinema Database Movie Surveillance
    [Tags]    gotham-movies    batman-surveillance    cape-crusader
    [Documentation]    Teste de listagem completa de filmes no endpoint GET /movies
    ${batman_response}=    Get All Movies
    Should Be Equal As Strings    ${batman_response.status_code}    200
    Should Not Be Empty    ${batman_response.json()}
    Log    Cinema App: Listagem de filmes executada com sucesso

MOV-002: Dark Knight's Single Movie Investigation 
    [Tags]    gotham-intel    batman-detective    single-target
    [Documentation]    Teste de busca por filme específico no endpoint GET /movies/{id}
    ${batman_response}=    Get Movie By ID    1
    Should Be Equal As Strings    ${batman_response.status_code}    200
    Dictionary Should Contain Key    ${batman_response.json()['data']}    title
    Log    Cinema App: Busca de filme por ID executada com sucesso

MOV-003: Batman's Investigation of Non-Existent Movie Records
    [Tags]    gotham-security    phantom-investigation    error-handling
    [Documentation]    Teste de validação de erro para filme inexistente no endpoint GET /movies/{id}
    ${batman_response}=    Get Movie By ID    999999
    Should Be Equal As Strings    ${batman_response.status_code}    404
    Log    Cinema App: Validação de filme inexistente executada com sucesso

MOV-004: Wayne Enterprises Executive Movie Creation Protocol
    [Tags]    wayne-admin    gotham-creation    batman-authority
    [Documentation]    Teste de criação de filme por usuário administrador no endpoint POST /movies
    ${bruce_wayne_login}=    Login User    ${ADMIN_EMAIL}    ${ADMIN_PASSWORD}
    ${batman_admin_token}=    Set Variable    ${bruce_wayne_login.json()['data']['token']}
    
    ${new_gotham_movie}=    Create Dictionary
    ...    title=The Dark Knight Returns to Gotham
    ...    director=Christopher Nolan
    ...    synopsis=Batman's epic return to protect Gotham City from new threats
    ...    duration=150
    ...    classification=PG-13
    ...    releaseDate=2024-12-31
    
    ${batman_response}=    Create Movie    ${batman_admin_token}    ${new_gotham_movie}
    Should Be Equal As Strings    ${batman_response.status_code}    201
    Dictionary Should Contain Key    ${batman_response.json()['data']}    _id
    Dictionary Should Contain Key    ${batman_response.json()['data']}    title
    Log    Cinema App: Filme criado com sucesso por usuário administrador

MOV-005: Joker's Failed Attempt to Infiltrate Movie Creation System
    [Tags]    security-test    joker-chaos    unauthorized-access    villain-blocked
    [Documentation]    Teste de controle de autorização - usuário comum não pode criar filmes
    # Validação de segurança: usuários com role 'user' não devem conseguir criar filmes
    
    # Registro de usuário comum para teste de autorização
    ${joker_email}=    Set Variable    joker@gothamcity.com
    ${joker_password}=    Set Variable    WhysoSerious123!
    
    ${joker_registration}=    Register User    Joker    ${joker_email}    ${joker_password}
    Log    Cinema App: Usuário comum registrado para teste de autorização
    
    ${joker_login}=    Login User    ${joker_email}    ${joker_password}
    ${joker_token}=    Set Variable    ${joker_login.json()['data']['token']}
    
    ${chaos_movie}=    Create Dictionary
    ...    title=Chaos in Gotham Cinema
    ...    director=The Joker
    
    ${batman_security_response}=    Create Movie    ${joker_token}    ${chaos_movie}
    Should Be Equal As Strings    ${batman_security_response.status_code}    403
    Dictionary Should Contain Value    ${batman_security_response.json()}    User role user is not authorized to access this route
    Log    Cinema App: Controle de autorização funcionando - usuário comum bloqueado

MOV-006: Batman's Strategic Movie Database Cleanup Operation
    [Tags]    wayne-admin    gotham-cleanup    batman-maintenance
    [Documentation]    Teste de remoção de filme por usuário administrador no endpoint DELETE /movies/{id}
    ${bruce_wayne_login}=    Login User    ${ADMIN_EMAIL}    ${ADMIN_PASSWORD}
    ${batman_admin_token}=    Set Variable    ${bruce_wayne_login.json()['data']['token']}
    
    # Criação de filme temporário para teste de remoção
    ${temporary_gotham_movie}=    Create Dictionary
    ...    title=Temporary Gotham Movie Entry
    ...    director=Test Director
    ...    synopsis=Temporary entry for Batman's database maintenance test
    ...    duration=90
    ...    classification=PG
    ...    releaseDate=2024-01-01
    
    ${batman_create_response}=    Create Movie    ${batman_admin_token}    ${temporary_gotham_movie}
    Should Be Equal As Strings    ${batman_create_response.status_code}    201
    ${target_movie_id}=    Set Variable    ${batman_create_response.json()['data']['_id']}
    
    # Remoção do filme criado para teste da funcionalidade DELETE
    ${batman_cleanup_response}=    Delete Movie    ${batman_admin_token}    ${target_movie_id}
    Should Be Equal As Strings    ${batman_cleanup_response.status_code}    200
    Dictionary Should Contain Value    ${batman_cleanup_response.json()}    Movie removed
    Log    Cinema App: Filme removido com sucesso por usuário administrador

MOV-007: Penguin's Failed Database Sabotage Attempt
    [Tags]    security-test    penguin-villain    database-protection    villain-blocked
    [Documentation]    Teste de controle de autorização - usuário comum não pode deletar filmes
    # Validação de segurança: usuários com role 'user' não devem conseguir deletar filmes
    
    # Registro de usuário comum para teste de autorização de remoção
    ${penguin_email}=    Set Variable    penguin@iceberg-lounge.com
    ${penguin_password}=    Set Variable    UmbrellaGang123!
    
    ${penguin_registration}=    Register User    Oswald Cobblepot    ${penguin_email}    ${penguin_password}
    Log    Cinema App: Usuário comum registrado para teste de autorização de remoção
    
    ${penguin_login}=    Login User    ${penguin_email}    ${penguin_password}
    ${penguin_token}=    Set Variable    ${penguin_login.json()['data']['token']}
    
    ${batman_security_response}=    Delete Movie    ${penguin_token}    685c2d5cf34317e7520c4285
    Should Be Equal As Strings    ${batman_security_response.status_code}    403
    Dictionary Should Contain Value    ${batman_security_response.json()}    User role user is not authorized to access this route
    Log    Cinema App: Controle de autorização funcionando - usuário comum bloqueado de deletar filmes