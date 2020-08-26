package com.test.autothon.common;


import io.cucumber.java.After;
import io.cucumber.java.Before;
import io.cucumber.java.Scenario;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;

import static com.test.autothon.common.ReadPropertiesFile.loadAllPropertiesValue;
import static com.test.autothon.common.ScreenshotUtils.getImgSrcFilePath;

/**
 * @author Rahul_Goyal
 */
public class Hooks {

    private final static Logger logger = LogManager.getLogger(Hooks.class);
    public static String scenarioName;

    @Before
    public void beforeExecution(Scenario scenario) {
        scenarioName = scenario.getName();
        scenarioName = scenarioName.replaceAll("\\s", "_");
        logger.info("Start Executing Scenario : [ " + scenarioName + " ]");
        logger.info("Deleting temp properties file");
        loadAllPropertiesValue();
        FileUtils.deleteFile(Constants.tempFileLocation);
        ScreenshotUtils.initialize();
        //CustomHtmlReport.initialize();
    }

    @After
    public void afterExecution(Scenario scenario) {
        logger.info("Scenario Executions Ends");
        try {
            ScreenshotUtils.writeImagesToHTMLFile();
        } catch (IOException e) {
            e.printStackTrace();
        }
        //CustomHtmlReport.writeToHtmlReportFile();
    }

}
