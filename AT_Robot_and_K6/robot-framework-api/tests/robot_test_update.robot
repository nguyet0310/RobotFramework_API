*** Settings ***
Library    BuiltIn
Library    Collections
Library    JSONLibrary
Documentation       Test Suite cho Merchant API
Resource            ../keywords/merchant_keywords.robot

*** Test Cases ***
Update a merchant’s invoicePrefix and loyaltyEligible
    [Documentation]    Update a merchant’s invoicePrefix and loyaltyEligible
    Get Token
    ${resp}=    Update Merchant By Id
    ${resContent}=    Set Variable    ${resp.json()}
    Should Be Equal As Integers    ${resp.status_code}    200
    ${has_data}=    Run Keyword And Return Status    Get From Dictionary    ${resContent}    data
    Run Keyword If    not ${has_data}    Fail    Response does not contain 'data' field.
    ${merchant_data}=    Get From Dictionary    ${resContent}    data
    ${merchantId}=    Get From Dictionary    ${merchant_data}    merchantId
    ${baseCurrency}=    Get From Dictionary    ${merchant_data}    baseCurrency
    ${invoicePrefix}=    Get From Dictionary    ${merchant_data}    invoicePrefix
    ${dueAfter}=    Get From Dictionary    ${merchant_data}    dueAfter
    ${nextInvoiceNumber}=    Get From Dictionary    ${merchant_data}    nextInvoiceNumber
    ${mcc}=    Get From Dictionary    ${merchant_data}    mcc
    ${mccName}=    Get From Dictionary    ${merchant_data}    mccName

    Log    Merchant ID: ${merchantId}
    Log    Base Currency: ${baseCurrency}
    Log    Invoice Prefix: ${invoicePrefix}
    Log    Due After: ${dueAfter}
    Log    MCC: ${mcc}
    Log    MCC Name: ${mccName}

    Should Not Be Empty    ${merchantId}
    Should Be Equal As Strings    ${baseCurrency}    GBP
    Should Be Equal As Integers    ${dueAfter}    30

    ${formatted_json}=    Evaluate    json.dumps(${resContent}, indent=4, ensure_ascii=False)    json
    Log To Console    Response Body: \n${formatted_json}
    Log To Console    Status Code: ${resp.status_code}

Update merchant with an invalid access token in the request header.
    [Documentation]    Update merchant with an invalid access token in the request header.
    ${invalid_headers}=    Create Dictionary    Authorization=Bearer invalid_token    Content-Type=application/json
    Set Suite Variable    ${HEADERS}    ${invalid_headers}
    ${resp}=    Update Merchant By Id
    ${resContent}=    Set Variable    ${resp.json()}
    ${errorMessage}=    Get From Dictionary    ${resContent}    message
    Should Be Equal As Integers    ${resp.status_code}       401
    Should Be Equal As Strings   ${errorMessage}    Unauthorized
    Log    Response Body: ${resp.json()}
    Log    Status Code ${resp.status_code}
    ${formatted_json}=    Evaluate    json.dumps(${resContent}, indent=4, ensure_ascii=False)    json
    Log To Console    Response Body: \n${formatted_json}
    Log To Console    Status Code: ${resp.status_code}

Update merchant using an empty baseCurrency value
    [Documentation]    Update merchant using an empty baseCurrency value
    Get Token
    ${resp}=    Update Merchant By Id    ${EMPTY}    30    INVxxxxxx    1    80-01-01    SHOPPING & RETAIL    true

    Log To Console    Status Code: ${resp}

    Log To Console    Response Body: ${resp.json()}
    ${resContent}=    Set Variable    ${resp.json()}
    ${first_error}=    Get From List    ${resContent['errors']}    0

    ${error_code}=    Get From Dictionary    ${first_error}    code
    ${error_message}=    Get From Dictionary    ${first_error}    message
    Should Be Equal As Integers    ${resp.status_code}       400

    Log    Response Body: ${resp.json()}
    Log    Status Code ${resp.status_code}

    Should Be Equal As Strings    ${error_code}    068.S00.400.00
    Should Be Equal As Strings    ${error_message}    The baseCurrency length must be between 3 and 3.

    ${formatted_json}=    Evaluate    json.dumps(${resContent}, indent=4, ensure_ascii=False)    json
    Log To Console    \nResponse Body: \n${formatted_json}
    Log To Console    Status Code: ${resp.status_code}