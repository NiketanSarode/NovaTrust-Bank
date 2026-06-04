<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User, model.Account, model.Account.AccountStatus,
                 model.Account.AccountType" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("loggedUser") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    User loggedUser = (User) sess.getAttribute("loggedUser");
    Account activeAccount = (Account) sess.getAttribute("activeAccount");

    // ✅ Session attribute — exact from AccountServlet.accountDetails()
    Account selectedAccount = (Account) sess.getAttribute("selectedAccount");

    if (selectedAccount == null) {
        response.sendRedirect(request.getContextPath() + "/account?action=details&accountId="
            + (activeAccount != null ? activeAccount.getAccountId() : ""));
        return;
    }

    String initials = "";
    if (loggedUser.getFullName() != null) {
        String[] parts = loggedUser.getFullName().trim().split(" ");
        initials += parts[0].charAt(0);
        if (parts.length > 1) initials += parts[parts.length - 1].charAt(0);
    }
    initials = initials.toUpperCase();

    String error = request.getParameter("error");
    String msg   = request.getParameter("msg");

    // Account age
    String accountAge = "N/A";
    if (selectedAccount.getCreatedAt() != null) {
        long days = java.time.temporal.ChronoUnit.DAYS.between(
            selectedAccount.getCreatedAt().toLocalDate(),
            java.time.LocalDate.now()
        );
        if (days < 30) accountAge = days + " days";
        else if (days < 365) accountAge = (days / 30) + " months";
        else accountAge = (days / 365) + " year(s)";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Account Details — NovaTrust Bank</title>
  <link rel="stylesheet" href="CSS/global.css">
  <link rel="stylesheet" href="CSS/dashboard.css">
  <link rel="stylesheet" href="CSS/accounts.css">
</head>
<body>

<div class="dashboard-page">

  <!-- ══ SIDEBAR ══ -->
  <aside class="sidebar" id="sidebar">
    <div class="sidebar-logo">
      <div class="sidebar-logo-icon">
        <svg viewBox="0 0 24 24"><path d="M12 2L2 7v2h20V7L12 2zm-8 9v6H2v2h20v-2h-2v-6h-2v6h-4v-6h-2v6H8v-6H4z"/></svg>
      </div>
      <span class="sidebar-logo-name">Nova<span>Trust</span></span>
    </div>

    <div class="sidebar-user">
      <div class="sidebar-user-avatar"><%= initials %></div>
      <div class="sidebar-user-name"><%= loggedUser.getFullName() %></div>
      <div class="sidebar-user-email"><%= loggedUser.getEmail() %></div>
    </div>

    <nav class="sidebar-nav">
      <div class="sidebar-nav-section">
        <span class="sidebar-nav-label">Main</span>
        <a href="<%= request.getContextPath() %>/dashboard" class="sidebar-nav-item">
          <svg class="nav-icon" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
            <rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/>
            <rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/>
          </svg>Dashboard
        </a>
        <a href="account.jsp" class="sidebar-nav-item active">
          <svg class="nav-icon" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
            <rect x="2" y="5" width="20" height="14" rx="2"/><line x1="2" y1="10" x2="22" y2="10"/>
          </svg>My Accounts
        </a>
        <a href="<%= activeAccount != null
            ? request.getContextPath() + "/transaction?action=history&accountId=" + activeAccount.getAccountId()
            : request.getContextPath() + "/dashboard" %>"
           class="sidebar-nav-item">
          <svg class="nav-icon" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
            <polyline points="23 6 13.5 15.5 8.5 10.5 1 18"/><polyline points="17 6 23 6 23 12"/>
          </svg>Transactions
        </a>
        <a href="transfer.jsp" class="sidebar-nav-item">
          <svg class="nav-icon" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
            <line x1="22" y1="2" x2="11" y2="13"/><polygon points="22 2 15 22 11 13 2 9 22 2"/>
          </svg>Fund Transfer
        </a>
      </div>

      <div class="sidebar-nav-section">
        <span class="sidebar-nav-label">Services</span>
        <a href="<%= request.getContextPath() %>/loan" class="sidebar-nav-item">
          <svg class="nav-icon" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
            <line x1="12" y1="1" x2="12" y2="23"/>
            <path d="M17 5H9.5a3.5 3.5 0 000 7h5a3.5 3.5 0 010 7H6"/>
          </svg>Loans
        </a>
        <a href="<%= request.getContextPath() %>/insurance" class="sidebar-nav-item">
          <svg class="nav-icon" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
            <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
          </svg>Insurance
        </a>
        <a href="<%= request.getContextPath() %>/offer" class="sidebar-nav-item">
          <svg class="nav-icon" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
            <polyline points="20 12 20 22 4 22 4 12"/><rect x="2" y="7" width="20" height="5"/>
          </svg>Offers
        </a>
        <a href="<%= request.getContextPath() %>/notification" class="sidebar-nav-item">
          <svg class="nav-icon" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
            <path d="M18 8A6 6 0 006 8c0 7-3 9-3 9h18s-3-2-3-9"/>
            <path d="M13.73 21a2 2 0 01-3.46 0"/>
          </svg>Notifications
        </a>
      </div>

      <div class="sidebar-nav-section">
        <span class="sidebar-nav-label">Account</span>
        <a href="profile.jsp" class="sidebar-nav-item">
          <svg class="nav-icon" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
            <path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/><circle cx="12" cy="7" r="4"/>
          </svg>My Profile
        </a>
      </div>
    </nav>

    <div class="sidebar-footer">
      <a href="<%= request.getContextPath() %>/user?action=logout" class="sidebar-logout">
        <svg width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
          <path d="M9 21H5a2 2 0 01-2-2V5a2 2 0 012-2h4"/>
          <polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/>
        </svg>Logout
      </a>
    </div>
  </aside>

  <!-- ══ MAIN CONTENT ══ -->
  <div class="page-content">

    <div class="page-topbar">
      <div class="page-topbar-title">📋 Account Details</div>
      <a href="accounts.jsp" class="page-topbar-back">← Back to Accounts</a>
    </div>

    <div class="page-body">

      <% if (error != null && !error.isEmpty()) { %>
        <div class="alert alert-error" style="margin-bottom:20px;">⚠️ <%= error %></div>
      <% } %>

      <div class="detail-grid">
        <div>
          <!-- Hero Balance Card -->
          <div class="detail-hero">
            <div class="detail-hero-type"><%= selectedAccount.getAccountType() %> Account</div>
            <div class="detail-hero-number"><%= selectedAccount.getAccountNumber() %></div>
            <div class="detail-hero-balance-label">Available Balance</div>
            <div class="detail-hero-balance">
              ₹<%= String.format("%,.2f", selectedAccount.getBalance()) %>
            </div>
            <div class="detail-hero-footer">
              <div class="detail-hero-footer-item">
                <label>Status</label>
                <span><%= selectedAccount.getStatus() %></span>
              </div>
              <div class="detail-hero-footer-item">
                <label>Account Age</label>
                <span><%= accountAge %></span>
              </div>
              <div class="detail-hero-footer-item">
                <label>Account ID</label>
                <span>#<%= selectedAccount.getAccountId() %></span>
              </div>
            </div>
          </div>

          <!-- Info Table -->
          <div class="detail-info-card">
            <div class="detail-info-title">📄 Account Information</div>
            <div class="detail-info-row">
              <span class="detail-info-key">Account Number</span>
              <span class="detail-info-val"><%= selectedAccount.getAccountNumber() %></span>
            </div>
            <div class="detail-info-row">
              <span class="detail-info-key">Account Type</span>
              <span class="detail-info-val"><%= selectedAccount.getAccountType() %></span>
            </div>
            <div class="detail-info-row">
              <span class="detail-info-key">Current Balance</span>
              <span class="detail-info-val" style="color:var(--accent-dark);">
                ₹<%= String.format("%,.2f", selectedAccount.getBalance()) %>
              </span>
            </div>
            <div class="detail-info-row">
              <span class="detail-info-key">Account Status</span>
              <span class="detail-info-val">
                <% if (selectedAccount.getStatus() == AccountStatus.ACTIVE) { %>
                  <span class="badge badge-success">✅ Active</span>
                <% } else if (selectedAccount.getStatus() == AccountStatus.BLOCKED) { %>
                  <span class="badge badge-danger">🚫 Blocked</span>
                <% } else { %>
                  <span class="badge badge-warning">⛔ Closed</span>
                <% } %>
              </span>
            </div>
            <div class="detail-info-row">
              <span class="detail-info-key">Opened On</span>
              <span class="detail-info-val">
                <%= selectedAccount.getCreatedAt() != null
                    ? selectedAccount.getCreatedAt().toLocalDate().toString() : "N/A" %>
              </span>
            </div>
            <div class="detail-info-row">
              <span class="detail-info-key">Last Updated</span>
              <span class="detail-info-val">
                <%= selectedAccount.getUpdatedAt() != null
                    ? selectedAccount.getUpdatedAt().toString().replace("T"," ").substring(0,16)
                    : "N/A" %>
              </span>
            </div>
            <div class="detail-info-row">
              <span class="detail-info-key">Account Holder</span>
              <span class="detail-info-val"><%= loggedUser.getFullName() %></span>
            </div>
          </div>
        </div>

        <!-- Actions Panel -->
        <div>
          <div class="detail-actions-card">
            <div class="detail-actions-title">⚡ Quick Actions</div>
            <div class="detail-action-list">

              <%-- ✅ GET /transaction?action=history&accountId=X --%>
              <a href="<%= request.getContextPath() %>/transaction?action=history&accountId=<%= selectedAccount.getAccountId() %>"
                 class="detail-action-item">
                <div class="detail-action-icon" style="background:rgba(26,60,110,0.08);">📋</div>
                View Transaction History
              </a>

              <%-- ✅ GET /account?action=balance&accountId=X --%>
              <a href="<%= request.getContextPath() %>/account?action=balance&accountId=<%= selectedAccount.getAccountId() %>"
                 class="detail-action-item">
                <div class="detail-action-icon" style="background:rgba(46,204,113,0.12);">💰</div>
                Check Balance
              </a>

              <a href="transfer.jsp" class="detail-action-item">
                <div class="detail-action-icon" style="background:rgba(243,156,18,0.12);">💸</div>
                Fund Transfer
              </a>

              <%-- ✅ POST /account action=switch accountId=X --%>
              <% if (selectedAccount.getStatus() == AccountStatus.ACTIVE) { %>
              <form action="<%= request.getContextPath() %>/account" method="POST">
                <input type="hidden" name="action" value="switch">
                <input type="hidden" name="accountId" value="<%= selectedAccount.getAccountId() %>">
                <button type="submit" class="detail-action-item">
                  <div class="detail-action-icon" style="background:rgba(26,188,156,0.1);">⚡</div>
                  Set as Active Account
                </button>
              </form>

              <%-- ✅ POST /account action=setDefault accountId=X --%>
              <form action="<%= request.getContextPath() %>/account" method="POST">
                <input type="hidden" name="action" value="setDefault">
                <input type="hidden" name="accountId" value="<%= selectedAccount.getAccountId() %>">
                <button type="submit" class="detail-action-item">
                  <div class="detail-action-icon" style="background:rgba(142,68,173,0.1);">★</div>
                  Set as Default Account
                </button>
              </form>

              <%-- ✅ POST /account action=close accountId=X --%>
              <form action="<%= request.getContextPath() %>/account" method="POST"
                    onsubmit="return confirm('Close this account? This cannot be undone.');">
                <input type="hidden" name="action" value="close">
                <input type="hidden" name="accountId" value="<%= selectedAccount.getAccountId() %>">
                <button type="submit" class="detail-action-item danger">
                  <div class="detail-action-icon" style="background:rgba(231,76,60,0.1);">🚫</div>
                  Close This Account
                </button>
              </form>
              <% } %>

            </div>
          </div>
        </div>
      </div>

    </div>
  </div>
</div>

<script>
  function toggleSidebar() {
    document.getElementById('sidebar').classList.toggle('open');
  }
</script>
</body>
</html>