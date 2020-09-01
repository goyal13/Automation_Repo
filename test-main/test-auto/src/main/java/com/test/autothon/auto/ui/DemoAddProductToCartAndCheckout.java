package com.test.autothon.auto.ui;

import com.test.autothon.ui.core.UIOperations;

public class DemoAddProductToCartAndCheckout extends UIOperations {

    private void navigateToCart() {
        refreshPage();
        click("xpath_//span[@class='fa-stack']");
        click("xpath_//i[@class='fas fa-shopping-cart']");
    }

    private void navigateToMainPage() {
        click("xpath_//span[@class='fa-stack']");
    }

    public void addProductToCart(String product) {
        navigateToMainPage();
        String[] productPath = product.split(">");
        click("xpath_//a[@class='nav-link' and contains(text(), '" + productPath[0] + "')]");
        click("xpath_//img[@class='card-img-top' and @alt='" + productPath[1] + "']");
        click("xpath_//button[contains(text(),' Add to Cart ')]");
        click("xpath_//button[contains(text(),'Continue Shopping')]");
    }

    public boolean verifyCartHas(String product) {
        navigateToCart();
        return getElement("xpath_//tr/td[contains(text(),'" + product + "')]").get(0).isDisplayed();
    }

    public boolean doCheckout() {
        navigateToCart();
        click("xpath_//button[contains(text(),'Checkout')]");
        enterText("id_firstName", "TestFirst");
        enterText("id_lastName", "TestLastt");
        enterText("id_email", "test@test.com");
        enterText("id_address", "Ranchi");
        selectValue("id_country", "ByValue", "IN");
        selectValue("id_state", "ByValue", "JH");
        enterText("id_zip", "825001");
        click("id_same-address");
        click("id_save-info");
        enterText("id_cc-name", "TestUser");
        enterText("id_cc-number", "888888888888888");
        enterText("id_cc-expiration", "08/22");
        enterText("id_cc-cvv", "123");
        click("xpath_//button[contains(text(),'Confirm Order')]");
        boolean isCheckoutSuccess = getElement("xpath_//div[@class='swal-icon swal-icon--success']").get(0).isDisplayed();
        click("xpath_//button[@class='swal-button swal-button--cancel']");
        return isCheckoutSuccess;
    }

}
