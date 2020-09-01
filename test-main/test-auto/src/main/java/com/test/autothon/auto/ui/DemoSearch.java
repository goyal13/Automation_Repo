package com.test.autothon.auto.ui;

import com.test.autothon.ui.core.UIOperations;
import org.openqa.selenium.WebElement;

public class DemoSearch extends UIOperations {

    public boolean searchString(String text) {
        WebElement e = getElement("id_search").get(0);
        enterText(e, text);
        return !getTextFromElement("xpath_//ul[@aria-labelledby='search']/li").equalsIgnoreCase("No Result");
    }
}
