*** Variables ***
# Base URL
${BASE_WEB_URL}             http://localhost:3002

# Page URLs
${LOGIN_PAGE_URL}           ${BASE_WEB_URL}/login
${REGISTER_PAGE_URL}        ${BASE_WEB_URL}/register
${HOME_PAGE_URL}            ${BASE_WEB_URL}/
${PROFILE_PAGE_URL}         ${BASE_WEB_URL}/profile
${RESERVATIONS_PAGE_URL}    ${BASE_WEB_URL}/reservations
${ADMIN_DASHBOARD_URL}      ${BASE_WEB_URL}/admin/dashboard

# User Credentials
${USER_EMAIL}               user@example.com
${USER_PASSWORD}            password123
${ADMIN_EMAIL}              admin@example.com
${ADMIN_PASSWORD}           admin123

# Locators
# Auth Page
${EMAIL_INPUT}              id=email
${PASSWORD_INPUT}           id=password
${LOGIN_BUTTON}             xpath=//button[contains(text(),'Entrar')]
${REGISTER_LINK}            xpath=//a[contains(text(),'Cadastrar')]
${LOGOUT_BUTTON}            xpath=//button[contains(text(),'Sair')]

# Register Page
${NAME_INPUT}               id=name
${CONFIRM_PASSWORD_INPUT}   id=confirmPassword
${REGISTER_BUTTON}          xpath=//button[contains(text(),'Cadastrar')]

# Home Page
${MOVIE_CARDS}              css=.movie-card
${MOVIE_DETAILS_BUTTON}     xpath=//button[contains(text(),'Ver Detalhes')]

# Movie Details Page
${SESSION_SELECT_BUTTON}    xpath=//button[contains(text(),'Selecionar Assentos')]

# Seats Page
${AVAILABLE_SEAT}           css=.seat.available
${SELECTED_SEAT}            css=.seat.selected
${OCCUPIED_SEAT}            css=.seat.occupied
${CONTINUE_BUTTON}          xpath=//button[contains(text(),'Continuar para Pagamento')]

# Checkout Page
${PAYMENT_METHOD}           id=payment-method
${FINALIZE_BUTTON}          xpath=//button[contains(text(),'Finalizar Compra')]

# Profile Page
${PROFILE_NAME_INPUT}       id=name
${SAVE_PROFILE_BUTTON}      xpath=//button[contains(text(),'Salvar Alterações')]

# Reservations Page
${RESERVATION_CARDS}        css=.reservation-card
${NO_RESERVATIONS_MESSAGE}  xpath=//*[contains(text(),'Nenhuma reserva encontrada')]

# Admin Panel
${ADMIN_LINK}               xpath=//a[contains(text(),'Painel Admin')]
${MANAGE_MOVIES_LINK}       xpath=//a[contains(text(),'Gerenciar Filmes')]