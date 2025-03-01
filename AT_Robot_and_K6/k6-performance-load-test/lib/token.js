import http from "k6/http";
import { check } from "k6";
import { BASE_URL, CLIENT_ID, REDIRECT_URI, REFRESH_TOKEN } from "../config/config.js";

export function getToken() {
    const url = `${BASE_URL}/identity-service/1.0.0/token`;
    const payload = JSON.stringify({
        clientId: CLIENT_ID,
        redirectUri: REDIRECT_URI,
        grantType: "refresh_token",
        refreshToken: REFRESH_TOKEN,
    });
    const params = {
        headers: { "Content-Type": "application/json" },
    };
    
    const res = http.post(url, payload, params);
    check(res, { "Token status is 200": (r) => r.status === 200 });
    
    // Trích xuất id_token từ phản hồi
    return res.json().id_token;
}
