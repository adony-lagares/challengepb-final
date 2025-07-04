*** Variables ***
# Auth Endpoints
${AUTH_LOGIN_ENDPOINT}       /auth/login
${AUTH_REGISTER_ENDPOINT}    /auth/register
${AUTH_ME_ENDPOINT}          /auth/me
${AUTH_PROFILE_ENDPOINT}     /auth/profile

# Users Endpoints
${USERS_ENDPOINT}            /users
${USERS_ID_ENDPOINT}         /users/{id}

# Movies Endpoints
${MOVIES_ENDPOINT}           /movies
${MOVIES_ID_ENDPOINT}        /movies/{id}

# Theaters Endpoints
${THEATERS_ENDPOINT}         /theaters
${THEATERS_ID_ENDPOINT}      /theaters/{id}

# Sessions Endpoints
${SESSIONS_ENDPOINT}         /sessions
${SESSIONS_ID_ENDPOINT}      /sessions/{id}
${RESET_SEATS_ENDPOINT}      /sessions/{id}/reset-seats

# Reservations Endpoints
${RESERVATIONS_ENDPOINT}     /reservations
${RESERVATIONS_ME_ENDPOINT}  /reservations/me
${RESERVATIONS_ID_ENDPOINT}  /reservations/{id}

# Test Users
${ADMIN_EMAIL}      admin@example.com
${ADMIN_PASSWORD}   password123
${USER_EMAIL}       user@example.com
${USER_PASSWORD}    password123