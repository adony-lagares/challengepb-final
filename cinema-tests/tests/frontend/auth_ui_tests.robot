*** Settings ***
Library    Browser
Library    String
Resource    ../../resources/frontend/auth_keywords.resource

Suite Setup    Iniciar Navegador
Suite Teardown    Encerrar Navegador 
Test Setup    Ir Para Home E Fazer Logout Se Necessario

*** Test Cases ***
Login Usuario Bem Sucedido
    [Tags]
    Fazer Login Como Usuario
    Verificar Usuario Logado

Login Admin Bem Sucedido
    [Tags]
    Fazer Login Como Admin
    Verificar Usuario Logado

Login Com Credenciais Invalidas
    [Tags]
    Ir Para Pagina De Login
    Preencher Credenciais    email@invalido.com    senhaerrada
    Clicar Em Entrar
    Verificar Texto Na Pagina    404: NOT_FOUND
    ${url}=    Get Url
    Should Contain    ${url}    /login

Registro De Novo Usuario
    [Tags]
    ${random_email}=    Gerar Email Aleatorio
    Registrar Novo Usuario    Test User    ${random_email}    password123    password123
    ${url}=    Get Url
    Should Contain    ${url}    challenge-pb-front.vercel.app
    Verificar Texto Na Pagina    Conta criada com sucesso!
    Verificar Usuario Logado

Registro Com Senhas Diferentes
    [Tags]
    ${random_email}=    Gerar Email Aleatorio
    Registrar Novo Usuario    Test User    ${random_email}    password123    password456
    Verificar Texto Na Pagina    As senhas não coincidem.
    ${url}=    Get Url
    Should Contain    ${url}    /register

Logout Do Sistema
    [Tags]
    Fazer Login Como Usuario
    Fazer Logout
    Verificar Usuario Nao Logado