*** Settings ***
Library    BuiltIn
Library    Collections
Library    JSONLibrary
Documentation       Test Suite cho Merchant API
Resource            ../keywords/merchant_keywords.robot

*** Test Cases ***
# Update merchant using an empty baseCurrency value
#     [Documentation]    Update merchant using an empty baseCurrency value
#     Get Token
#     # ${resp}=    Update Merchant By Id    ${EMPTY}    11111    30    1    80-01-01    SHOPPING & RETAIL    true
#     ${resp}=    Update Merchant By Id    mid0111111    1    2    3    4    5    7    6

#     Log To Console    Status Code: ${resp}

    # Log To Console    Response Body: ${resp.json()}
    # ${resContent}=    Set Variable    ${resp.json()}
    # ${first_error}=    Get From List    ${resContent['errors']}    0

    # ${error_code}=    Get From Dictionary    ${first_error}    code
    # ${error_message}=    Get From Dictionary    ${first_error}    message
    # Should Be Equal As Integers    ${resp.status_code}       400

    # Log    Response Body: ${resp.json()}
    # Log    Status Code ${resp.status_code}

    # Should Be Equal As Strings    ${error_code}    068.S00.400.00
    # Should Be Equal As Strings    ${error_message}    The request body has an invalid data type. The valid data type is Integer.

    # ${formatted_json}=    Evaluate    json.dumps(${resContent}, indent=4, ensure_ascii=False)    json
    # Log To Console    \nResponse Body: \n${formatted_json}
    # Log To Console    Status Code: ${resp.status_code}

Search Merchants invalid page_number
    [Documentation]    Search merchants by parameter
    Get Token
    ${resp}=    Get Merchants    abc123
    ${resContent}=    Set Variable    ${resp.json()}

    Log To Console    Status JSON: ${resContent}