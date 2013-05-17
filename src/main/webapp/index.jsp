<%@ page import="com.rusticisoftware.activitytracker.AppConfig" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <title><%=AppConfig.pageTitle%></title>
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
            <a class="brand" href="#" class="brand" href="#">&nbsp;<%=AppConfig.pageTitle%></a>
        <% if (request.getParameter("success") != null && request.getParameter("success").startsWith("t")) { %>
        <div id="successMessage" class="btn-large text-success pull-right">Statement Recorded</div>
        <% } %>
    </div>

</div>

<form name="statementForm" action="controller?action=submitStatement" method=POST>
<div class="container" style="background-color: white; padding: 12px; border-radius: 10px;">
    <div class="row-fluid">
            <div class="span4 text-center input-large">
                <h3>I</h3>
                <input type="email" id="actor" name="actor" placeholder="Email Address" value="<%=(request.getParameter("email") == null) ? "" : request.getParameter("email")%>">
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
            <div class="pull-right">

                <input type="submit" value="Submit" class="btn btn-primary ">
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
                    url: "controller?action=getActivities",
                    type: 'get',
                    data: {query: query},
                    dataType: 'json',
                    success: function(jsonOptionMap) {

                        //For each object label=>name in the json, store the labels in the array, and mapping array with label => name    form.
                        $.each(jsonOptionMap, function (i, item) {
                            activityMap[item.name] = item.id;
                            activityDescriptions.push(item.name);
                        });

                        isActivityListLoaded = true;
                        return process(activityDescriptions);
                    }
                });
            },
            updater: function (name) {
                //For the Label selected ( item ) get the name mapped from the mapping array and set it to hidden element
                if (activityMap[name]) {
                    $('#activityId').val(activityMap[name]);
                } else {
                    //Construct a new activity server-side using the id
                    $('#activityId').val(name);
                }

                //Return the label selected to the typeahead element
                return name;
            }
        }).blur(function() {setTimeout(validateActivity, 200);}); //Special technique to deal with the fact click is triggered after blur

        $('#verb-typeahead').typeahead({
            source: function(query, process) {

                if (isVerbListLoaded)
                    return verbDescriptions;

                return $.ajax({
                    url: "<%=AppConfig.verblistUrl%>",
                    type: 'get',
                    data: {query: query},
                    dataType: 'json',
                    success: function(jsonOptionMap) {

                        //For each object label=>name in the json, store the labels in the array, and mapping array with label => name    form.
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
                //For the Label selected ( item ) get the name mapped from the mapping array and set it to hidden element
                $('#verb').val(verbMap[name]);

                //Return the label selected to the typeahead element
                return name;
            }
        }).blur(function() {setTimeout(validateVerb, 200);});

        $("form").submit(function() {

            if ($("#verb-typeahead").val() == "" || $("#activity-typeahead").val() == "") {
                alert("One or more required fields are empty.");
                return false;
            } else {
                $('#activityId').val($('#activity-typeahead').val());
                return true;
            }

        });

        $('#successMessage').fadeOut(3000);


    });

    function validateVerb() {
        if ($('#verb-typeahead').val().length > 0 && $.inArray($('#verb-typeahead').val(), verbDescriptions) == -1) {
            alert('Please select an approved verb from the list.');
            $('#verb-typeahead').val("");
            $('#verb').val("");
        }
    }

    function validateActivity() {
        if ($.inArray($('#activity-typeahead').val(), activityDescriptions) == -1) {
            alert("You are about ready to define a new activity, are you sure a similar activity doesn't aready exist?");
            $('#activityId').val($('#activity-typeahead').val());
            return true;
        } else {
            return true;
        }
    }

</script>

</body>
</html>