<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.User, model.Account, model.Loan, java.util.List, java.time.format.DateTimeFormatter" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("loggedUser") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    User loggedUser        = (User)    sess.getAttribute("loggedUser");
    Account activeAccount  = (Account) sess.getAttribute("activeAccount");
    Loan loan              = (Loan)    sess.getAttribute("loan");
    List<Account> accounts = (List<Account>) sess.getAttribute("accounts");

    if (loan == null) {
        response.sendRedirect(request.getContextPath() + "/loan?action=options");
        return;
    }

    DateTimeFormatter dateFmt = DateTimeFormatter.ofPattern("dd MMM yyyy");
    String startDateStr = loan.getStartDate() != null ? loan.getStartDate().format(dateFmt) : "—";
    String endDateStr   = loan.getEndDate()   != null ? loan.getEndDate().format(dateFmt)   : "—";

    String loanStatus = loan.getLoanStatus() != null ? loan.getLoanStatus().name() : "APPLIED";
    int currentStep = 0;
    if ("APPLIED".equals(loanStatus))  currentStep = 1;
    if ("APPROVED".equals(loanStatus)) currentStep = 2;
    if ("ACTIVE".equals(loanStatus))   currentStep = 3;
    if ("CLOSED".equals(loanStatus))   currentStep = 4;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Loan Approved — NovaTrust Bank</title>
    <link rel="preconnect" href="https://fonts.googleapis.com"/>
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin/>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=DM+Sans:wght@400;500;600;700&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="CSS/global.css"/>
    <link rel="stylesheet" href="CSS/dashboard.css"/>
    <link rel="stylesheet" href="CSS/loan.css"/>
</head>
<body>
<div class="dashboard-page">

    <!-- ══ SIDEBAR ══ -->
    <aside class="sidebar">
        <div class="sidebar-logo">
            <div class="sidebar-logo-icon">
                <svg viewBox="0 0 24 24"><path d="M3 9l9-7 9 7v11a2 2 0 01-2 2H5a2 2 0 01-2-2z"/></svg>
            </div>
            <span class="sidebar-logo-name">Nova<span>Trust</span></span>
        </div>
        <div class="sidebar-user">
            <div class="sidebar-user-avatar"><%= loggedUser.getFullName().substring(0,1).toUpperCase() %></div>
            <div class="sidebar-user-name"><%= loggedUser.getFullName() %></div>
            <div class="sidebar-user-email"><%= loggedUser.getEmail() %></div>
        </div>
        <nav class="sidebar-nav">
            <div class="sidebar-nav-section">
                <span class="sidebar-nav-label">Main Menu</span>
                <a href="<%= request.getContextPath() %>/dashboard" class="sidebar-nav-item">
                    <svg class="nav-icon" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                        <rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/>
                        <rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/>
                    </svg>
                    Dashboard
                </a>
                <a href="accounts.jsp" class="sidebar-nav-item">
                    <svg class="nav-icon" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                        <rect x="2" y="5" width="20" height="14" rx="2"/>
                        <line x1="2" y1="10" x2="22" y2="10"/>
                    </svg>
                    My Accounts
                </a>
                <a href="<%= activeAccount != null ? request.getContextPath() + "/transaction?action=history&accountId=" + activeAccount.getAccountId() : request.getContextPath() + "/dashboard" %>" class="sidebar-nav-item">
                    <svg class="nav-icon" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                        <path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2"/>
                        <rect x="9" y="3" width="6" height="4" rx="1"/>
                    </svg>
                    Transactions
                </a>
                <a href="<%= activeAccount != null ? "transfer.jsp" : "createAccount.jsp" %>" class="sidebar-nav-item">
                    <svg class="nav-icon" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                        <path d="M5 12h14M12 5l7 7-7 7"/>
                    </svg>
                    Fund Transfer
                </a>
                <a href="<%= request.getContextPath() %>/loan?action=options" class="sidebar-nav-item active">
                    <svg class="nav-icon" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                        <line x1="12" y1="1" x2="12" y2="23"/>
                        <path d="M17 5H9.5a3.5 3.5 0 000 7h5a3.5 3.5 0 010 7H6"/>
                    </svg>
                    Loans
                </a>
                <a href="<%= request.getContextPath() %>/insurance" class="sidebar-nav-item">
                    <svg class="nav-icon" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                        <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
                    </svg>
                    Insurance
                </a>
                <a href="<%= request.getContextPath() %>/offer" class="sidebar-nav-item">
                    <svg class="nav-icon" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                        <path d="M20.59 13.41l-7.17 7.17a2 2 0 01-2.83 0L2 12V2h10l8.59 8.59a2 2 0 010 2.82z"/>
                        <circle cx="7" cy="7" r="1.5" fill="currentColor"/>
                    </svg>
                    Offers
                </a>
                <a href="<%= request.getContextPath() %>/notification" class="sidebar-nav-item">
                    <svg class="nav-icon" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                        <path d="M18 8A6 6 0 006 8c0 7-3 9-3 9h18s-3-2-3-9"/>
                        <path d="M13.73 21a2 2 0 01-3.46 0"/>
                    </svg>
                    Notifications
                </a>
                <a href="profile.jsp" class="sidebar-nav-item">
                    <svg class="nav-icon" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                        <path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/>
                        <circle cx="12" cy="7" r="4"/>
                    </svg>
                    My Profile
                </a>
            </div>
        </nav>
        <div class="sidebar-footer">
            <a href="<%= request.getContextPath() %>/user?action=logout" class="sidebar-logout">
                <svg class="nav-icon" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                    <path d="M9 21H5a2 2 0 01-2-2V5a2 2 0 012-2h4"/>
                    <polyline points="16 17 21 12 16 7"/>
                    <line x1="21" y1="12" x2="9" y2="12"/>
                </svg>
                Logout
            </a>
        </div>
    </aside>

    <!-- ══ MAIN ══ -->
    <div class="dashboard-main">

        <div class="topbar">
            <div class="topbar-title">Loan Approved 🎉</div>
            <div class="topbar-right">
                <a href="<%= request.getContextPath() %>/notification" class="topbar-notif">
                    <svg width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                        <path d="M18 8A6 6 0 006 8c0 7-3 9-3 9h18s-3-2-3-9"/>
                        <path d="M13.73 21a2 2 0 01-3.46 0"/>
                    </svg>
                    <span class="notif-dot"></span>
                </a>
                <div class="topbar-user-chip">
                    <div class="topbar-avatar"><%= loggedUser.getFullName().substring(0,1).toUpperCase() %></div>
                    <span class="topbar-uname"><%= loggedUser.getFullName().split(" ")[0] %></span>
                </div>
            </div>
        </div>

        <div class="dashboard-body loan-page">
            <div class="loan-success-wrapper">
                <div class="loan-success-card">

                    <div class="loan-success-header">
                        <div class="success-icon-wrap">✅</div>
                        <h2>Loan <%= loanStatus.charAt(0) + loanStatus.substring(1).toLowerCase() %>!</h2>
                        <p>Congratulations, <%= loggedUser.getFullName().split(" ")[0] %>! Your loan has been processed successfully.</p>
                    </div>

                    <div class="loan-success-body">

                        <div class="loan-detail-grid">
                            <div class="loan-detail-item">
                                <div class="loan-detail-label">Loan Amount</div>
                                <div class="loan-detail-value amount">₹<%= String.format("%,.2f", loan.getLoanAmount()) %></div>
                            </div>
                            <div class="loan-detail-item">
                                <div class="loan-detail-label">Status</div>
                                <div class="loan-detail-value">
                                    <%
                                        String statusIcon = "APPROVED".equals(loanStatus) ? "✅" :
                                                            "ACTIVE".equals(loanStatus)   ? "🔵" : "⏳";
                                    %>
                                    <span class="loan-status-tag <%= loanStatus.toLowerCase() %>">
                                        <%= statusIcon %> <%= loanStatus.charAt(0) + loanStatus.substring(1).toLowerCase() %>
                                    </span>
                                </div>
                            </div>
                            <div class="loan-detail-item">
                                <div class="loan-detail-label">Monthly EMI</div>
                                <div class="loan-detail-value amount">₹<%= String.format("%,.2f", loan.getMonthlyEmi()) %></div>
                            </div>
                            <div class="loan-detail-item">
                                <div class="loan-detail-label">Interest Rate</div>
                                <div class="loan-detail-value"><%= loan.getInterestRate() %>% p.a.</div>
                            </div>
                            <div class="loan-detail-item">
                                <div class="loan-detail-label">Tenure</div>
                                <div class="loan-detail-value"><%= loan.getTenureMonths() %> Months</div>
                            </div>
                            <div class="loan-detail-item">
                                <div class="loan-detail-label">Total Payable</div>
                                <div class="loan-detail-value">
                                    ₹<%= String.format("%,.2f", loan.getMonthlyEmi().multiply(new java.math.BigDecimal(loan.getTenureMonths()))) %>
                                </div>
                            </div>
                            <div class="loan-detail-item">
                                <div class="loan-detail-label">Start Date</div>
                                <div class="loan-detail-value"><%= startDateStr %></div>
                            </div>
                            <div class="loan-detail-item">
                                <div class="loan-detail-label">End Date</div>
                                <div class="loan-detail-value"><%= endDateStr %></div>
                            </div>
                        </div>

                        <!-- Timeline -->
                        <div class="loan-timeline">
                            <h4>Loan Progress</h4>
                            <div class="timeline-steps">
                                <div class="timeline-step <%= currentStep >= 1 ? "done" : "" %>">
                                    <div class="step-dot"><%= currentStep > 1 ? "✓" : "1" %></div>
                                    <span class="step-label">Applied</span>
                                </div>
                                <div class="timeline-step <%= currentStep == 2 ? "current" : currentStep > 2 ? "done" : "" %>">
                                    <div class="step-dot"><%= currentStep > 2 ? "✓" : "2" %></div>
                                    <span class="step-label">Approved</span>
                                </div>
                                <div class="timeline-step <%= currentStep == 3 ? "current" : currentStep > 3 ? "done" : "" %>">
                                    <div class="step-dot"><%= currentStep > 3 ? "✓" : "3" %></div>
                                    <span class="step-label">Active</span>
                                </div>
                                <div class="timeline-step <%= currentStep >= 4 ? "current" : "" %>">
                                    <div class="step-dot"><%= currentStep >= 4 ? "✓" : "4" %></div>
                                    <span class="step-label">Closed</span>
                                </div>
                            </div>
                        </div>

                        <!-- Action Buttons -->
                        <div class="loan-success-actions">
                            <a href="<%= request.getContextPath() %>/dashboard" class="btn btn-primary">
                                Go to Dashboard
                            </a>
                            <a href="<%= request.getContextPath() %>/loan?action=myLoans" class="btn btn-outline">
                                📋 View My Loans
                            </a>
                            <a href="<%= request.getContextPath() %>/loan?action=options" class="btn btn-outline">
                                Apply Another Loan
                            </a>
                            <% if (activeAccount != null) { %>
                            <a href="<%= request.getContextPath() %>/transaction?action=history&accountId=<%= activeAccount.getAccountId() %>" class="btn btn-outline">
                                View Transactions
                            </a>
                            <% } %>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>