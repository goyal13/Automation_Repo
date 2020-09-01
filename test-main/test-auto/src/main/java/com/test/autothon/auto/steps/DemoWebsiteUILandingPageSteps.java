package com.test.autothon.auto.steps;

import com.test.autothon.auto.ui.DemoLandingPage;
import com.test.autothon.common.StepDefinition;
import io.cucumber.java.en.Given;
import org.junit.Assert;

public class DemoWebsiteUILandingPageSteps extends StepDefinition {

    DemoLandingPage demoLandingPage = new DemoLandingPage();

    @Given("^Validate all links on landing page are retruning 200$")
    public void checkAllLinks() {
        demoLandingPage.checkAllLinksOnLandigPageAreOk();
    }

    @Given("^Validate no of carousels in landing page is \"(.*?)\"$")
    public void validateCarouselCount(int count) {
        int actCount = demoLandingPage.noOfCarouselExist();
        Assert.assertEquals("Carousel count", count, actCount);
    }

    @Given("^Validate product category \"(.*?)\" exists in landing page$")
    public void validateProductCategory(String cat) {
        cat = getOverlay(cat);
        Assert.assertTrue(demoLandingPage.checkProductCategoryExists(cat));
    }

    @Given("^Validate Header with text \"(.*?)\" exists in landing page$")
    public void validateHeader(String text) {
        text = getOverlay(text);
        Assert.assertTrue(demoLandingPage.isHeaderPresent(text));
    }
}
