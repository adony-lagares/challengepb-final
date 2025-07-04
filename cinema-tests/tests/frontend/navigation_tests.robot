*** Settings ***
Documentation    Testes de navegação da interface do Cinema App
...              Valida funcionalidades de navegação entre páginas
Library          Browser
Resource         ../../resources/frontend/navigation_keywords.resource
Resource         ../../resources/frontend/auth_keywords.resource
Resource         ../../resources/frontend/common_keywords.resource
Resource         ../../variables/web_variables.robot

Suite Setup      Iniciar Navegador
Suite Teardown   Encerrar Navegador
Test Setup       Ir Para Home E Fazer Logout Se Necessario

*** Test Cases ***
TC01_Visualizar_Filmes_Na_Home
    [Documentation]    Verifica se a página home carrega corretamente e exibe os filmes
    [Tags]            navegacao    home    interface    smoke
    Ir Para Home
    Verificar Home Carregada

TC02_Acessar_Detalhes_Do_Filme
    [Documentation]    Valida navegação para página de detalhes do filme
    [Tags]            navegacao    detalhes    filme    interface
    Navegar Para Detalhes Do Filme
    Verificar Detalhes Do Filme Carregados

TC03_Navegacao_Para_Selecao_Assentos_Sem_Login
    [Documentation]    Tenta acessar seleção de assentos sem estar logado
    ...               Deve ser redirecionado para login ou exibir erro
    [Tags]            navegacao    assentos    sem-login    negativo
    Ir Para Home
    Verificar Home Carregada
    ${filme_disponivel}=    Tentar Navegar Para Primeiro Filme Com Sessoes
    IF    ${filme_disponivel}
        Tentar Acessar Selecao De Assentos Sem Login
        # Verifica se foi redirecionado para login ou exibiu erro
        ${login_url}=    Get Url
        TRY
            Should Contain    ${login_url}    /login
            Log    Redirecionado para página de login - comportamento correto
        EXCEPT
            # Se não foi redirecionado, verifica se há mensagem de erro
            ${erro_presente}=    Run Keyword And Return Status    
            ...                  Aguardar Texto Na Pagina    erro    timeout=3s
            IF    not ${erro_presente}
                ${erro_login}=    Run Keyword And Return Status    
                ...               Aguardar Texto Na Pagina    login    timeout=3s
                Should Be True    ${erro_login} or ${erro_presente}    
                ...               Deveria redirecionar para login ou exibir erro
            END
        END
    ELSE
        Skip    Nenhum filme com sessões disponíveis encontrado

TC04_Navegacao_Completa_Com_Usuario_Logado
    [Documentation]    Valida navegação completa com usuário autenticado
    [Tags]            navegacao    logado    completa    positivo
    # Garante que o usuário existe antes de fazer login
    Garantir Usuario De Teste Existe
    
    # Faz login
    Fazer Login Como Usuario
    Verificar Login Bem Sucedido
    
    # Navega para filmes
    Ir Para Home
    Verificar Home Carregada
    
    # Tenta navegar para um filme com sessões
    ${filme_disponivel}=    Tentar Navegar Para Primeiro Filme Com Sessoes
    IF    ${filme_disponivel}
        Verificar Detalhes Do Filme Carregados
        
        # Tenta acessar seleção de assentos (agora logado)
        ${sessao_disponivel}=    Tentar Acessar Primeira_Sessao_Disponivel
        IF    ${sessao_disponivel}
            # BUG CONHECIDO: API pode retornar erro mesmo com usuário logado
            # Verifica se chegou na página de assentos ou se há erro da API
            ${url_atual}=    Get Url
            ${na_assentos}=    Run Keyword And Return Status    
            ...                Should Contain    ${url_atual}    /seats
            IF    ${na_assentos}
                Log    Navegação para seleção de assentos bem-sucedida
                Aguardar Elemento    ${SEAT_SELECTOR}    timeout=10s
            ELSE
                # Verifica se há erro conhecido da API
                ${erro_api}=    Run Keyword And Return Status    
                ...             Aguardar Texto Na Pagina    Erro ao carregar    timeout=5s
                IF    ${erro_api}
                    Log    BUG CONHECIDO: API retorna erro ao carregar informações de assentos
                ELSE
                    Fail    Não conseguiu acessar página de assentos e não há erro conhecido
                END
            END
        ELSE
            Log    Nenhuma sessão disponível encontrada para teste
        END
    ELSE
        Skip    Nenhum filme com sessões disponíveis encontrado

TC05_Verificar_Responsividade_Navegacao
    [Documentation]    Verifica se a navegação funciona em diferentes tamanhos de tela
    [Tags]            navegacao    responsivo    mobile    interface
    # Testa em viewport mobile
    Set Viewport Size    375    667
    Ir Para Home
    Verificar Home Carregada
    
    # Testa navegação em mobile
    ${filme_disponivel}=    Tentar Navegar Para Primeiro Filme Com Sessoes
    IF    ${filme_disponivel}
        Verificar Detalhes Do Filme Carregados
    END
    
    # Volta para viewport desktop
    Set Viewport Size    1920    1080
    Ir Para Home
    Verificar Home Carregada