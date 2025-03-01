import { group, sleep } from "k6";
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
