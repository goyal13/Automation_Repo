package com.test.autothon.auto.ui;

import com.test.autothon.ui.core.UIOperations;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.openqa.selenium.WebElement;

import java.util.List;

public class DemoLandingPage extends UIOperations {
    private final static Logger logger = LogManager.getLogger(DemoLandingPage.class);

    public boolean checkAllLinksOnLandigPageAreOk() {
        boolean allOK = false;
        List<WebElement> urls = getElement("tagname_a");
        for (WebElement url : urls) {
            allOK = !isLinkBroken(url.getAttribute("href"));
            logger.info("Link: " + url + " isOK ? " + allOK);
            if (!allOK)
                break;
        }

        return allOK;
    }

    public int noOfCarouselExist() {
        List<WebElement> carousels = getElement("xpath_//div[@class='carousel-inner']/div");
        return carousels.size();
    }

    public boolean checkProductCategoryExists(String product) {
        WebElement ele = getElement("linktext_" + product).get(0);
        return ele.isDisplayed();
    }

    public boolean isHeaderPresent(String text) {
        WebElement e = getElement("xpath_//li[contains(text,'" + text + "')]").get(0);
        return e.isDisplayed();
    }

}
