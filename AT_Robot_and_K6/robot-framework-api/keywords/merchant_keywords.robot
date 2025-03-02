*** Settings ***
Library           RequestsLibrary
Library           JSONLibrary
Library           Collections
Resource          ../configs/env.robot   # Load Environment

*** Variables ***
${SESSION_ALIAS}    merchant_api
${AUTH_ALIAS}       auth_api
${TOKEN}            None
${HEADERS}          None

*** Keywords ***
Get Token
    [Documentation]    Get the token by calling /identity-service/1.0.0/token and extracting id_token
    Create Session    ${AUTH_ALIAS}    ${BASE_URL}
    ${body}=    Create Dictionary
    ...    clientId=${CLIENT_ID}
    ...    redirectUri=${REDIRECT_URI}
    ...    grantType=${GRANT_TYPE}
    ...    refreshToken=${REFRESH_TOKEN}
    ${req_headers}=    Create Dictionary    Content-Type=application/json
    ${resp}=    POST On Session    ${AUTH_ALIAS}    /identity-service/1.0.0/token    json=${body}    headers=${req_headers}
    Should Be Equal As Integers    ${resp.status_code}    200
    ${json_resp}=    Call Method    ${resp}    json
    ${id_token}=    Get From Dictionary    ${json_resp}    id_token
    Set Suite Variable    ${TOKEN}    ${id_token}
    ${auth_headers}=    Create Dictionary    Authorization=Bearer ${id_token}    Content-Type=application/json
    Set Suite Variable    ${HEADERS}    ${auth_headers}


Create Merchant And Return Response
    [Arguments]    ${base_currency}=GBP    ${invoice_prefix}=INVxxxxxx    ${due_after}=30    ${next_invoice_number}=1    ${mcc}=80-01-01    ${mcc_name}=SHOPPING & RETAIL    ${loyalty_eligible}=true
    [Documentation]    Tạo mới merchant qua API POST /merchants và trả về response để kiểm tra
    Create Session    ${SESSION_ALIAS}    ${BASE_URL}
    ${category}=    Create Dictionary
    ...    categoryName=Retail
    ...    categoryCode=RETAIL
    ...    riskLevel=LOW
    ...    description=Retail category for consumer goods.
    ${body}=    Create Dictionary
    ...    baseCurrency=${base_currency}
    ...    invoicePrefix=${invoice_prefix}
    ...    dueAfter=${due_after}
    ...    nextInvoiceNumber=${next_invoice_number}
    ...    mcc=${mcc}
    ...    mccName=${mcc_name}
    ...    loyaltyEligible=${loyalty_eligible}
    ...    category=${category}

    ${resp}=    POST On Session    
    ...    ${SESSION_ALIAS}    
    ...    /merchant-service/1.0.0/merchants    
    ...    json=${body}    headers=${HEADERS}    
    ...    expected_status=any
    [Return]    ${resp}

Get Merchant By Id
    [Arguments]    ${merchant_id}=${TEST_MERCHANT_ID}
    [Documentation]    Get information of a merchant via API GET /merchants/{merchantId}

    Create Session    ${SESSION_ALIAS}    ${BASE_URL}
    ${resp}=    GET On Session
    ...    ${SESSION_ALIAS}
    ...    /merchant-service/1.0.0/merchants/${merchant_id}
    ...    headers=${HEADERS}
    ...    expected_status=any
    [Return]    ${resp}

Get Merchants
    [Arguments]    
    ...     ${query}=${EMPTY}
    [Documentation]    Get list of merchants via API GET /merchants?pageSize=X

    Create Session    ${SESSION_ALIAS}    ${BASE_URL}
    
    ${resp}=    GET On Session
    ...    ${SESSION_ALIAS}    
    ...    /merchant-service/1.0.0/merchants    params=${query}
    ...    headers=${HEADERS}
    ...    expected_status=any
    
    [Return]    ${resp}

Update Merchant By Id
    [Arguments]
    ...    ${base_currency}=GBP
    ...    ${due_after}=30    
    ...    ${invoice_prefix}=INVxxxxxx
    ...    ${next_invoice_number}=1    
    ...    ${mcc}=80-01-01
    ...    ${mcc_name}=SHOPPING & RETAIL
    ...    ${loyalty_eligible}=true

    [Documentation]    Update 1 merchant qua API PATCH /merchants/{merchantId}

    Create Session    ${SESSION_ALIAS}    ${BASE_URL}
    ${body}=    Create Dictionary
    ...    baseCurrency=${base_currency}
    ...    dueAfter=${due_after}
    ...    invoicePrefix=${invoice_prefix}
    ...    nextInvoiceNumber=${next_invoice_number}
    ...    mcc=${mcc}
    ...    mccName=${mcc_name}
    ...    loyaltyEligible=${loyalty_eligible}

    Log To Console    body Code: ${body}

    ${resp}=    PATCH On Session
    ...    ${SESSION_ALIAS}
    ...    /merchant-service/1.0.0/merchants/${TEST_MERCHANT_ID}
    ...    json=${body}
    ...    headers=${HEADERS}
    ...    expected_status=any

    [Return]    ${resp}
