*** Variables ***
# URLs
${BASE_API_URL}      http://localhost:5000/api/v1
${BASE_WEB_URL}      http://localhost:3002

# Browser Configuration
${BROWSER}          chrome
${HEADLESS}         ${True}
${IMPLICIT_WAIT}    10s

# Screenshot Configuration
${SCREENSHOT_DIR}   ${EXECDIR}/screenshots

# Test Data Files
${TEST_DATA_DIR}    ${EXECDIR}/test_data