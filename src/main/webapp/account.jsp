<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User, model.Account, model.Account.AccountStatus,
                 model.Account.AccountType, java.util.List" %>
<%
    /* ── Session Check ── */
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("loggedUser") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    User loggedUser    = (User) sess.getAttribute("loggedUser");
    List<Account> accounts = (List<Account>) sess.getAttribute("accounts");
    Account activeAccount  = (Account) sess.getAttribute("activeAccount");

    // User initials
    String initials = "";
    if (loggedUser.getFullName() != null) {
        String[] parts = loggedUser.getFullName().trim().split(" ");
        initials += parts[0].charAt(0);
        if (parts.length > 1) initials += parts[parts.length - 1].charAt(0);
    }
    initials = initials.toUpperCase();

    // Servlet messages
    // ✅ accounts.jsp?msg=accountCreated / defaultSet / accountClosed
    // ✅ accounts.jsp?error=MESSAGE
    String error = request.getParameter("error");
    String msg   = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>My Accounts — NovaTrust Bank</title>
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
      <div class="page-topbar-title">🏦 My Accounts</div>
      <a href="<%= request.getContextPath() %>/dashboard" class="page-topbar-back">
        ← Back to Dashboard
      </a>
    </div>

    <div class="page-body">

      <%-- Messages — exact from AccountServlet redirects --%>
      <% if ("accountCreated".equals(msg)) { %>
        <div class="alert alert-success" style="margin-bottom:20px;">
          ✅ New account opened successfully!
        </div>
      <% } else if ("defaultSet".equals(msg)) { %>
        <div class="alert alert-success" style="margin-bottom:20px;">
          ✅ Default account updated successfully!
        </div>
      <% } else if ("accountClosed".equals(msg)) { %>
        <div class="alert alert-info" style="margin-bottom:20px;">
          ℹ️ Account has been closed successfully.
        </div>
      <% } else if ("accountSwitched".equals(msg)) { %>
        <div class="alert alert-success" style="margin-bottom:20px;">
          ✅ Active account switched successfully!
        </div>
      <% } %>

      <% if (error != null && !error.isEmpty()) { %>
        <div class="alert alert-error" style="margin-bottom:20px;">
          ⚠️ <%= error %>
        </div>
      <% } %>

      <!-- Header -->
      <div class="accounts-header">
        <div class="accounts-title">
          Your Accounts
          <span style="font-size:0.9rem; font-weight:400;
                       color:var(--text-muted); font-family:var(--font-body);">
            (<%= accounts != null ? accounts.size() : 0 %> total)
          </span>
        </div>
        <a href="createAccount.jsp" class="btn btn-primary">
          + Open New Account
        </a>
      </div>

      <!-- Accounts Grid -->
      <% if (accounts == null || accounts.isEmpty()) { %>
        <div class="accounts-empty">
          <div class="accounts-empty-icon">🏦</div>
          <div class="accounts-empty-title">No Accounts Found</div>
          <p class="accounts-empty-desc">
            You don't have any bank accounts yet. Open one for free!
          </p>
          <a href="createAccount.jsp" class="btn btn-primary">
            Open Your First Account
          </a>
        </div>

      <% } else { %>
        <div class="accounts-grid">
          <% for (Account acc : accounts) {
               boolean isActive = activeAccount != null &&
                                  acc.getAccountId().equals(activeAccount.getAccountId());
          %>
          <div class="account-card <%= isActive ? "active-account" : "" %>">

            <!-- Card Top -->
            <div class="account-card-top <%= acc.getAccountType() == AccountType.CURRENT ? "current" : "" %>">
              <% if (isActive) { %>
                <span class="account-active-badge">● Active</span>
              <% } %>
              <div class="account-card-type"><%= acc.getAccountType() %> Account</div>
              <div class="account-card-number">
                **** **** <%= acc.getAccountNumber().length() >= 4
                    ? acc.getAccountNumber().substring(acc.getAccountNumber().length() - 4)
                    : acc.getAccountNumber() %>
              </div>
              <div class="account-card-balance-label">Available Balance</div>
              <div class="account-card-balance">
                <span class="currency">₹</span>
                <%= String.format("%,.2f", acc.getBalance()) %>
              </div>
            </div>

            <!-- Card Bottom -->
            <div class="account-card-bottom">

              <!-- Status -->
              <div class="acc-status-ribbon">
                <span class="acc-status-dot
                  <%= acc.getStatus() == AccountStatus.ACTIVE  ? "dot-active"  :
                      acc.getStatus() == AccountStatus.BLOCKED ? "dot-blocked" : "dot-closed" %>">
                </span>
                <span style="color: <%=
                  acc.getStatus() == AccountStatus.ACTIVE  ? "var(--accent-dark)" :
                  acc.getStatus() == AccountStatus.BLOCKED ? "var(--danger)"      : "var(--text-muted)" %>;">
                  <%= acc.getStatus() %>
                </span>
                <span style="color:var(--text-muted); font-weight:400; margin-left:auto; font-size:0.75rem;">
                  Since <%= acc.getCreatedAt() != null
                      ? acc.getCreatedAt().toLocalDate().toString() : "N/A" %>
                </span>
              </div>

              <!-- Meta -->
              <div class="account-card-meta">
                <div class="account-meta-item">
                  Account No.
                  <div class="account-meta-val"><%= acc.getAccountNumber() %></div>
                </div>
                <div class="account-meta-item" style="text-align:right;">
                  Account ID
                  <div class="account-meta-val">#<%= acc.getAccountId() %></div>
                </div>
              </div>

              <!-- Actions -->
              <div class="account-card-actions">

                <%-- ✅ GET /account?action=details&accountId=X → accountDetails.jsp --%>
                <a href="<%= request.getContextPath() %>/account?action=details&accountId=<%= acc.getAccountId() %>"
                   class="acc-action-btn acc-btn-primary">
                  📋 Details
                </a>

                <% if (!isActive && acc.getStatus() == AccountStatus.ACTIVE) { %>
                  <%-- ✅ POST /account action=switch accountId=X → dashboard.jsp --%>
                  <form action="<%= request.getContextPath() %>/account" method="POST" style="flex:1;">
                    <input type="hidden" name="action" value="switch">
                    <input type="hidden" name="accountId" value="<%= acc.getAccountId() %>">
                    <button type="submit" class="acc-action-btn acc-btn-success" style="width:100%;">
                      ⚡ Switch
                    </button>
                  </form>
                <% } %>

                <%-- ✅ POST /account action=setDefault accountId=X → accounts.jsp --%>
                <form action="<%= request.getContextPath() %>/account" method="POST" style="flex:1;">
                  <input type="hidden" name="action" value="setDefault">
                  <input type="hidden" name="accountId" value="<%= acc.getAccountId() %>">
                  <button type="submit" class="acc-action-btn acc-btn-outline" style="width:100%;">
                    ★ Default
                  </button>
                </form>

              </div>

              <% if (acc.getStatus() == AccountStatus.ACTIVE) { %>
                <%-- ✅ POST /account action=close accountId=X → accounts.jsp --%>
                <form action="<%= request.getContextPath() %>/account" method="POST"
                      style="margin-top:8px;"
                      onsubmit="return confirm('Are you sure you want to close this account? This cannot be undone.');">
                  <input type="hidden" name="action" value="close">
                  <input type="hidden" name="accountId" value="<%= acc.getAccountId() %>">
                  <button type="submit" class="acc-action-btn acc-btn-danger" style="width:100%;">
                    🚫 Close Account
                  </button>
                </form>
              <% } %>

            </div>
          </div>
          <% } %>
        </div>
      <% } %>

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