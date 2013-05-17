Activity Tracker
===============
Simple Activity Tracker for Tin Can API

The application is a simple "I did this" application.

* The "I" is an email address.
* The "Did" is a verb contrained to the pre-defined verb list (by default, from registry.tincanapi.com)
* The "This" is an activity which can come from a list of existing activities in the system or a new activity
can be created on-the-fly if desired.  Through "type ahead" discoverability it is hoped that most unnecessary
new activity creation can be avoided when the activity has been seen before.

Features
--------
* Configurable (title, new verb prefix, verb list url, lrs info, etc)
* Verbs and Activities are discoverable via "type ahead" functionality
* Responsive UI - adjust to phone, tablet, desktop as appropriate.
* Utilizes the Java TinCan client lib
* By default utilizes the verb list hosted at https://registry.tincanapi.com/
* Previously entered activities are "discoverable" through autocomplete to some degree.

Installation
------------
This is a simple web application packaged as a .war.  There is no dependency on external database but filesystem
access is necessary to maintain the list of activities created on-the-fly.

1. Clone repository*
2. mvn package
3. Create a directory to hold the non-war application data files. (ex: /usr/local/activitytracker).
4. Copy the activitytracker.properties.template to this new directory as activitytracker.properties.
5. Modify the properties file as appropriate.  This includes specifying the Tin Can API endpoint and credentials.
6. Deploy the activitytracker.war to an web container of your choice (ex: Jetty)
7. Launch the web container with the parameter -Dactivitytracker.properties=<file_path_to_your_properties>

*NOTE: You will need to clone https://github.com/RusticiSoftware/TinCanJava.git and issue "mvn install" so this
dependency is avaiable in your local repository.


