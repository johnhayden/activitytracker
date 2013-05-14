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
    <script>
        $(document).ready(function() {

            $('.typeahead').typeahead({
                source: function (typeahead, query) {
                    return $.get('/getVerbs', { query: query }, function (data) {
                        return typeahead.process(data);
                    });
                }
            });

        });


//        {
//            "options": [
//            "Option 1",
//            "Option 2",
//            "Option 3",
//            "Option 4",
//            "Option 5"
//        ]
//        }

    </script>
</head>

<body>

<div class="navbar navbar-inverse navbar-fixed-top">
    <div class="navbar-inner">
            <a class="brand" href="#" class="brand" href="#">&nbsp;Mentoring Circles Activity Tracker</a>
    </div>
</div>

<div class="container" style="background-color: white; padding: 12px; border-radius: 10px">

    <div class="row-fluid">
        <form name="statementForm" action="controller?action=submitStatement" method=POST>
        <div class="span4 text-center input-large">
            <h3>I</h3>
            <input type="email" name="actor" class="spanasdf3" placeholder="Email Address">
        </div>
        <div class="span4 text-center input-large">
            <h3>Did</h3>
            <input type="text" name="verb" class="spanasdf3" placeholder="Verb">
        </div>
        <div class="span4 text-center input-large">
            <h3>This</h3>
            <input autocomplete="off" class="spanasdf3" name="activity" type="text"
            placeholder="Activity" data-provide="typeahead" data-items="8"
            data-source='["Aardvark","Beatlejuice","Capricorn","Deathmaul","Epic"]'/>
        </div>
        <form>
    </div>

    <div class="row-fluid">
        <div class="span 12">
            <input type="submit" value="Submit" class="btn btn-primary pull-right">
        </div>
    </div>
</div>

<script src="assets/jquery-1.9.1.min.js"></script>
<script src="assets/js/bootstrap.min.js"></script>

</body>

</html>
