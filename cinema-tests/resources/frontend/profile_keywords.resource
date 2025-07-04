*** Settings ***
Documentation    Keywords para funcionalidades de perfil do usuário no Cinema App
Library          Browser
Resource         common_keywords.resource
Resource         auth_keywords.resource

*** Variables ***
# Seletores da página de perfil
${PROFILE_NAME_FIELD}           id=name
${PROFILE_EMAIL_FIELD}          id=email
${PROFILE_SAVE_BUTTON}          button[type="submit"]
${PROFILE_TITLE}                h1 >> text=Meu Perfil

# Seletores da seção de reservas
${RESERVATIONS_SECTION}         h2 >> text=Minhas Reservas
${RESERVATION_MOVIE}            text=The Avengers
${RESERVATION_STATUS}           text=CONFIRMADA
${NO_RESERVATIONS_MESSAGE}      text=Nenhuma reserva encontrada

# Seletores alternativos para perfil
${PROFILE_LINK}                 text=Perfil
${PROFILE_BUTTON}               button >> text=Perfil
${PROFILE_NAV}                  nav >> text=Perfil

*** Keywords ***
Ir Para Pagina De Perfil
    [Documentation]    Navega para a página de perfil do usuário
    
    # Tenta múltiplas formas de acessar o perfil
    ${perfil_link}=    Run Keyword And Return Status    
    ...                Click    ${PROFILE_LINK}
    
    IF    not ${perfil_link}
        ${perfil_button}=    Run Keyword And Return Status    
        ...                  Click    ${PROFILE_BUTTON}
        
        IF    not ${perfil_button}
            ${perfil_nav}=    Run Keyword And Return Status    
            ...               Click    ${PROFILE_NAV}
            
            IF    not ${perfil_nav}
                # Tenta acessar diretamente pela URL
                ${current_url}=    Get Url
                ${base_url}=    Replace String    ${current_url}    ${BASE_WEB_URL}    ${BASE_WEB_URL}
                Go To    ${BASE_WEB_URL}/profile
            END
        END
    END
    
    # Aguarda carregamento da página
    Aguardar Elemento    ${PROFILE_NAME_FIELD}    timeout=10s

Visualizar Reservas Na Pagina De Perfil
    [Documentation]    Navega para perfil e visualiza seção de reservas
    Ir Para Pagina De Perfil
    
    # Aguarda seção de reservas carregar
    ${reservas_carregadas}=    Run Keyword And Return Status    
    ...                        Aguardar Elemento    ${RESERVATIONS_SECTION}    timeout=10s
    
    IF    not ${reservas_carregadas}
        # Se não encontrou por seletor, busca por texto
        ${reservas_por_texto}=    Run Keyword And Return Status    
        ...                       Aguardar Texto Na Pagina    reserva    timeout=5s
        
        IF    not ${reservas_por_texto}
            Log    Seção de reservas pode não estar visível ou não existir
        END
    END
    
    Sleep    2s    # Aguarda carregamento completo

Atualizar Nome Do Perfil
    [Documentation]    Atualiza o nome do usuário no perfil
    [Arguments]       ${novo_nome}
    Ir Para Pagina De Perfil
    Fill Text    ${PROFILE_NAME_FIELD}    ${novo_nome}
    Click    ${PROFILE_SAVE_BUTTON}
    Sleep    2s    # Aguarda salvamento

Verificar Pagina De Perfil Carregada
    [Documentation]    Verifica se a página de perfil foi carregada corretamente
    
    # Verifica elementos essenciais da página
    Aguardar Elemento    ${PROFILE_NAME_FIELD}    timeout=10s
    Aguardar Elemento    ${PROFILE_EMAIL_FIELD}    timeout=10s
    
    # Verifica título da página
    ${titulo_presente}=    Run Keyword And Return Status    
    ...                    Aguardar Elemento    ${PROFILE_TITLE}    timeout=5s
    
    IF    not ${titulo_presente}
        # Verifica por texto alternativo
        ${titulo_texto}=    Run Keyword And Return Status    
        ...                 Aguardar Texto Na Pagina    Perfil    timeout=5s
        Should Be True    ${titulo_texto}    
        ...               Título ou indicação de perfil deve estar presente
    END

Verificar Reserva Existente
    [Documentation]    Verifica se existe pelo menos uma reserva no perfil
    
    # Verifica elementos específicos de reserva
    ${filme_encontrado}=    Run Keyword And Return Status    
    ...                     Aguardar Elemento    ${RESERVATION_MOVIE}    timeout=5s
    
    ${status_encontrado}=    Run Keyword And Return Status    
    ...                      Aguardar Elemento    ${RESERVATION_STATUS}    timeout=5s
    
    # Se não encontrou elementos específicos, verifica por texto genérico
    IF    not ${filme_encontrado} and not ${status_encontrado}
        ${reserva_texto}=    Run Keyword And Return Status    
        ...                  Aguardar Texto Na Pagina    reserva    timeout=5s
        Should Be True    ${reserva_texto}    
        ...               Deve haver indicação de reserva na página
    END
    
    # Verifica informações de preço (se presente)
    ${preco_encontrado}=    Run Keyword And Return Status    
    ...                     Aguardar Texto Na Pagina    R$    timeout=3s
    IF    ${preco_encontrado}
        Log    Informação de preço encontrada na reserva
    END

Verificar Nenhuma Reserva
    [Documentation]    Verifica se a mensagem de nenhuma reserva está presente
    
    ${mensagem_encontrada}=    Run Keyword And Return Status    
    ...                        Aguardar Elemento    ${NO_RESERVATIONS_MESSAGE}    timeout=5s
    
    IF    not ${mensagem_encontrada}
        # Verifica mensagens alternativas
        ${sem_reservas}=    Run Keyword And Return Status    
        ...                 Aguardar Texto Na Pagina    sem reservas    timeout=3s
        ${nenhuma_reserva}=    Run Keyword And Return Status    
        ...                    Aguardar Texto Na Pagina    nenhuma reserva    timeout=3s
        ${vazio}=    Run Keyword And Return Status    
        ...          Aguardar Texto Na Pagina    vazio    timeout=3s
        
        Should Be True    ${sem_reservas} or ${nenhuma_reserva} or ${vazio}    
        ...               Deve haver indicação de que não há reservas
    END