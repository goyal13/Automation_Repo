package com.test.autothon;

import com.aventstack.extentreports.cucumber.adapter.ExtentCucumberAdapter;
import com.test.autothon.common.ReadEnvironmentVariables;
import io.cucumber.java.Before;
import io.cucumber.junit.Cucumber;
import io.cucumber.testng.AbstractTestNGCucumberTests;
import io.cucumber.testng.CucumberOptions;
import org.junit.runner.RunWith;
import org.testng.ITestResult;
import org.testng.Reporter;
import org.testng.annotations.BeforeTest;
import org.testng.annotations.Parameters;

@RunWith(Cucumber.class)
@CucumberOptions(
        strict = true,
        plugin = {"com.aventstack.extentreports.cucumber.adapter.ExtentCucumberAdapter:", "pretty", "junit:target/junit.xml", "json:target/cucumber-reports/cucumber.json"},
        glue = {"com.test.autothon"},
        tags = {"@UI and @Sanity1"},
        features = "src/test/resources/features"
)
public class RunCucumberITCrossBrowser extends AbstractTestNGCucumberTests {


    @Parameters({"browser", "agentUrl", "runHeadless", "runOnSauce", "runTestsonRemoteHost", "remoteHostUrl"})
    @BeforeTest()
    public void firstTestMethod(String browser, String agentUrl, String runHeadless, String runOnSauce, String runTestsonRemoteHost, String remoteHostUrl) {
        System.out.println(getPrefix() + "\t\tBrowser: " + browser + " \t\t\tRunHeadless: " + runHeadless + " \tRunOnCloud: " + runOnSauce
                + " \tRunTestsOnRemoteHost: " + runTestsonRemoteHost + " \tRemoteHostURL: " + remoteHostUrl + "\tAgentURL: " + agentUrl);
        ReadEnvironmentVariables.setBrowser(browser);
        ReadEnvironmentVariables.setAgentURL(agentUrl);
        ReadEnvironmentVariables.setRunHeadless(runHeadless);
        ReadEnvironmentVariables.setRunOnSauce(runOnSauce);
        ReadEnvironmentVariables.setRunTestsonRemoteHost(runTestsonRemoteHost);
        ReadEnvironmentVariables.setRemoteHostUrl(remoteHostUrl);
    }

    @Before("@UI")
    public void beforeRun() {
        ExtentCucumberAdapter.addTestStepLog("Test: " + getPrefix());
    }

    private String getPrefix() {
        try {
            ITestResult result = Reporter.getCurrentTestResult();
            return result.getTestContext().getName();
        }catch (Exception e){
            return "Test";
        }

    }
}
