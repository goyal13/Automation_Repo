package com.test.autothon.auto.ui;

import com.test.autothon.ui.core.UIOperations;

public class DemoCreateAccount extends UIOperations {

    private void navigateToCreateAccount() {
        refreshPage();
        click("xpath_//span[@class='fa-stack']");
        click("xpath_//a[contains(text(),'Sign In')]");
        click("xpath_//a[contains(text(),'Create account')]");
    }

    public boolean createAccount() {
        navigateToCreateAccount();
        String username = getOverlay("testautothonteam1UI_<GENERATE_TIMESTAMP(ddMMyyyyHHmmssSSS)>");
        String password = getOverlay("<PROPVALUE(PASSWORD)>");
        String email = getOverlay("<PROPVALUE(EMAIL_ID)>");
        enterText("xpath_//input[@placeholder='Username']", username);
        enterText("xpath_//input[@placeholder='Password']", password);
        enterText("xpath_//input[@placeholder='Email']", email);
//        selectValue("xpath_//option[@data-test='dial-code-select']","ByValue","91");
        enterText("xpath_//input[@placeholder='Phone Number']", "9619273725");
        click("xpath_//button[@data-test='sign-up-create-account-button']");
        return getTextFromElement("xpath_//div[@data-test='confirm-sign-up-header-section']").equalsIgnoreCase("Confirm Sign Up");

    }

    public String createAccount(String username, String password, String email, String phoneno) {
        navigateToCreateAccount();
        enterText("xpath_//input[@placeholder='Username']", username);
        enterText("xpath_//input[@placeholder='Password']", password);
        enterText("xpath_//input[@placeholder='Email']", email);
//        selectValue("xpath_//option[@data-test='dial-code-select']","ByValue","91");
        enterText("xpath_//input[@placeholder='Phone Number']", phoneno);
        click("xpath_//button[@data-test='sign-up-create-account-button']");
        return getTextFromElement("xpath_//div[@class='error']");
    }
}
