package com.rusticisoftware.activitytracker;

import org.codehaus.jackson.map.ObjectMapper;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class AppController extends HttpServlet {

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        PrintWriter out = response.getWriter();
        String action = request.getParameter("action");

        if (action == null || action.length() == 0) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Missing action parameter");
        }

        action = action.toLowerCase();

        try {
            if (action.equals("submitstatement")) {

                String actor = request.getParameter("actor");
                String verb = request.getParameter("verb");
                String activity = request.getParameter("activityId");

                SubmitStatementAction ssa = new SubmitStatementAction(actor, verb, activity);
                ssa.process();

            } else if (action.equals("confirmstatement")) {

            } else if (action.equals("getverbs")) {
                doGet(request, response);
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Action not valid: " + action);
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
            System.out.println(e.getMessage());
        }


        out.close();
    }

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        PrintWriter out = response.getWriter();
        String action = request.getParameter("action");

        if (action == null || action.length() == 0) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Missing action parameter");
        }

        action = action.toLowerCase();

        try {
            if (action.equals("getverbs")) {

                ObjectMapper mapper = new ObjectMapper();

                List<DropdownOption> options = new ArrayList<DropdownOption>();

                options.add(new DropdownOption("red", "http://url/red"));
                options.add(new DropdownOption("ruby", "http://url/ruby"));
                options.add(new DropdownOption("black", "http://url/black"));
                options.add(new DropdownOption("blue", "http://url/blue"));

                response.getWriter().write(mapper.writeValueAsString(options));

//                response.getWriter().write("{\n" +
//                        "            \"options\": [\n" +
//                        "            \"Option 1\",\n" +
//                        "            \"Option 2\",\n" +
//                        "            \"Option 3\",\n" +
//                        "            \"Option 4\",\n" +
//                        "            \"Option 5\"\n" +
//                        "        ]\n" +
//                        "        }");

            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Action not valid (for GET at least): " + action);
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
            System.out.println(e.getMessage());
        }


        out.close();
    }


}

