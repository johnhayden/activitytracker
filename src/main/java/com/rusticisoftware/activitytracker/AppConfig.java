package com.rusticisoftware.activitytracker;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

/**
 * This class basically exposes a properties file as set of static config parameters for convenience.
 *
 * <p>Note that the web server can be started with a system property -Dactivitytracker.properties=/mydir/my.properties
 * These settings will override the default settings for the activity tracker.  In fact, they must be defined
 * in order to specify credentials for the LRS.
 */
public class AppConfig implements ServletContextListener{

    static Properties properties = new Properties();

    public static File appHome;
    public static File activityDataFile;
    public static File verbsDataFile;
    public static String newActivityIdPrefix;
    public static String pageTitle;
    public static String lrsUrl;
    public static String lrsId;
    public static String lrsPassword;
    public static String verblistUrl;

    private static final String DEFAULT_PROPERTIES_RESOURCE_NAME = "/activitytracker-default.properties";

    public void contextInitialized(ServletContextEvent e) {

        try {
            loadPropertiesFromResource(properties, DEFAULT_PROPERTIES_RESOURCE_NAME);

            String propertyOverridesFile = System.getProperty("activitytracker.properties");
            if (propertyOverridesFile != null && propertyOverridesFile.length() > 0) {
                File customPropertiesFile = new File(propertyOverridesFile);
                if (customPropertiesFile.exists()) {
                    properties.load(new FileReader(customPropertiesFile));
                    System.out.println("Properties override file found: " + propertyOverridesFile);
                } else {
                    System.err.println("Properties override file doesn't exist: " + propertyOverridesFile);
                }
            }



        } catch (IOException e1) {
            e1.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
        }


        appHome = new File(properties.getProperty("application.data.dir"));
        verbsDataFile = new File(appHome, "verbs.json");
        activityDataFile = new File(appHome, "activities.json");

        pageTitle = properties.getProperty("application.page.title");
        newActivityIdPrefix = properties.getProperty("new.activityid.prefix");

        lrsUrl = properties.getProperty("lrs.url");
        lrsId = properties.getProperty("lrs.id");
        lrsPassword = properties.getProperty("lrs.password");

        verblistUrl = properties.getProperty("verblist.url");

    }

    @Override
    public void contextDestroyed(ServletContextEvent servletContextEvent) {

    }

    // Attempts to load properties from the specified resource into the specified Properties object. If the resource
    // is not found, nothing is loaded. If the resource is found but cannot be read, an IOException is thrown.
    private static void loadPropertiesFromResource(Properties properties, String propertiesResource) throws IOException {
        InputStream propertiesStream = AppConfig.class.getResourceAsStream(propertiesResource);
        if (propertiesStream != null) {
            try {
                properties.load(propertiesStream);
            } catch (IOException e) {
                throw e;
            } finally {
                propertiesStream.close();
            }
        } else {

        }
    }

}
