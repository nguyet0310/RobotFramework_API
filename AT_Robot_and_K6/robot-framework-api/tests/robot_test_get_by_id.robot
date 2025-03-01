*** Settings ***
Library    BuiltIn
Library    Collections
Library    JSONLibrary
Documentation       Test Suite cho Merchant API
Resource            ../keywords/merchant_keywords.robot

*** Test Cases ***
Get Get Merchant By ID
    [Documentation]    Get Merchant by ID
    Get Token
    ${resp}=    Get Merchant By Id
    ${resContent}=    Set Variable    ${resp.json()}
    Should Be Equal As Integers    ${resp.status_code}       200

    ${has_data}=    Run Keyword And Return Status    Get From Dictionary    ${resContent}    data
    Run Keyword If    not ${has_data}    Fail    Response does not contain 'data' field.

    ${merchant_data}=    Get From Dictionary    ${resContent}    data

    Dictionary Should Contain Key    ${merchant_data}    merchantId
    Dictionary Should Contain Key    ${merchant_data}    baseCurrency
    Dictionary Should Contain Key    ${merchant_data}    invoicePrefix
    Dictionary Should Contain Key    ${merchant_data}    dueAfter
    Dictionary Should Contain Key    ${merchant_data}    nextInvoiceNumber
    Dictionary Should Contain Key    ${merchant_data}    mcc
    Dictionary Should Contain Key    ${merchant_data}    mccName
    Dictionary Should Contain Key    ${merchant_data}    linkAccounts
    Dictionary Should Contain Key    ${merchant_data}    loyaltyEligible
    Dictionary Should Contain Key    ${merchant_data}    entityId
    Dictionary Should Contain Key    ${merchant_data}    appId
    Dictionary Should Contain Key    ${merchant_data}    userId

    ${merchantId}=    Get From Dictionary    ${merchant_data}    merchantId
    ${baseCurrency}=    Get From Dictionary    ${merchant_data}    baseCurrency
    ${dueAfter}=    Get From Dictionary    ${merchant_data}    dueAfter

    Should Not Be Empty    ${merchantId}
    Should Be Equal As Strings    ${baseCurrency}    GBP
    Should Be Equal As Integers    ${dueAfter}    30

    ${formatted_json}=    Evaluate    json.dumps(${resContent}, indent=4, ensure_ascii=False)    json
    Log To Console    Response Body: \n${formatted_json}
    Log To Console    Status Code: ${resp.status_code}

Get Merchant With Invalid Token
    [Documentation]    Get a merchant with valid data and an invalid access token.
    ${invalid_headers}=    Create Dictionary    Authorization=Bearer invalid_token    Content-Type=application/json
    Set Suite Variable    ${HEADERS}    ${invalid_headers}
    ${resp}=    Get Merchant By Id
    ${resContent}=    Set Variable    ${resp.json()}
    ${errorMessage}=    Get From Dictionary    ${resContent}    message
    Should Be Equal As Integers    ${resp.status_code}       401
    Should Be Equal As Strings   ${errorMessage}    Unauthorized
    Log    Response Body: ${resp.json()}
    Log    Status Code ${resp.status_code}
    ${formatted_json}=    Evaluate    json.dumps(${resContent}, indent=4, ensure_ascii=False)    json
    Log To Console    Response Body: \n${formatted_json}
    Log To Console    Status Code: ${resp.status_code}

Get merchant details using merchantId path parameter value as “test-123”
    [Documentation]    Get merchant details using merchantId path parameter value as “test-123”.
    Get Token
    ${fake_merchantId}=    Set Variable    test-123
    Set Suite Variable    ${merchant_id}    ${fake_merchantId}

    Log To Console    Using Merchant ID: ${merchant_id}

    ${resp}=    Get Merchant By Id    ${merchant_id}
    ${resContent}=    Set Variable    ${resp.json()}
    Should Be Equal As Integers    ${resp.status_code}    400

    ${errors_list}=    Get From Dictionary    ${resContent}    errors
    ${first_error}=    Get From List    ${errors_list}    0
    ${error_code}=    Get From Dictionary    ${first_error}    code
    ${error_message}=    Get From Dictionary    ${first_error}    message

    Log To Console    \nError Code: ${error_code}
    Log To Console    Error Message: ${error_message}

    Should Be Equal As Strings    ${error_code}    068.S00.400.00
    Should Be Equal As Strings    ${error_message}    The merchantId (test-123) is invalid. The merchantId must be in the format UUID (8aec4498-46c4-495f-b817-2f30dff8420a).
    ${formatted_json}=    Evaluate    json.dumps(${resContent}, indent=4, ensure_ascii=False)    json
    Log To Console    Response Body: \n${formatted_json}
    Log To Console    Status Code: ${resp.status_code}
