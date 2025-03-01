import http from "k6/http";
import { check } from "k6";
import { BASE_URL } from "../config/config.js";

// API tạo merchant mới
export function createMerchant(token) {
    const url = `${BASE_URL}/merchant-service/1.0.0/merchants`;
    const payload = JSON.stringify({
        // merchantId: "95cc60f8-0ef6-499b-9767-503152242eab",
        baseCurrency: "GBP",
        invoicePrefix: "INVxxxxxx",
        dueAfter: 30,
        nextInvoiceNumber: 1,
        mcc: "80-01-01",
        mccName: "SHOPPING & RETAIL",
        loyaltyEligible: true,
        category: {
            categoryName: "Retail",
            categoryCode: "RETAIL",
            riskLevel: "LOW",
            description: "Retail category for consumer goods."
        }
    });
    const params = {
        headers: {
            "Content-Type": "application/json",
            "Authorization": `Bearer ${token}`,
        },
    };
    
    const res = http.post(url, payload, params);
    check(res, { "Create Merchant status is 200": (r) => r.status === 200 });
    return res;
}

// API lấy thông tin merchant theo ID
export function getMerchantById(token) {
    const url = `${BASE_URL}/merchant-service/1.0.0/merchants/95cc60f8-0ef6-499b-9767-503152242eab`;
    const params = {
        headers: { "Authorization": `Bearer ${token}` },
    };
    
    const res = http.get(url, params);
    check(res, { "Get Merchant status is 200": (r) => r.status === 200 });
    return res;
}

// API lấy danh sách merchant (pageSize=10)
export function listMerchants(token) {
    const url = `${BASE_URL}/merchant-service/1.0.0/merchants?pageSize=10`;
    const params = {
        headers: { "Authorization": `Bearer ${token}` },
    };
    
    const res = http.get(url, params);
    check(res, { "List Merchants status is 200": (r) => r.status === 200 });
    return res;
}

// API cập nhật (PATCH) merchant
export function updateMerchant(token) {
    const url = `${BASE_URL}/merchant-service/1.0.0/merchants/95cc60f8-0ef6-499b-9767-503152242eab`;
    const payload = JSON.stringify({
        baseCurrency: "GBP",
        dueAfter: 30,
        invoicePrefix: "INVxxxxxx",
        nextInvoiceNumber: 1,
        mcc: "80-01-01",
        mccName: "SHOPPING & RETAIL",
        loyaltyEligible: true
    });
    const params = {
        headers: {
            "Content-Type": "application/json",
            "Authorization": `Bearer ${token}`,
        },
    };
    
    const res = http.patch(url, payload, params);
    check(res, { "Update Merchant status is 200": (r) => r.status === 200 });
    return res;
}
