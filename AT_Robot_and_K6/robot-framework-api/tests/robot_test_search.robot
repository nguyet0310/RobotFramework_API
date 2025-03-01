*** Settings ***
Library    BuiltIn
Library    Collections
Library    JSONLibrary
Documentation       Test Suite cho Merchant API
Resource            ../keywords/merchant_keywords.robot

*** Test Cases ***
Retrieve All Merchants Without Providing Query Parameters
    [Documentation]    Retrieve all merchants without providing any query parameters.
    
    Get Token
    ${resp}=    Get Merchants
    ${resContent}=    Set Variable    ${resp.json()}

    Should Be Equal As Integers    ${resp.status_code}    200

    Dictionary Should Contain Key    ${resContent}    data
    Dictionary Should Contain Key    ${resContent}    paging

    ${merchant_list}=    Get From Dictionary    ${resContent}    data
    Should Not Be Empty    ${merchant_list}

    FOR    ${merchant}    IN    @{merchant_list}
        Dictionary Should Contain Key    ${merchant}    merchantId
        Dictionary Should Contain Key    ${merchant}    baseCurrency
        Dictionary Should Contain Key    ${merchant}    nextInvoiceNumber
        Dictionary Should Contain Key    ${merchant}    linkAccounts
        Dictionary Should Contain Key    ${merchant}    loyaltyEligible
    END

    FOR    ${merchant}    IN    @{merchant_list}
        Should Contain    SGD,PHP    ${merchant["baseCurrency"]}
    END

    ${paging}=    Get From Dictionary    ${resContent}    paging
    Dictionary Should Contain Key    ${paging}    pageNumber
    Dictionary Should Contain Key    ${paging}    pageSize
    Dictionary Should Contain Key    ${paging}    totalRecords

    Should Be Equal As Integers    ${paging["pageSize"]}    10
    Should Be True    ${paging["totalRecords"]} > 0

    ${formatted_json}=    Evaluate    json.dumps(${resContent}, indent=4, ensure_ascii=False)    json
    Log To Console    Response Body: \n${formatted_json}
    Log To Console    Status Code: ${resp.status_code}


Get List of Merchants With Invalid Token
    [Documentation]    Get list merchants with valid data and an invalid access token.
    ${invalid_headers}=    Create Dictionary    Authorization=Bearer invalid_token    Content-Type=application/json
    Set Suite Variable    ${HEADERS}    ${invalid_headers}
    ${resp}=    Get Merchants
    ${resContent}=    Set Variable    ${resp.json()}
    ${errorMessage}=    Get From Dictionary    ${resContent}    message
    Should Be Equal As Integers    ${resp.status_code}       401
    Should Be Equal As Strings   ${errorMessage}    Unauthorized
    Log    Response Body: ${resp.json()}
    Log    Status Code ${resp.status_code}
    ${formatted_json}=    Evaluate    json.dumps(${resContent}, indent=4, ensure_ascii=False)    json
    Log To Console    Response Body: \n${formatted_json}
    Log To Console    Status Code: ${resp.status_code}

Search Merchants invalid page_number
    [Documentation]    Search merchants by parameter
    Get Token
    ${resp}=    Get Merchants    0    abc123
    ${resContent}=    Set Variable    ${resp.json()}