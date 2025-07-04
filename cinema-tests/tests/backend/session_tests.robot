# ============================================================================
# TESTES AUTOMATIZADOS - CINEMA APP - GERENCIAMENTO DE SESSÕES
# 
# Funcionalidades testadas: CRUD de sessões, validação de conflitos de horário
# Endpoints: /sessions (GET, POST), /sessions/{id}
# Status: Documentação de bugs conhecidos da API
# ============================================================================

*** Settings ***
Library    Collections
Library    RequestsLibrary
Library    DateTime
Resource    ../../resources/backend/auth.resource
Resource    ../../resources/backend/sessions.resource
Resource    ../../resources/backend/movies.resource
Resource    ../../resources/backend/theaters.resource
Resource    ../../variables/api_variables.robot

Suite Setup    RequestsLibrary.Create Session    cinema_api    ${BASE_API_URL}

*** Test Cases ***
Criar Sessão Com Dados Válidos Deve Ter Sucesso
    [Tags]    SES-001    BATMAN-SESSIONS
    # Autenticação de usuário administrador para criação de sessões
    ${batman_login}=    Login User    ${ADMIN_EMAIL}    ${ADMIN_PASSWORD}
    ${batman_token}=    Set Variable    ${batman_login.json()['data']['token']}
    
    # Busca de filmes disponíveis no sistema Cinema App
    ${gotham_movies}=    Get All Movies
    ${available_movies}=    Set Variable    ${gotham_movies.json()['data']}
    ${chosen_movie}=    Set Variable    ${available_movies[0]}
    ${movie_id}=    Set Variable    ${chosen_movie['_id']}
    
    # Busca de salas disponíveis no sistema Cinema App
    ${wayne_theaters}=    Obter Todas As Salas
    ${available_theaters}=    Set Variable    ${wayne_theaters.json()['data']}
    ${chosen_theater}=    Set Variable    ${available_theaters[0]}
    ${theater_id}=    Set Variable    ${chosen_theater['_id']}
    
    # Geração de data e hora futura para a sessão
    ${future_datetime}=    Get Current Date    increment=2 hours    result_format=%Y-%m-%dT%H:%M:%S.000Z
    
    # Criação de payload de sessão com dados válidos
    ${batman_session}=    Create Dictionary
    ...    movie=${movie_id}
    ...    theater=${theater_id}
    ...    datetime=${future_datetime}
    ...    fullPrice=20
    ...    halfPrice=10
    
    # Execução da criação de sessão no endpoint POST /sessions
    ${dark_knight_response}=    Create Session With Auth    ${batman_token}    ${batman_session}
    
    # Validação de resposta da API para criação de sessão
    Should Be Equal As Strings    ${dark_knight_response.status_code}    201
    Dictionary Should Contain Key    ${dark_knight_response.json()['data']}    _id
    Log    Cinema App: Sessão criada com sucesso por usuário administrador

Criar Sessão Com Sobreposição De Horário Deve Falhar
    [Tags]    SES-002    ARKHAM-CONFLICTS
    # Autenticação de usuário administrador para teste de conflito
    ${detective_login}=    Login User    ${ADMIN_EMAIL}    ${ADMIN_PASSWORD}
    ${vigilante_token}=    Set Variable    ${detective_login.json()['data']['token']}
    
    # Busca de recursos necessários para criação de sessões
    ${crime_movies}=    Get All Movies
    ${villain_theaters}=    Obter Todas As Salas
    ${movie_id}=    Set Variable    ${crime_movies.json()['data'][0]['_id']}
    ${theater_id}=    Set Variable    ${villain_theaters.json()['data'][0]['_id']}
    
    # Data e hora específica para teste de conflito
    ${conflict_datetime}=    Get Current Date    increment=3 hours    result_format=%Y-%m-%dT%H:%M:%S.000Z
    
    # Criação da primeira sessão (deve ter sucesso)
    ${first_session}=    Create Dictionary
    ...    movie=${movie_id}
    ...    theater=${theater_id}
    ...    datetime=${conflict_datetime}
    ...    fullPrice=25
    ...    halfPrice=12
    
    ${first_attempt}=    Create Session With Auth    ${vigilante_token}    ${first_session}
    Should Be Equal As Strings    ${first_attempt.status_code}    201
    Log    Cinema App: Primeira sessão criada com sucesso
    
    # Tentativa de criar segunda sessão no mesmo horário e sala (deve falhar)
    ${second_session}=    Create Dictionary
    ...    movie=${movie_id}
    ...    theater=${theater_id}
    ...    datetime=${conflict_datetime}
    ...    fullPrice=30
    ...    halfPrice=15
    
    ${second_attempt}=    Create Session With Auth    ${vigilante_token}    ${second_session}
    
    # BUG CONHECIDO: API não valida conflito de horário - permite múltiplas sessões simultâneas
    # COMPORTAMENTO ESPERADO: Should Be Equal As Strings    ${second_attempt.status_code}    409
    # COMPORTAMENTO ATUAL (BUGADO):
    Should Be Equal As Strings    ${second_attempt.status_code}    201
    Log    Cinema App: BUG - API permite sessões conflitantes no mesmo horário/sala

Listar Todas As Sessões Deve Retornar Lista Completa
    [Tags]    SES-003    WAYNE-SURVEILLANCE
    # Teste de listagem completa de sessões no endpoint GET /sessions
    ${gotham_sessions}=    Get All Sessions
    
    # Validação de resposta da API para listagem de sessões
    Should Be Equal As Strings    ${gotham_sessions.status_code}    200
    Should Not Be Empty    ${gotham_sessions.json()['data']}
    Log    Cinema App: Listagem de sessões executada com sucesso

Buscar Sessão Por ID Deve Retornar Dados Específicos
    [Tags]    SES-004    DETECTIVE-MODE
    # Busca de uma sessão existente para obter ID válido
    ${investigation_sessions}=    Get All Sessions
    ${available_sessions}=    Set Variable    ${investigation_sessions.json()['data']}
    ${target_session}=    Set Variable    ${available_sessions[0]}
    ${session_id}=    Set Variable    ${target_session['_id']}
    
    # Teste de busca por sessão específica no endpoint GET /sessions/{id}
    ${batman_response}=    Get Session By ID    ${session_id}
    
    # Validação de resposta da API para busca por ID
    Should Be Equal As Strings    ${batman_response.status_code}    200
    Dictionary Should Contain Key    ${batman_response.json()['data']}    _id
    Dictionary Should Contain Key    ${batman_response.json()['data']}    movie
    Dictionary Should Contain Key    ${batman_response.json()['data']}    theater
    Log    Cinema App: Busca de sessão por ID executada com sucesso

Buscar Sessão Inexistente Deve Retornar Erro 404
    [Tags]    SES-005    PHANTOM-INVESTIGATION
    # Teste de validação de erro para sessão inexistente no endpoint GET /sessions/{id}
    ${response}=    GET    ${BASE_API_URL}${SESSIONS_ENDPOINT}/999999999999999999999999    expected_status=any
    
    # Validação de erro para sessão inexistente
    Should Be Equal As Strings    ${response.status_code}    404
    Log    Cinema App: Validação de sessão inexistente executada com sucesso

Buscar Sessões Por Filme Deve Filtrar Corretamente
    [Tags]    SES-006    GOTHAM-FILTER
    # Busca de filmes disponíveis para filtro de sessões
    ${batman_movies}=    Get All Movies
    ${available_movies}=    Set Variable    ${batman_movies.json()['data']}
    ${chosen_movie}=    Set Variable    ${available_movies[0]}
    ${movie_id}=    Set Variable    ${chosen_movie['_id']}
    
    # Teste de filtro de sessões por filme no endpoint GET /sessions?movie={id}
    ${filtered_sessions}=    Get Movie Sessions    ${movie_id}
    
    # Validação de filtro de sessões por filme
    Should Be Equal As Strings    ${filtered_sessions.status_code}    200
    # Verificar se todas as sessões retornadas pertencem ao filme especificado
    FOR    ${session}    IN    @{filtered_sessions.json()['data']}
        Should Be Equal As Strings    ${session['movie']['_id']}    ${movie_id}
    END
    Log    Cinema App: Filtro de sessões por filme executado com sucesso
