<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.User, model.Account, model.Loan, java.util.List, java.time.format.DateTimeFormatter" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("loggedUser") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    User loggedUser       = (User)    sess.getAttribute("loggedUser");
    Account activeAccount = (Account) sess.getAttribute("activeAccount");
    List<Loan> myLoans    = (List<Loan>) sess.getAttribute("myLoans");

    DateTimeFormatter dateFmt = DateTimeFormatter.ofPattern("dd MMM yyyy");

    int totalLoans    = myLoans != null ? myLoans.size() : 0;
    int activeLoans   = 0;
    int approvedLoans = 0;
    java.math.BigDecimal totalEmi = java.math.BigDecimal.ZERO;

    if (myLoans != null) {
        for (Loan l : myLoans) {
            if (l.getLoanStatus() == Loan.LoanStatus.ACTIVE)   activeLoans++;
            if (l.getLoanStatus() == Loan.LoanStatus.APPROVED) approvedLoans++;
            if (l.getMonthlyEmi() != null &&
               (l.getLoanStatus() == Loan.LoanStatus.ACTIVE ||
                l.getLoanStatus() == Loan.LoanStatus.APPROVED)) {
                totalEmi = totalEmi.add(l.getMonthlyEmi());
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>My Loans — NovaTrust Bank</title>
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
            <div class="topbar-title">My Loans</div>
            <div class="topbar-right">
                <a href="<%= request.getContextPath() %>/loan?action=options" class="btn btn-primary" style="font-size:0.82rem;">
                    + Apply New Loan
                </a>
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
        <div class="dashboard-body loan-page">

    <%-- Alerts --%>
    
    <% String msg = request.getParameter("msg");
       String error = request.getParameter("error"); %>

    <% if ("emiPaid".equals(msg)) { %>
    <div class="alert-success">✅ EMI paid successfully! Amount deducted from your account.</div>
    <% } else if ("loanClosed".equals(msg)) { %>
    <div class="alert-success">🎉 Loan closed successfully! Full amount repaid.</div>
    <% } %>
    <% if (error != null && !error.isEmpty()) { %>
    <div class="alert-error">❌ <%= error %></div>
    <% } %>

    <!-- Stats Row -->
    ...

            <!-- Stats Row -->
            <div class="myloans-stats">
                <div class="myloans-stat-card">
                    <div class="myloans-stat-icon" style="background:rgba(26,60,110,0.08);">🏦</div>
                    <div class="myloans-stat-info">
                        <div class="myloans-stat-value"><%= totalLoans %></div>
                        <div class="myloans-stat-label">Total Loans</div>
                    </div>
                </div>
                <div class="myloans-stat-card">
                    <div class="myloans-stat-icon" style="background:rgba(46,204,113,0.12);">✅</div>
                    <div class="myloans-stat-info">
                        <div class="myloans-stat-value"><%= approvedLoans %></div>
                        <div class="myloans-stat-label">Approved</div>
                    </div>
                </div>
                <div class="myloans-stat-card">
                    <div class="myloans-stat-icon" style="background:rgba(52,152,219,0.12);">🔵</div>
                    <div class="myloans-stat-info">
                        <div class="myloans-stat-value"><%= activeLoans %></div>
                        <div class="myloans-stat-label">Active</div>
                    </div>
                </div>
                <div class="myloans-stat-card">
                    <div class="myloans-stat-icon" style="background:rgba(243,156,18,0.12);">💰</div>
                    <div class="myloans-stat-info">
                        <div class="myloans-stat-value">₹<%= String.format("%,.0f", totalEmi) %></div>
                        <div class="myloans-stat-label">Total Monthly EMI</div>
                    </div>
                </div>
            </div>

            <!-- Empty State -->
            <% if (myLoans == null || myLoans.isEmpty()) { %>
            <div class="section-card" style="text-align:center; padding:60px 20px;">
                <div style="font-size:3rem; margin-bottom:16px;">🏦</div>
                <h3 style="color:#1a2b4a; margin-bottom:8px; font-family:'Playfair Display',serif;">No Loans Yet</h3>
                <p style="color:#6b7280; margin-bottom:24px;">You haven't applied for any loans yet. Apply now to get started!</p>
                <a href="<%= request.getContextPath() %>/loan?action=options" class="btn btn-primary">Apply for a Loan</a>
            </div>

            <% } else { %>

            <!-- Loans List -->
            <div class="myloans-list">
                <% for (Loan loan : myLoans) {
                    String status    = loan.getLoanStatus() != null ? loan.getLoanStatus().name() : "APPLIED";
                    String startDate = loan.getStartDate() != null ? loan.getStartDate().format(dateFmt) : "—";
                    String endDate   = loan.getEndDate()   != null ? loan.getEndDate().format(dateFmt)   : "—";

                    String statusIcon = "APPROVED".equals(status) ? "✅" :
                                        "ACTIVE".equals(status)   ? "🔵" :
                                        "CLOSED".equals(status)   ? "🔒" :
                                        "REJECTED".equals(status) ? "❌" : "⏳";

                    int progressPct = "APPLIED".equals(status)  ? 15 :
                                      "APPROVED".equals(status) ? 40 :
                                      "ACTIVE".equals(status)   ? 70 :
                                      "CLOSED".equals(status)   ? 100 : 0;
                %>
                <div class="myloans-card">

                    <div class="myloans-card-header">
                        <div class="myloans-card-left">
                            <div class="myloans-loan-id"># LN-<%= String.format("%04d", loan.getLoanId()) %></div>
                            <div class="myloans-loan-amount">
                                ₹<%= String.format("%,.0f", loan.getLoanAmount()) %>
                            </div>
                        </div>
                        <span class="loan-status-tag <%= status.toLowerCase() %>">
                            <%= statusIcon %> <%= status.charAt(0) + status.substring(1).toLowerCase() %>
                        </span>
                    </div>

                    <div class="myloans-card-body">
                        <div class="myloans-info-grid">
                            <div class="myloans-info-item">
                                <span class="myloans-info-label">Monthly EMI</span>
                                <span class="myloans-info-value">
                                    ₹<%= loan.getMonthlyEmi() != null ? String.format("%,.2f", loan.getMonthlyEmi()) : "—" %>
                                </span>
                            </div>
                            <div class="myloans-info-item">
                                <span class="myloans-info-label">Interest Rate</span>
                                <span class="myloans-info-value"><%= loan.getInterestRate() %>% p.a.</span>
                            </div>
                            <div class="myloans-info-item">
                                <span class="myloans-info-label">Tenure</span>
                                <span class="myloans-info-value"><%= loan.getTenureMonths() %> Months</span>
                            </div>
                            <div class="myloans-info-item">
                                <span class="myloans-info-label">Total Payable</span>
                                <span class="myloans-info-value">
                                    <% if (loan.getMonthlyEmi() != null) { %>
                                    ₹<%= String.format("%,.0f", loan.getMonthlyEmi().multiply(new java.math.BigDecimal(loan.getTenureMonths()))) %>
                                    <% } else { %>—<% } %>
                                </span>
                            </div>
                            <div class="myloans-info-item">
                                <span class="myloans-info-label">Start Date</span>
                                <span class="myloans-info-value"><%= startDate %></span>
                            </div>
                            <div class="myloans-info-item">
                                <span class="myloans-info-label">End Date</span>
                                <span class="myloans-info-value"><%= endDate %></span>
                            </div>
                        </div>

                        <!-- Progress Bar -->
                        <div class="myloans-progress-wrap">
                            <div class="myloans-progress-header">
                                <span class="myloans-progress-label">Loan Progress</span>
                                <span class="myloans-progress-steps">Applied → Approved → Active → Closed</span>
                            </div>
                            <div class="myloans-progress-bar">
                                <div class="myloans-progress-fill" style="width:<%= progressPct %>%;"></div>
                            </div>
                        </div>
                        <!-- Pay EMI Button -->
<% if (!"CLOSED".equals(status) && !"REJECTED".equals(status)) { %>
<div style="margin-top:16px; padding-top:16px; border-top:1px solid #f0f4f8; display:flex; align-items:center; justify-content:space-between; flex-wrap:wrap; gap:12px;">
    <div style="font-size:0.82rem; color:#6b7280;">
        Next EMI due —
        <strong style="color:#1a2b4a;">
            Rs.<%= loan.getMonthlyEmi() != null ? String.format("%,.2f", loan.getMonthlyEmi()) : "—" %>
        </strong>
    </div>
    <div style="display:flex; gap:10px; flex-wrap:wrap;">

        <%-- Pay EMI --%>
        <form action="<%= request.getContextPath() %>/loan" method="post"
              onsubmit="return confirm('Pay EMI of Rs.<%= loan.getMonthlyEmi() != null ? String.format("%,.2f", loan.getMonthlyEmi()) : "0" %>?');">
            <input type="hidden" name="action" value="payEmi"/>
            <input type="hidden" name="loanId" value="<%= loan.getLoanId() %>"/>
            <input type="hidden" name="accountId" value="<%= loan.getAccountId() %>"/>
            <button type="submit" class="btn btn-primary" style="font-size:0.82rem; padding:8px 20px;">
                💳 Pay EMI
            </button>
        </form>

        <%-- Pay Full Loan --%>
        <form action="<%= request.getContextPath() %>/loan" method="post"
              onsubmit="return confirm('Pay full loan amount of Rs.<%= String.format("%,.2f", loan.getLoanAmount()) %>? This will close the loan.');">
            <input type="hidden" name="action" value="payFullLoan"/>
            <input type="hidden" name="loanId" value="<%= loan.getLoanId() %>"/>
            <input type="hidden" name="accountId" value="<%= loan.getAccountId() %>"/>
            <button type="submit" class="btn btn-outline" style="font-size:0.82rem; padding:8px 20px; border-color:#1a3c6e; color:#1a3c6e;">
                🏦 Pay Full Loan
            </button>
        </form>

    </div>
</div>
<% } else if ("CLOSED".equals(status)) { %>
<div style="margin-top:16px; padding-top:16px; border-top:1px solid #f0f4f8;">
    <span style="font-size:0.82rem; color:#2ecc71; font-weight:600;">
        ✅ Loan fully repaid & closed
    </span>
</div>
<% } %>

                    </div>
                </div>
                <% } %>
            </div>
            <% } %>

        </div>
    </div>
</div>
</body>
</html>