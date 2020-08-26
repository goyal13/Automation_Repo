package com.test.autothon;


import io.cucumber.junit.Cucumber;
import io.cucumber.junit.CucumberOptions;
import org.junit.runner.RunWith;

@RunWith(Cucumber.class)
@CucumberOptions(
        strict = true,
        plugin = {"pretty", "junit:target/junit.xml", "json:target/cucumber-reports/cucumber.json"},
        glue = {"com.test.autothon"},
        tags = {"@sample"},
        features = "src/test/resources/features"
)
public class RunCucumberIT {
}
