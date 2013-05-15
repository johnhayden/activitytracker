<!DOCTYPE html>
<html lang="en">

<head>
    <title>Activity Tracker</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="">

    <link href="assets/css/bootstrap.css" rel="stylesheet">
    <style>
    body {
        background-color: #CCC;
        padding-top: 60px; /* 60px to make the container go all the way to the bottom of the topbar */
    }
    </style>
    <link href="assets/css/bootstrap-responsive.css" rel="stylesheet">

</head>

<body>

<div class="navbar navbar-inverse navbar-fixed-top">
    <div class="navbar-inner">
            <a class="brand" href="#" class="brand" href="#">&nbsp;Mentoring Circles Activity Tracker</a>
    </div>
</div>

<form name="statementForm" action="controller?action=submitStatement" method=POST>
<div class="container" style="background-color: white; padding: 12px; border-radius: 10px;">
    <div class="row-fluid">
            <div class="span4 text-center input-large">
                <h3>I</h3>
                <input type="email" name="actor" placeholder="Email Address">
            </div>
            <div class="span4 text-center input-large">
                <h3>Did</h3>
                <input name="verbList" autocomplete="off" placeholder="Verb" type='text' id='verb-typeahead' data-provide='typeahead' />
                <input name="verb" id="verb" type="hidden" />
            </div>
            <div class="span4 text-center input-large">
                <h3>This</h3>
                <input name="activityList" autocomplete="off" placeholder="Activity" type='text' id='activity-typeahead' data-provide='typeahead' />
                <input name="activityId" id="activityId" type="hidden" />
            </div>
            <div class="">
                <input type="submit" value="Submit" class="btn btn-primary pull-right">
            </div>
    </div>
</div>
</form>

<script src="assets/jquery-1.9.1.min.js"></script>
<script src="assets/js/bootstrap.min.js"></script>
<script>

    var activityDescriptions = [];
    var activityMap = {};
    var isActivityListLoaded = false;

    var verbDescriptions = [];
    var verbMap = {};
    var isVerbListLoaded = false;

    $(document).ready(function() {

        $('#activity-typeahead').typeahead({
            source: function(query, process) {

                if (isActivityListLoaded)
                    return activityDescriptions;

                return $.ajax({
                    url: "controller?action=getVerbs",
                    type: 'get',
                    data: {query: query},
                    dataType: 'json',
                    success: function(jsonOptionMap) {

                        //For each object label=>value in the json, store the labels in the array, and mapping array with label => value    form.
                        $.each(jsonOptionMap, function (i, item) {
                            activityMap[item.name] = item.value
                            activityDescriptions.push(item.name)
                        });

                        isActivityListLoaded = true;
                        return process(activityDescriptions);
                    }
                });
            },
            updater: function (name) {
                //For the Label selected ( item ) get the value mapped from the mapping array and set it to hidden element

                alert(activityMap[name]);
                if (activityMap[name]) {
                    $('#activityId').val(activityMap[name]);
                } else {
                    //Construct a new activity server-side using the name
                    $('#activityId').val(name);
                }

                //Return the label selected to the typeahead element
                return name;
            }
        }).blur(validateActivity);

        $('#verb-typeahead').typeahead({
            source: function(query, process) {

                if (isVerbListLoaded)
                    return verbDescriptions;

                return $.ajax({
                    url: "https://registry.tincanapi.com/api/registry/uris/verb",
                    type: 'get',
                    data: {query: query},
                    dataType: 'json',
                    success: function(jsonOptionMap) {

                        //For each object label=>value in the json, store the labels in the array, and mapping array with label => value    form.
                        $.each(jsonOptionMap, function (i, item) {
                            if (item.metadata.metadata.name["en-us"]) {
                                verbMap[item.metadata.metadata.name["en-us"]] = item.uri;
                                verbDescriptions.push(item.metadata.metadata.name["en-us"]);
                            } else if (item.metadata.metadata.name["en-US"]) {
                                verbMap[item.metadata.metadata.name["en-US"]] = item.uri;
                                verbDescriptions.push(item.metadata.metadata.name["en-US"]);
                            }
                        });

                        isVerbListLoaded = true;
                        return process(verbDescriptions);
                    }
                });
            },
            updater: function (name) {
                alert('yo verb');
                //For the Label selected ( item ) get the value mapped from the mapping array and set it to hidden element
                $('#verb').val(verbMap[name]);

                //Return the label selected to the typeahead element
                return name;
            }
        }).blur(validateVerb);


    });

    function validateVerb() {
        if ($.inArray($(this).val(), verbDescriptions) == -1) {
            alert('Error : element not in list! ');
            $('#verb-typeahead').val("");
            $('#verb').val("");
        }
    }

    function validateActivity() {
        if ($.inArray($(this).val(), verbDescriptions) == -1) {
            alert('You are about ready to define a new verb');
            $('#activityId').val($(this).val());
        }
    }


</script>
</body>

</html>
