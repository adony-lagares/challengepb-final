# ============================================================================
# TESTES AUTOMATIZADOS - CINEMA APP - AUTENTICAÇÃO E AUTORIZAÇÃO
# 
# Funcionalidades testadas: Registro e login de usuários, validação de dados
# Endpoints: /auth/register, /auth/login
# Status: Documentação de validações e controles de acesso
# ============================================================================

*** Settings ***
Library    Collections
Library    RequestsLibrary
Library    String
Resource    ../../resources/backend/auth.resource
Resource    ../../variables/api_variables.robot

Suite Setup    RequestsLibrary.Create Session    cinema_api    ${BASE_API_URL}

*** Test Cases ***
Registrar Novo Usuário Com Dados Válidos Deve Ter Sucesso
    [Tags]    AUTH-001    WAYNE-REGISTRATION
    # Geração de email único para evitar conflitos em execuções múltiplas
    ${random_suffix}=    Generate Random String    5
    ${gotham_email}=    Set Variable    citizen${random_suffix}@gotham.com
    
    # Criação de payload de registro com dados válidos
    ${bruce_wayne_data}=    Create Dictionary
    ...    name=Bruce Wayne
    ...    email=${gotham_email}
    ...    password=WayneEnterprises123!
    
    # Execução do registro no endpoint POST /auth/register
    ${batman_response}=    Register User    Bruce Wayne    ${gotham_email}    WayneEnterprises123!
    
    # Validação de resposta da API para registro bem-sucedido
    Should Be Equal As Strings    ${batman_response.status_code}    201
    Dictionary Should Contain Key    ${batman_response.json()['data']}    _id
    Dictionary Should Contain Key    ${batman_response.json()['data']}    email
    Log    Cinema App: Usuário registrado com sucesso

Registrar Com Email Já Existente Deve Falhar
    [Tags]    AUTH-002    DUPLICATE-GOTHAM
    # Teste de validação: tentativa de registro com email já cadastrado
    ${duplicate_attempt}=    Register User    Lex Luthor    ${ADMIN_EMAIL}    LuthorCorp123!
    
    # Validação de erro para email duplicado
    Should Be Equal As Strings    ${duplicate_attempt.status_code}    400
    Should Contain    ${duplicate_attempt.json()['message']}    already exists
    Log    Cinema App: Validação de email duplicado funcionando corretamente

Registrar Com Formato Inválido De Email Deve Falhar
    [Tags]    AUTH-003    INVALID-FORMAT
    # Teste de validação: formato de email inválido
    ${invalid_email_attempt}=    Register User    Joker    invalidemailformat    ChaosInGotham123!
    
    # Validação de erro para formato de email inválido
    Should Be Equal As Strings    ${invalid_email_attempt.status_code}    400
    Log    Cinema App: Validação de formato de email funcionando corretamente

Registrar Com Senha Curta Deve Falhar
    [Tags]    AUTH-004    WEAK-PASSWORD
    # Teste de validação: senha muito curta (menos de 6 caracteres)
    ${weak_password_attempt}=    Register User    Penguin    penguin@iceberg.com    123
    
    # Validação de erro para senha fraca
    Should Be Equal As Strings    ${weak_password_attempt.status_code}    400
    Log    Cinema App: Validação de força de senha funcionando corretamente

Login Com Credenciais Válidas Deve Ter Sucesso
    [Tags]    AUTH-005    BATMAN-LOGIN
    # Autenticação com credenciais de administrador válidas
    ${batman_login}=    Login User    ${ADMIN_EMAIL}    ${ADMIN_PASSWORD}
    
    # Validação de resposta da API para login bem-sucedido
    Should Be Equal As Strings    ${batman_login.status_code}    200
    Dictionary Should Contain Key    ${batman_login.json()['data']}    token
    Dictionary Should Contain Key    ${batman_login.json()['data']}    role
    Should Not Be Empty    ${batman_login.json()['data']['token']}
    Log    Cinema App: Login executado com sucesso

Login Com Email Não Cadastrado Deve Falhar
    [Tags]    AUTH-006    UNAUTHORIZED-ACCESS
    # Teste de segurança: tentativa de login com email inexistente
    ${unauthorized_attempt}=    Login User    stranger@unknown.com    SomePassword123!
    
    # Validação de erro para credenciais inválidas
    Should Be Equal As Strings    ${unauthorized_attempt.status_code}    401
    Should Contain    ${unauthorized_attempt.json()['message']}    Invalid email or password
    Log    Cinema App: Controle de acesso funcionando - login negado para email inexistente

Login Com Senha Incorreta Deve Falhar
    [Tags]    AUTH-007    WRONG-PASSWORD
    # Teste de segurança: tentativa de login com senha incorreta
    ${wrong_password_attempt}=    Login User    ${ADMIN_EMAIL}    WrongPassword123!
    
    # Validação de erro para senha incorreta
    Should Be Equal As Strings    ${wrong_password_attempt.status_code}    401
    Should Contain    ${wrong_password_attempt.json()['message']}    Invalid email or password
    Log    Cinema App: Controle de acesso funcionando - login negado para senha incorreta
