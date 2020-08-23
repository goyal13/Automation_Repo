package com.test.autothon.common;

/**
 * @author Rahul_Goyal
 */
public class ReadEnvironmentVariables {

    private static final InheritableThreadLocal<String> myBrowser = new InheritableThreadLocal();
    private static final InheritableThreadLocal<String> agentURL = new InheritableThreadLocal();
    private static final InheritableThreadLocal<String> runHeadless = new InheritableThreadLocal();
    private static final InheritableThreadLocal<String> runOnSauce = new InheritableThreadLocal();
    private static final InheritableThreadLocal<String> runTestsonRemoteHost = new InheritableThreadLocal();
    private static final InheritableThreadLocal<String> remoteHostUrl = new InheritableThreadLocal();

    private static ReadEnvironmentVariables instance = new ReadEnvironmentVariables();

    private static ReadEnvironmentVariables getInstance() {
        return instance;
    }

    public static String getEnvironment() {
        return System.getProperty("env", "dev");
    }

    // https://wiki.saucelabs.com/display/DOCS/Platform+Configurator#/
    public static void setBrowser(String value) {
        myBrowser.set(value);
    }

    public static String getBrowserName() {
        String browserName = myBrowser.get();
        if (browserName.equals(""))
            browserName = System.getProperty("browserName", "Chrome");
        return browserName;
    }

    public static void setRunOnSauce(String value) {
        runOnSauce.set(value);
    }

    public static boolean isRunOnSauceBrowser() {
        boolean isRunOnSauce = false;
        String runOnSauce_ = runOnSauce.get();
        if (runOnSauce_.equals(""))
            runOnSauce_ = System.getProperty("runOnSauce", "false");
        if (runOnSauce_.equalsIgnoreCase("true"))
            isRunOnSauce = true;
        return isRunOnSauce;
    }

    public static void setRunHeadless(String value) {
        runHeadless.set(value);
    }

    public static boolean isHeadlessBrowser() {
        boolean isBoolHeadless = false;
        String isHeadless_ = runHeadless.get();
        if (isHeadless_.equals(""))
            isHeadless_ = System.getProperty("runHeadless", "false");
        if (isHeadless_.equalsIgnoreCase("true"))
            isBoolHeadless = true;
        return isBoolHeadless;
    }

    public static void setRunTestsonRemoteHost(String value) {
        runTestsonRemoteHost.set(value);
    }

    public static boolean isRunTestsOnRemoteHost() {
        boolean isRunTestsOnRemote = false;
        String runTestsonRemoteHost_ = runTestsonRemoteHost.get();
        if (runTestsonRemoteHost_.equals(""))
            runTestsonRemoteHost_ = System.getProperty("runTestsonRemoteHost", "false");
        if (runTestsonRemoteHost_.equalsIgnoreCase("true"))
            isRunTestsOnRemote = true;
        return isRunTestsOnRemote;
    }

    public static String getAgentURL() {
        String agentURL_ = agentURL.get();
        if (agentURL_.equals(""))
            agentURL_ = System.getProperty("runTestsonRemoteHost", "false");
        return agentURL_;
    }

    public static void setAgentURL(String value) {
        agentURL.set(value);
    }

    public static String getRemoteHostUrl() {
        String remoteHostUrl_ = remoteHostUrl.get();
        if (remoteHostUrl_.equals(""))
            remoteHostUrl_ = System.getProperty("remoteHostUrl", "").trim();
        return remoteHostUrl_;
    }

    public static void setRemoteHostUrl(String value) {
        remoteHostUrl.set(value);
    }

}
