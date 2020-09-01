package com.test.autothon.auto.ui;

import com.test.autothon.ui.core.UIOperations;

public class DemoSignIn extends UIOperations {

    private void navigateToSignIN() {
        refreshPage();
        click("xpath_//span[@class='fa-stack']");
        click("xpath_//a[contains(text(),'Sign In')]");
    }

    public boolean signInToAccount() {
        navigateToSignIN();
        String user = getOverlay("<PROPVALUE(username_test_signup_completed)>");
        String password = getOverlay("<PROPVALUE(PASSWORD)>");
        enterText("xpath_//input[@placeholder='Enter your Username']", user);
        enterText("xpath_//input[@placeholder='Enter your password']", password);
        click("xpath_//button[@data-test='sign-in-sign-in-button']");
        waitForSecond(5);
        return getElement("xpath_//a[contains(text(),'" + user + "')]").get(0).isDisplayed();
    }

    public boolean signInToAccountSuccess(String user, String password) {
        navigateToSignIN();
        enterText("xpath_//input[@placeholder='Enter your Username']", user);
        enterText("xpath_//input[@placeholder='Enter your password']", password);
        click("xpath_//button[@data-test='sign-in-sign-in-button']");
        waitForSecond(5);
        return getElement("xpath_//a[contains(text(),'" + user + "')]").get(0).isDisplayed();
    }

    public String signInToAccount(String user, String password) {
        navigateToSignIN();
        enterText("xpath_//input[@placeholder='Enter your Username']", user);
        enterText("xpath_//input[@placeholder='Enter your password']", password);
        click("xpath_//button[@data-test='sign-in-sign-in-button']");
        return getTextFromElement("xpath_//div[@class='error']");
    }
}
