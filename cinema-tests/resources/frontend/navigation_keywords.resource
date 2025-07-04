*** Settings ***
Documentation    Keywords para navegação na interface do Cinema App
Library          Browser
Resource         common_keywords.resource
Resource         auth_keywords.resource
Resource         booking_keywords.resource

*** Variables ***
# Seletores da página home
${MOVIES_SECTION}               h2 >> text=Filmes em Cartaz
${MOVIE_CARD}                   .movie-card
${MOVIE_DETAILS_BUTTON}         text=Ver Detalhes

# Seletores da página de detalhes do filme
${MOVIE_TITLE}                  h1
${MOVIE_SYNOPSIS}               text=Sinopse
${SESSION_BUTTON}               .session-button
${SESSION_LIST}                 .sessions-list

# Seletores da página de seleção de assentos
${SEAT_SELECTOR}                .seat
${SEATS_CONTAINER}              .seats-container

*** Keywords ***
Ir Para Home
    [Documentation]    Navega para a página inicial da aplicação
    Go To    ${BASE_WEB_URL}
    Aguardar Elemento    ${MOVIES_SECTION}    timeout=10s

Navegar Para Detalhes Do Filme
    [Documentation]    Navega para a página de detalhes do primeiro filme disponível
    Ir Para Home
    Aguardar Elemento    ${MOVIE_DETAILS_BUTTON} >> nth=0    timeout=10s
    Click    ${MOVIE_DETAILS_BUTTON} >> nth=0
    Aguardar Elemento    ${MOVIE_TITLE}    timeout=10s

Navegar Para Selecao De Assentos
    [Documentation]    Navega para a página de seleção de assentos
    Navegar Para Detalhes Do Filme
    Aguardar Elemento    ${SESSION_BUTTON} >> nth=0    timeout=10s
    Click    ${SESSION_BUTTON} >> nth=0

Verificar Home Carregada
    [Documentation]    Verifica se a página home foi carregada corretamente
    Aguardar Elemento    ${MOVIES_SECTION}    timeout=10s
    Aguardar Elemento    ${MOVIE_CARD} >> nth=0    timeout=10s

Verificar Detalhes Do Filme Carregados
    [Documentation]    Verifica se a página de detalhes do filme foi carregada
    Aguardar Elemento    ${MOVIE_TITLE}    timeout=10s
    # Verifica se há pelo menos um elemento de sinopse ou sessão
    ${sinopse_presente}=    Run Keyword And Return Status    
    ...                     Aguardar Elemento    ${MOVIE_SYNOPSIS}    timeout=5s
    ${sessoes_presentes}=    Run Keyword And Return Status    
    ...                      Aguardar Elemento    ${SESSION_LIST}    timeout=5s
    Should Be True    ${sinopse_presente} or ${sessoes_presentes}    
    ...               Detalhes do filme não carregaram adequadamente

Tentar Navegar Para Primeiro Filme Com Sessoes
    [Documentation]    Tenta encontrar e navegar para um filme que tenha sessões
    [Arguments]        ${timeout}=10s
    
    # Vai para home primeiro
    Ir Para Home
    
    # Busca por filmes com botão de detalhes
    ${filmes_encontrados}=    Get Element Count    ${MOVIE_DETAILS_BUTTON}
    
    FOR    ${index}    IN RANGE    ${filmes_encontrados}
        TRY
            # Clica no filme
            Click    ${MOVIE_DETAILS_BUTTON} >> nth=${index}
            Aguardar Elemento    ${MOVIE_TITLE}    timeout=5s
            
            # Verifica se há sessões disponíveis
            ${sessoes_count}=    Get Element Count    ${SESSION_BUTTON}
            IF    ${sessoes_count} > 0
                Log    Filme com sessões encontrado no índice ${index}
                RETURN    ${True}
            ELSE
                # Volta para home e tenta próximo filme
                Go Back
                Aguardar Elemento    ${MOVIES_SECTION}    timeout=5s
            END
        EXCEPT
            # Se deu erro, volta para home e tenta próximo
            Go To    ${BASE_WEB_URL}
            Aguardar Elemento    ${MOVIES_SECTION}    timeout=5s
        END
    END
    
    Log    Nenhum filme com sessões encontrado
    RETURN    ${False}

Tentar Acessar Selecao De Assentos Sem Login
    [Documentation]    Tenta acessar seleção de assentos sem estar logado
    
    # Verifica se há sessões disponíveis
    ${sessoes_count}=    Get Element Count    ${SESSION_BUTTON}
    IF    ${sessoes_count} > 0
        Click    ${SESSION_BUTTON} >> nth=0
        Sleep    2s    # Aguarda redirecionamento ou carregamento
    ELSE
        Fail    Nenhuma sessão disponível para teste

Tentar Acessar Primeira_Sessao_Disponivel
    [Documentation]    Tenta acessar a primeira sessão disponível
    
    ${sessoes_count}=    Get Element Count    ${SESSION_BUTTON}
    IF    ${sessoes_count} > 0
        Click    ${SESSION_BUTTON} >> nth=0
        Sleep    3s    # Aguarda carregamento
        RETURN    ${True}
    ELSE
        RETURN    ${False}
    END