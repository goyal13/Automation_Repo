package com.test.autothon;

import com.test.autothon.common.ReadEnvironmentVariables;
import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;
import cucumber.api.testng.AbstractTestNGCucumberTests;
import org.junit.runner.RunWith;
import org.testng.annotations.BeforeTest;
import org.testng.annotations.Parameters;

@RunWith(Cucumber.class)
@CucumberOptions(
        tags = {"@crossbrowser"},
        features = "src/test/resources",
        plugin = {"junit:target/junit.xml", "json:target/cucumber-reports/cucumber.json"}
)
public class RunCucumberITCrossBrowser extends AbstractTestNGCucumberTests {

    @Parameters({"browser", "agentUrl", "runHeadless", "runOnSauce", "runTestsonRemoteHost", "remoteHostUrl"})
    @BeforeTest()
    public void firstTestMethod(String browser, String agentUrl, String runHeadless, String runOnSauce, String runTestsonRemoteHost, String remoteHostUrl) {
        ReadEnvironmentVariables.setBrowser(browser);
        ReadEnvironmentVariables.setAgentURL(agentUrl);
        ReadEnvironmentVariables.setRunHeadless(runHeadless);
        ReadEnvironmentVariables.setRunOnSauce(runOnSauce);
        ReadEnvironmentVariables.setRunTestsonRemoteHost(runTestsonRemoteHost);
        ReadEnvironmentVariables.setRemoteHostUrl(remoteHostUrl);
    }
}
