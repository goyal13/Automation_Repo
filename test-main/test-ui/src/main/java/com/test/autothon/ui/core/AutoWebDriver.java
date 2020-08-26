package com.test.autothon.ui.core;

import com.test.autothon.common.ReadEnvironmentVariables;
import io.testproject.sdk.drivers.TestProjectCapabilityType;
import io.testproject.sdk.drivers.web.ChromeDriver;
import io.testproject.sdk.drivers.web.EdgeDriver;
import io.testproject.sdk.drivers.web.FirefoxDriver;
import io.testproject.sdk.drivers.web.InternetExplorerDriver;
import io.testproject.sdk.internal.exceptions.AgentConnectException;
import io.testproject.sdk.internal.exceptions.InvalidTokenException;
import io.testproject.sdk.internal.exceptions.ObsoleteVersionException;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.openqa.selenium.UnsupportedCommandException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.edge.EdgeOptions;
import org.openqa.selenium.firefox.FirefoxOptions;
import org.openqa.selenium.ie.InternetExplorerOptions;
import org.openqa.selenium.remote.DesiredCapabilities;
import org.openqa.selenium.remote.RemoteWebDriver;
import org.openqa.selenium.safari.SafariOptions;

import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.concurrent.TimeUnit;

//import org.openqa.selenium.remote.RemoteWebDriver;

public class AutoWebDriver {

    private final static Logger logger = LogManager.getLogger(AutoWebDriver.class);
    private final static String TP_DEV_TOKEN = "mCkeg_nuE9ycBZIfa7MvoBoeBbemi6Ke0Ac94mZitCI1";
    private static final String USERNAME = "teamoneautothon1";
    private static final String ACCESS_KEY = "TWSsyvBQWL9cJyuNxpVi";
    private static final String PROJECT_NAME = "Autothon Tests";
    private static String CLOUD_URL = "https://" + USERNAME + ":" + ACCESS_KEY + "@hub-cloud.browserstack.com/wd/hub";
    private String AGENT_URL = ReadEnvironmentVariables.getAgentURL();
    private WebDriver driver;

    public AutoWebDriver() {
        createWebDriver();
    }

    public void tearBrowser() {
        if (driver != null) {
            logger.info("closing existing running instance of webdriver...");
            try {
                driver.close();
                driver.quit();
            } catch (Exception e) {
                logger.warn(e);
            }
            driver = null;
        }
    }

    private void createWebDriver() {

        String browser = ReadEnvironmentVariables.getBrowserName();
        logger.info("Initializing WebDriver...");
        browser = browser.trim().toLowerCase();

        logger.info("Browser used for testing will be --- :" + browser);
        switch (browser) {
            case "chrome":
                chromeDriver();
                break;
            case "ie":
                ieDriver();
                break;
            case "edge":
                edgeDriver();
                break;
            case "firefox":
                fireFoxDriver();
                break;
            case "mobile_chrome":
                mobileChromeDriver();
                break;
            case "safari":
                safariDriver();
                break;
            case "mobile_ios":
                mobileIOSDriver();
                break;


            default:
                logger.info("Invalid browser name");
                try {
                    throw new Exception("Invalid browser name");
                } catch (Exception e) {
                    logger.error("Invalid Browser...Please provide correct browser name" + e);
                }
        }
        Runtime.getRuntime().addShutdownHook(new Thread() {
            public void run() {
                tearBrowser();
            }
        });

        driver.manage().deleteAllCookies();

        if (!browser.contains("mobile_")) {
            try {
                driver.manage().window().maximize();
            } catch (UnsupportedCommandException | UnsupportedOperationException e) {
                logger.error("Driver does not support maximize");
            }
        }
        driver.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
    }

    private void ieDriver() {
        if (null != driver)
            return;

        DesiredCapabilities capabilities = DesiredCapabilities.internetExplorer();
        InternetExplorerOptions internetExplorerOptions = new InternetExplorerOptions(capabilities);
        if (ReadEnvironmentVariables.isRunTestsOnRemoteHost()) {
            createRemoteDriverWithCapabilities(capabilities);
            return;
        }
        if (null == driver) {
            logger.info("Initializing IE browser");
            try {
                driver = new InternetExplorerDriver(new URL(AGENT_URL), TP_DEV_TOKEN, internetExplorerOptions);
            } catch (InvalidTokenException | ObsoleteVersionException | MalformedURLException | AgentConnectException e) {
                e.printStackTrace();
            }
        }
    }

    private void edgeDriver() {
        if (null != driver)
            return;

        EdgeOptions edgeOptions = new EdgeOptions();

        if (ReadEnvironmentVariables.isRunOnSauceBrowser())
            edgeOptions.setCapability(TestProjectCapabilityType.CLOUD_URL, CLOUD_URL);

        DesiredCapabilities capabilities = new DesiredCapabilities(edgeOptions);

        if (ReadEnvironmentVariables.isRunTestsOnRemoteHost()) {
            createRemoteDriverWithCapabilities(capabilities);
            return;
        }

        if (null == driver) {
            logger.info("Initializing Edge browser");
            try {
                driver = new EdgeDriver(new URL(AGENT_URL), TP_DEV_TOKEN, edgeOptions, PROJECT_NAME, PROJECT_NAME, false);
            } catch (InvalidTokenException | ObsoleteVersionException | AgentConnectException | IOException e) {
                e.printStackTrace();
            }
        }
    }

    private void chromeDriver() {
        if (null != driver)
            return;

        logger.info("Initializing Chrome browser - isHeadless :  " + ReadEnvironmentVariables.isHeadlessBrowser());

        ChromeOptions chromeOptions = new ChromeOptions();
        chromeOptions.setHeadless(ReadEnvironmentVariables.isHeadlessBrowser());
        chromeOptions.addArguments("start-maximized"); // open Browser in maximized mode
        chromeOptions.addArguments("disable-infobars"); // disabling infobars
        chromeOptions.addArguments("--disable-extensions"); // disabling extensions
        chromeOptions.addArguments("--disable-gpu"); // applicable to windows os only
        chromeOptions.addArguments("--disable-dev-shm-usage"); // overcome limited resource problems
        chromeOptions.addArguments("--no-sandbox"); // Bypass OS security model

        if (ReadEnvironmentVariables.isRunOnSauceBrowser())
            chromeOptions.setCapability(TestProjectCapabilityType.CLOUD_URL, CLOUD_URL);

        DesiredCapabilities capabilities = new DesiredCapabilities(chromeOptions);

        if (ReadEnvironmentVariables.isRunTestsOnRemoteHost()) {
            createRemoteDriverWithCapabilities(capabilities);
            return;
        }

        try {
            driver = new ChromeDriver(new URL(AGENT_URL), TP_DEV_TOKEN, chromeOptions, PROJECT_NAME, PROJECT_NAME, false);
        } catch (InvalidTokenException | AgentConnectException | IOException | ObsoleteVersionException e) {
            e.printStackTrace();
        }

    }

    private void fireFoxDriver() {
        if (null != driver)
            return;

        logger.info("Initializing Firefox browser - isHeadless :  " + ReadEnvironmentVariables.isHeadlessBrowser());

        FirefoxOptions firefoxOptions = new FirefoxOptions();
        firefoxOptions.setHeadless(ReadEnvironmentVariables.isHeadlessBrowser());

        if (ReadEnvironmentVariables.isRunOnSauceBrowser())
            firefoxOptions.setCapability(TestProjectCapabilityType.CLOUD_URL, CLOUD_URL);

        DesiredCapabilities capabilities = new DesiredCapabilities(firefoxOptions);

        if (ReadEnvironmentVariables.isRunTestsOnRemoteHost()) {
            createRemoteDriverWithCapabilities(capabilities);
            return;
        }

        System.setProperty(FirefoxDriver.SystemProperty.BROWSER_LOGFILE, "/dev/null");
        try {
            driver = new FirefoxDriver(new URL(AGENT_URL), TP_DEV_TOKEN, firefoxOptions, PROJECT_NAME, PROJECT_NAME, false);
        } catch (InvalidTokenException | ObsoleteVersionException | IOException | AgentConnectException e) {
            e.printStackTrace();
        }

    }

    private void safariDriver() {
        if (null != driver)
            return;

        SafariOptions safariOptions = new SafariOptions();
        safariOptions.setCapability("safari.cleanSession", true);
        DesiredCapabilities cap = new DesiredCapabilities(safariOptions);
        createRemoteDriverWithCapabilities(cap, CLOUD_URL);
    }

    private void mobileChromeDriver() {
        if (null != driver)
            return;

        DesiredCapabilities caps = new DesiredCapabilities();
        caps.setCapability("browserName", "android");
        createRemoteDriverWithCapabilities(caps, CLOUD_URL);

    }

    private void mobileIOSDriver() {
        if (null != driver)
            return;

        DesiredCapabilities caps = new DesiredCapabilities();
        caps.setCapability("browserName", "iPhone");
        createRemoteDriverWithCapabilities(caps, CLOUD_URL);

    }

    private void createRemoteDriverWithCapabilities(DesiredCapabilities capabilities) {
        String remoteURL = ReadEnvironmentVariables.getRemoteHostUrl();
        logger.info("Running Tests on Remote Host : " + remoteURL);
        try {
            driver = new RemoteWebDriver(new URL(remoteURL), capabilities);
        } catch (MalformedURLException e) {
            e.printStackTrace();
        }
    }

    private void createRemoteDriverWithCapabilities(DesiredCapabilities capabilities, String remoteURL) {
        logger.info("Running Tests on Remote Host : " + remoteURL);
        try {
            driver = new RemoteWebDriver(new URL(remoteURL), capabilities);
        } catch (MalformedURLException e) {
            e.printStackTrace();
        }
    }

    protected WebDriver getDriver() {
        return driver;
    }
}
