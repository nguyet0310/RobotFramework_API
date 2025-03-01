Documentation      Keep all libraries and endpoints here so no need to again call them at test layer
*** Settings ***
Library     RequestsLibrary
Library     Collections
Library     JSONLibrary
Library     OperatingSystem
Library     String
Library     os
Library     ../Utilities/CustomLibrary.py

*** Variables ***
${base_url}           https://restful-booker.herokuapp.com
${ping_endpoint}      /ping
${auth_endpoint}      /auth
${booking_endpoint}   /booking
${username}           admin
${correct_pwd}        password123
${incorrect_pwd}      yuyrtuop
${counter}            ${1}
${checkin}            2023-08-30
${checkout}           2023-09-10
${firstname}          VietName
${lastname}           Hanoi
${put_firstname}      Moon
${put_lastname}       Nguyen
${patch_firstname}    Anny
${Patch_lastname}     Mai