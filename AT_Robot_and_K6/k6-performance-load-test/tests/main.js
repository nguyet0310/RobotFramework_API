import { group, sleep } from "k6";
import { textSummary } from "https://jslib.k6.io/k6-summary/0.0.1/index.js";
import { htmlReport } from "https://raw.githubusercontent.com/benc-uk/k6-reporter/main/dist/bundle.js";
import { getToken } from "../lib/token.js";
import { createMerchant, getMerchantById, listMerchants, updateMerchant } from "../lib/api.js";

export let options = {
    vus: 10,          
    duration: "30s",  
};

export default function () {
    const token = getToken();

    group("Create Merchant", () => {
        createMerchant(token);
    });

    group("Get Merchant by ID", () => {
        getMerchantById(token);
    });

    group("List Merchants", () => {
        listMerchants(token);
    });

    group("Update Merchant", () => {
        updateMerchant(token);
    });

    sleep(1); 
}

export function handleSummary(data) {
  return {
    "./reports/report.html": htmlReport(data),
    stdout: textSummary(data, { indent: " ", enableColors: true }),
  };
}