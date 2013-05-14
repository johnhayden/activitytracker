package com.rusticisoftware.activitytracker;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

public class AppController extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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
                String activity = request.getParameter("activity");

                SubmitStatementAction ssa = new SubmitStatementAction(actor, verb, activity);
                ssa.process();

            } else if (action.equals("confirmstatement")) {

            } else if (action.equals("getverbs")) {

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

}

