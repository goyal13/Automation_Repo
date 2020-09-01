package com.test.autothon.auto.steps;

import com.test.autothon.auto.ui.DemoSignIn;
import com.test.autothon.common.StepDefinition;
import io.cucumber.java.en.Given;
import org.junit.Assert;

public class DemoWebisteSignInPageSteps extends StepDefinition {

    DemoSignIn demoSignIn = new DemoSignIn();

    @Given("^Validate sign with valid user credentials$")
    public void signInAccount() {
        Assert.assertTrue("Account signIn failed with valid user details", demoSignIn.signInToAccount());
    }

    @Given("^Validate signIn with username \"(.*?)\" and password \"(.*?)\" is successful$")
    public void createAccount(String username, String password) {
        username = getOverlay(username);
        password = getOverlay(password);
        Assert.assertTrue(demoSignIn.signInToAccountSuccess(username, password));
    }

    @Given("^Validate signIn with username \"(.*?)\" and password \"(.*?)\" returns error \"(.*?)\"$")
    public void createAccount(String username, String password, String expErr) {
        username = getOverlay(username);
        password = getOverlay(password);
        expErr = getOverlay(expErr);

        String actErr = demoSignIn.signInToAccount(username, password);
        Assert.assertEquals(expErr, actErr);
    }
}
