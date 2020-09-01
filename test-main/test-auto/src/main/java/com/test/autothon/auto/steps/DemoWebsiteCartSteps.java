package com.test.autothon.auto.steps;

import com.test.autothon.auto.ui.DemoAddProductToCartAndCheckout;
import com.test.autothon.common.StepDefinition;
import io.cucumber.java.en.Given;
import org.junit.Assert;

public class DemoWebsiteCartSteps extends StepDefinition {

    DemoAddProductToCartAndCheckout demoAddProductToCartAndCheckout = new DemoAddProductToCartAndCheckout();

    @Given("^Add product at \"(.*?)\" to the cart$")
    public void addProductToCart(String path) {
        path = getOverlay(path);
        demoAddProductToCartAndCheckout.addProductToCart(path);
        Assert.assertTrue(demoAddProductToCartAndCheckout.verifyCartHas(path.split(">")[1]));
    }

    @Given("^Validate checkout is successful$")
    public void checkout() {
        Assert.assertTrue(demoAddProductToCartAndCheckout.doCheckout());
    }
}
