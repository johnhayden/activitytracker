package com.rusticisoftware.activitytracker;

import com.rusticisoftware.tincan.*;

public class SubmitStatementAction {

    private String actor;
    private String verb;
    private String activity;

    private static final String ACTIVITY_PREFIX = "http://boozallen.com/tcapi/activity/";

    public SubmitStatementAction(String actor, String verb, String activity) {
        this.actor = actor;
        this.verb = verb;
        this.activity = activity;
    }

    public void process() throws Exception {

        // Create a statement and post it.

        RemoteLRS lrs = new RemoteLRS();

        lrs.setEndpoint("https://cloud.scorm.com/ScormEngineInterface/TCAPI/john/");
        lrs.setUsername("john");
        lrs.setPassword("32wE8eRYmMKy5Rcl171ZrR3lSIj2a4QyZXbwWZE7");

        //lrs.setEndpoint("https://johnnyhayden.waxlrs.com/TCAPI/");
        //lrs.setUsername("FDMSzgEvCrqVPKJaJPKN");
        //lrs.setPassword("6PuQHKbB5DQkYjeK7Clg");

        lrs.setVersion(TCAPIVersion.V095);

        Statement st = new Statement();
        Agent agent = new Agent();
        //agent.setMbox("mailto:tincanjava-test-tincan@tincanapi.com");
        agent.setMbox("mailto:" + this.actor);
        Verb verb = new Verb(this.verb);

        //Activity activity = new Activity("http://tincanapi.com/TinCanJava/Test/RemoteLRSTest_mockActivity/" + suffix);

        Activity activity;
        if (this.activity.toLowerCase().startsWith("http")) {
            activity = new Activity(this.activity);
            ActivityDefinition activityDefinition = new ActivityDefinition();
            LanguageMap map = new LanguageMap();
            map.put("en-US", "my Description");
            activityDefinition.setDescription(map);
            activity.setDefinition(activityDefinition);
        } else {
            activity = new Activity(ACTIVITY_PREFIX + this.activity.replaceAll(" ", "-"));
            ActivityDefinition activityDefinition = new ActivityDefinition();
            LanguageMap map = new LanguageMap();
            map.put("en-US", this.activity);
            activityDefinition.setDescription(map);
            activity.setDefinition(activityDefinition);
        }

        //st.stamp(); // triggers a PUT
        st.setActor(agent);
        st.setVerb(verb);
        st.setObject(activity);

        lrs.saveStatement(st);
    }
}
