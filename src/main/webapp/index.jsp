<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("loggedUser") != null) {
        response.sendRedirect(request.getContextPath() + "/dashboard/dashboard.jsp");
    } else {
        response.sendRedirect(request.getContextPath() + "/landing.jsp");
    }
%>