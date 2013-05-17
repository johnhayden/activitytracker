package com.rusticisoftware.activitytracker;

import org.apache.commons.io.FileUtils;
import sun.reflect.generics.reflectiveObjects.NotImplementedException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;

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
                response.sendRedirect("index.jsp?email=" + java.net.URLEncoder.encode(actor, "ISO-8859-1") +"&success=true");

            } else if (action.equals("confirmstatement")) {
                throw new ServletException("confirmstatement not implemented");

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
            if (action.equals("getactivities")) {
                response.getWriter().write(FileUtils.readFileToString(AppConfig.activityDataFile, "utf-8"));
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

