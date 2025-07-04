*** Settings ***
Library    Browser
Resource   common_keywords.resource

*** Variables ***
# Auth Page Selectors
${LOGIN_EMAIL_FIELD}            id=email
${LOGIN_PASSWORD_FIELD}         id=password
${LOGIN_SUBMIT_BUTTON}          button[type="submit"]

${REGISTER_NAME_FIELD}          id=name
${REGISTER_EMAIL_FIELD}         id=email
${REGISTER_PASSWORD_FIELD}      id=password
${REGISTER_CONFIRM_FIELD}       id=confirmPassword
${REGISTER_SUBMIT_BUTTON}       button[type="submit"]

# Header Elements
${HEADER_LOGIN_LINK}            a[href="/login"] >> nth=0
${HEADER_REGISTER_LINK}         text=Cadastrar
${HEADER_PROFILE_LINK}          text=Perfil
${HEADER_LOGOUT_BUTTON}         text=Sair
${HEADER_RESERVATIONS_LINK}     text=Minhas Reservas

*** Keywords ***
Ir Para Pagina De Login
    Go To    ${BASE_WEB_URL}
    Click    a[href="/login"] >> nth=0
    Wait For Elements State    ${LOGIN_EMAIL_FIELD}    visible    timeout=10s

Ir Para Pagina De Registro
    Go To    ${BASE_WEB_URL}
    Click    text=Cadastrar >> nth=0
    Wait For Elements State    ${REGISTER_NAME_FIELD}    visible    timeout=10s

Preencher Credenciais
    [Arguments]    ${email}    ${password}
    Preencher Campo    ${LOGIN_EMAIL_FIELD}    ${email}
    Preencher Campo    ${LOGIN_PASSWORD_FIELD}    ${password}

Clicar Em Entrar
    Click    ${LOGIN_SUBMIT_BUTTON}

Verificar Login Bem Sucedido
    # Aguarda até sair da página de login ou aparecer mensagem de sucesso
    ${login_url}=    Get Url
    Run Keyword If    '/login' in '${login_url}'    Sleep    2s
    
    # Verifica se houve redirecionamento ou mensagem de sucesso
    ${current_url}=    Get Url
    ${success_msg_count}=    Get Element Count    text=Login realizado com sucesso!
    ${logout_btn_count}=    Get Element Count    ${HEADER_LOGOUT_BUTTON}
    
    # Login bem-sucedido se: saiu da página de login OU há botão de logout OU há mensagem de sucesso
    ${login_ok}=    Evaluate    not '/login' in '${current_url}' or ${logout_btn_count} > 0 or ${success_msg_count} > 0
    
    Run Keyword If    not ${login_ok}    Fail    Login falhou - ainda na página ${current_url}

Fazer Login Como Usuario
    [Arguments]    ${email}=${USER_EMAIL}    ${senha}=${USER_PASSWORD}
    Ir Para Pagina De Login
    Preencher Credenciais    ${email}    ${senha}
    Clicar Em Entrar
    Verificar Login Bem Sucedido

Fazer Login Como Admin
    [Arguments]    ${email}=${ADMIN_EMAIL}    ${senha}=${ADMIN_PASSWORD}
    Ir Para Pagina De Login
    Preencher Credenciais    ${email}    ${senha}
    Clicar Em Entrar
    Verificar Login Bem Sucedido

Registrar Novo Usuario
    [Arguments]    ${nome}    ${email}    ${senha}    ${confirmar_senha}
    Ir Para Pagina De Registro
    Preencher Campo    ${REGISTER_NAME_FIELD}    ${nome}
    Preencher Campo    ${REGISTER_EMAIL_FIELD}    ${email}
    Preencher Campo    ${REGISTER_PASSWORD_FIELD}    ${senha}
    Preencher Campo    ${REGISTER_CONFIRM_FIELD}    ${confirmar_senha}
    Click    ${REGISTER_SUBMIT_BUTTON}

Fazer Logout
    Click    ${HEADER_LOGOUT_BUTTON}
    Wait For Elements State    ${HEADER_LOGIN_LINK}    visible    timeout=10s

Verificar Usuario Logado
    Aguardar Elemento    ${HEADER_PROFILE_LINK}
    Aguardar Elemento    ${HEADER_LOGOUT_BUTTON}
    Aguardar Elemento    ${HEADER_RESERVATIONS_LINK}

Verificar Usuario Nao Logado
    Aguardar Elemento    ${HEADER_LOGIN_LINK}
    Aguardar Elemento    ${HEADER_REGISTER_LINK}

Verificar Erro De Login
    [Arguments]    ${mensagem}
    Verificar Texto Na Pagina    ${mensagem}
    Get Url    should contain    /login

Ir Para Home E Fazer Logout Se Necessario
    Go To    ${BASE_WEB_URL}
    Sleep    1s
    ${logout_exists}=    Get Element Count    ${HEADER_LOGOUT_BUTTON}
    IF    ${logout_exists} > 0
        Click    ${HEADER_LOGOUT_BUTTON}
        Sleep    1s
    END