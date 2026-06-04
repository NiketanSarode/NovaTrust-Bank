<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User, model.Account, model.Account.AccountStatus,
                 model.Transaction, model.Transaction.TransactionType,
                 model.Transaction.TransactionStatus, java.util.List" %>
<%
    /* ═══════════════════════════════════════════
       SESSION CHECK — DashboardServlet already
       handles redirect, but JSP level bhi check
    ═══════════════════════════════════════════ */
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("loggedUser") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // ✅ Session attributes — exact names from DashboardServlet
   User loggedUser        = (User)    sess.getAttribute("loggedUser");
Account activeAccount  = (Account) sess.getAttribute("activeAccount");
List<Account> accounts = (List<Account>) sess.getAttribute("accounts");

// ✅ DashboardServlet se aaya — recentTransactions
List<Transaction> recentTxns =
    (List<Transaction>) sess.getAttribute("recentTransactions");
    // Servlet se aaye messages
    String error = request.getParameter("error");
    String msg   = request.getParameter("msg");

    // User initials for avatar
    String initials = "";
    if (loggedUser.getFullName() != null && !loggedUser.getFullName().isEmpty()) {
        String[] parts = loggedUser.getFullName().trim().split(" ");
        initials += parts[0].charAt(0);
        if (parts.length > 1) initials += parts[parts.length - 1].charAt(0);
    }
    initials = initials.toUpperCase();
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Dashboard — NovaTrust Bank</title>
  <link rel="stylesheet" href="CSS/global.css">
  <link rel="stylesheet" href="CSS/dashboard.css">
</head>
<body>

<div class="dashboard-page">

  <!-- ══════════════════════════════════
       SIDEBAR
  ══════════════════════════════════ -->
  <aside class="sidebar" id="sidebar">

    <!-- Logo -->
    <div class="sidebar-logo">
      <div class="sidebar-logo-icon">
        <svg viewBox="0 0 24 24"><path d="M12 2L2 7v2h20V7L12 2zm-8 9v6H2v2h20v-2h-2v-6h-2v6h-4v-6h-2v6H8v-6H4z"/></svg>
      </div>
      <span class="sidebar-logo-name">Nova<span>Trust</span></span>
    </div>

    <!-- User Info -->
    <div class="sidebar-user">
      <div class="sidebar-user-avatar"><%= initials %></div>
      <div class="sidebar-user-name"><%= loggedUser.getFullName() %></div>
      <div class="sidebar-user-email"><%= loggedUser.getEmail() %></div>
    </div>

    <!-- Nav -->
    <nav class="sidebar-nav">
      <div class="sidebar-nav-section">
        <span class="sidebar-nav-label">Main</span>

        <a href="<%= request.getContextPath() %>/dashboard"
           class="sidebar-nav-item active">
          <svg class="nav-icon" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
            <rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/>
            <rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/>
          </svg>
          Dashboard
        </a>

        <%-- Agar activeAccount hai toh uski details dikhao --%>
<a href="account.jsp" class="sidebar-nav-item">
          <svg class="nav-icon" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
            <rect x="2" y="5" width="20" height="14" rx="2"/>
            <line x1="2" y1="10" x2="22" y2="10"/>
          </svg>
          My Accounts
        </a>

        <a href="<%= activeAccount != null 
    ? request.getContextPath() + "/transaction?action=history&accountId=" + activeAccount.getAccountId()
    : request.getContextPath() + "/dashboard" %>"
           class="sidebar-nav-item">
          <svg class="nav-icon" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
            <polyline points="23 6 13.5 15.5 8.5 10.5 1 18"/>
            <polyline points="17 6 23 6 23 12"/>
          </svg>
          Transactions
        </a>

        <a href="<%= activeAccount != null ? "transfer.jsp" : "createAccount.jsp" %>"
   class="sidebar-nav-item">
          <svg class="nav-icon" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
            <line x1="22" y1="2" x2="11" y2="13"/>
            <polygon points="22 2 15 22 11 13 2 9 22 2"/>
          </svg>
          Fund Transfer
        </a>
      </div>

      <div class="sidebar-nav-section">
        <span class="sidebar-nav-label">Services</span>

        <a href="<%= request.getContextPath() %>/loan?action=options" class="sidebar-nav-item">
          <svg class="nav-icon" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
            <line x1="12" y1="1" x2="12" y2="23"/>
            <path d="M17 5H9.5a3.5 3.5 0 000 7h5a3.5 3.5 0 010 7H6"/>
          </svg>
          Loans
        </a>

        <a href="<%= request.getContextPath() %>/insurance"
           class="sidebar-nav-item">
          <svg class="nav-icon" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
            <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
          </svg>
          Insurance
        </a>

        <a href="<%= request.getContextPath() %>/offer"
           class="sidebar-nav-item">
          <svg class="nav-icon" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
            <polyline points="20 12 20 22 4 22 4 12"/>
            <rect x="2" y="7" width="20" height="5"/>
            <line x1="12" y1="22" x2="12" y2="7"/>
            <path d="M12 7H7.5a2.5 2.5 0 010-5C11 2 12 7 12 7z"/>
            <path d="M12 7h4.5a2.5 2.5 0 000-5C13 2 12 7 12 7z"/>
          </svg>
          Offers
        </a>

        <a href="<%= request.getContextPath() %>/notification"
           class="sidebar-nav-item">
          <svg class="nav-icon" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
            <path d="M18 8A6 6 0 006 8c0 7-3 9-3 9h18s-3-2-3-9"/>
            <path d="M13.73 21a2 2 0 01-3.46 0"/>
          </svg>
          Notifications
        </a>
      </div>

      <div class="sidebar-nav-section">
        <span class="sidebar-nav-label">Account</span>

        <a href="profile.jsp" class="sidebar-nav-item">
          <svg class="nav-icon" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
            <path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/>
            <circle cx="12" cy="7" r="4"/>
          </svg>
          My Profile
        </a>
      </div>
    </nav>

    <!-- Logout -->
    <div class="sidebar-footer">
      <a href="<%= request.getContextPath() %>/user?action=logout"
         class="sidebar-logout">
        <svg width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
          <path d="M9 21H5a2 2 0 01-2-2V5a2 2 0 012-2h4"/>
          <polyline points="16 17 21 12 16 7"/>
          <line x1="21" y1="12" x2="9" y2="12"/>
        </svg>
        Logout
      </a>
    </div>
  </aside>


  <!-- ══════════════════════════════════
       MAIN CONTENT
  ══════════════════════════════════ -->
  <div class="dashboard-main">

    <!-- Topbar -->
    <div class="topbar">
      <div style="display:flex; align-items:center; gap:14px;">
        <!-- Mobile Menu Toggle -->
        <button onclick="toggleSidebar()"
                style="display:none; background:none; border:none; cursor:pointer; color:var(--text-secondary);"
                id="menuBtn">
          <svg width="22" height="22" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
            <line x1="3" y1="6" x2="21" y2="6"/>
            <line x1="3" y1="12" x2="21" y2="12"/>
            <line x1="3" y1="18" x2="21" y2="18"/>
          </svg>
        </button>
        <span class="topbar-title">Dashboard</span>
      </div>

      <div class="topbar-right">
        <!-- Notifications Bell -->
        <a href="<%= request.getContextPath() %>/notification"
           class="topbar-notif" title="Notifications">
          <svg width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
            <path d="M18 8A6 6 0 006 8c0 7-3 9-3 9h18s-3-2-3-9"/>
            <path d="M13.73 21a2 2 0 01-3.46 0"/>
          </svg>
          <span class="notif-dot"></span>
        </a>

        <!-- User Chip -->
        <a href="profile.jsp" class="topbar-user-chip">
          <div class="topbar-avatar"><%= initials %></div>
          <span class="topbar-uname"><%= loggedUser.getFullName().split(" ")[0] %></span>
        </a>
      </div>
    </div>

    <!-- Dashboard Body -->
    <div class="dashboard-body">

      <%-- Error / Success Messages --%>
      <% if (error != null && !error.isEmpty()) { %>
        <div class="account-blocked-banner">
          ⚠️ <%= error %>
        </div>
      <% } %>

      <% if ("accountSelected".equals(msg)) { %>
        <div class="alert alert-success" style="margin-bottom:16px;">
          ✅ Account switched successfully.
        </div>
      <% } %>

      <!-- Welcome Bar -->
      <div class="welcome-bar">
        <div class="welcome-text">
          <h2>Good day, <%= loggedUser.getFullName().split(" ")[0] %>! 👋</h2>
          <p>Here's your financial overview for today.</p>
        </div>
        <div class="welcome-date" id="currentDate"></div>
      </div>

      <!-- ── Account Switcher ── -->
      <% if (accounts != null && !accounts.isEmpty()) { %>
      <div class="account-switcher">
        <% for (Account acc : accounts) {
             boolean isActive = activeAccount != null &&
                                acc.getAccountId().equals(activeAccount.getAccountId());
        %>
          <a href="<%= request.getContextPath() %>/dashboard?action=selectAccount&accountId=<%= acc.getAccountId() %>"
             class="account-chip <%= isActive ? "active-chip" : "" %>">
            <div>
              <div class="account-chip-type"><%= acc.getAccountType() %></div>
              <div class="account-chip-num">
                **** <%= acc.getAccountNumber().length() >= 4
                        ? acc.getAccountNumber().substring(acc.getAccountNumber().length() - 4)
                        : acc.getAccountNumber() %>
              </div>
            </div>
            <%-- ✅ AccountStatus enum: ACTIVE, BLOCKED, CLOSED --%>
            <% if (acc.getStatus() == AccountStatus.ACTIVE) { %>
              <span class="account-chip-badge badge-success">Active</span>
            <% } else if (acc.getStatus() == AccountStatus.BLOCKED) { %>
              <span class="account-chip-badge badge-danger">Blocked</span>
            <% } else { %>
              <span class="account-chip-badge badge-warning">Closed</span>
            <% } %>
          </a>
        <% } %>
      </div>
      <% } %>

      <!-- ── Balance + Stat Cards ── -->
      <% if (activeAccount != null) { %>
        <% if (activeAccount.getStatus() == AccountStatus.BLOCKED) { %>
          <div class="account-blocked-banner">
            🚫 This account is currently blocked. Contact support for assistance.
          </div>
        <% } %>

      <div class="balance-section">

        <!-- Balance Card -->
        <div class="balance-card">
          <div class="balance-label">Available Balance</div>
          <div class="balance-amount">
            <span class="currency">₹</span>
            <%= String.format("%,.2f", activeAccount.getBalance()) %>
          </div>
          <div class="balance-acc-info">Account Number</div>
          <div class="balance-acc-num"><%= activeAccount.getAccountNumber() %></div>
          <div class="balance-status-chip">
            <span>●</span>
            <%= activeAccount.getAccountType() %> Account
          </div>
        </div>

        <!-- Stat: Account Type -->
        <div class="stat-card">
          <div class="stat-card-icon blue">🏦</div>
          <div class="stat-card-label">Account Type</div>
          <div class="stat-card-value"><%= activeAccount.getAccountType() %></div>
          <div class="stat-card-sub">
            Since <%= activeAccount.getCreatedAt() != null
                      ? activeAccount.getCreatedAt().toLocalDate().toString()
                      : "N/A" %>
          </div>
        </div>

        <!-- Stat: Account Status -->
        <div class="stat-card">
          <div class="stat-card-icon green">📊</div>
          <div class="stat-card-label">Account Status</div>
          <div class="stat-card-value" style="font-size:1.2rem;">
            <% if (activeAccount.getStatus() == AccountStatus.ACTIVE) { %>
              <span class="badge badge-success">✅ Active</span>
            <% } else if (activeAccount.getStatus() == AccountStatus.BLOCKED) { %>
              <span class="badge badge-danger">🚫 Blocked</span>
            <% } else { %>
              <span class="badge badge-warning">⛔ Closed</span>
            <% } %>
          </div>
          <div class="stat-card-sub">Last updated: Today</div>
        </div>

      </div>
      <% } else { %>
        <div class="alert alert-info" style="margin-bottom:24px;">
          ℹ️ No active account found.
          <a href="#" style="color:var(--primary); font-weight:600;">Open an account</a>
        </div>
      <% } %>

      <!-- ── Quick Actions ── -->
      <div class="quick-actions-title">Quick Actions</div>
      <div class="quick-actions-grid">
       <a href="<%= activeAccount != null ? "transfer.jsp" : "createAccount.jsp" %>"
   class="quick-action-btn">
  <div class="quick-action-icon qa-blue">💸</div>
  <span class="quick-action-label">Fund Transfer</span>
</a>
        <a href="<%= activeAccount != null 
    ? request.getContextPath() + "/transaction?action=history&accountId=" + activeAccount.getAccountId()
    : request.getContextPath() + "/dashboard" %>"
   class="quick-action-btn">
          <div class="quick-action-icon qa-green">📋</div>
          <span class="quick-action-label">Transactions</span>
        </a>
        <a href="<%= request.getContextPath() %>/loan"
           class="quick-action-btn">
          <div class="quick-action-icon qa-orange">💰</div>
          <span class="quick-action-label">Apply Loan</span>
        </a>
        <a href="<%= request.getContextPath() %>/insurance"
           class="quick-action-btn">
          <div class="quick-action-icon qa-purple">🛡️</div>
          <span class="quick-action-label">Insurance</span>
        </a>
        <a href="<%= request.getContextPath() %>/offer"
           class="quick-action-btn">
          <div class="quick-action-icon qa-red">🎁</div>
          <span class="quick-action-label">Offers</span>
        </a>
        <a href="account.jsp"
   class="quick-action-btn">
          <div class="quick-action-icon qa-teal">🏦</div>
          <span class="quick-action-label">My Accounts</span>
        </a>
        <a href="<%= request.getContextPath() %>/notification"
           class="quick-action-btn">
          <div class="quick-action-icon qa-blue">🔔</div>
          <span class="quick-action-label">Notifications</span>
        </a>
        <a href="profile.jsp" class="quick-action-btn">
          <div class="quick-action-icon qa-green">👤</div>
          <span class="quick-action-label">My Profile</span>
        </a>
      </div>

      <!-- ── Bottom: Transactions + Notifications ── -->
      <div class="dashboard-bottom">
<!-- Recent Transactions -->
<div class="section-card">
  <div class="section-card-header">
    <span class="section-card-title">Recent Transactions</span>
    <%-- ✅ View all → transactionHistory via servlet --%>
    <a href="<%= activeAccount != null
        ? request.getContextPath() + "/transaction?action=history&accountId=" + activeAccount.getAccountId()
        : "accounts.jsp" %>"
       class="section-card-link">View all →</a>
  </div>

  <div class="txn-list">
    <% if (recentTxns == null || recentTxns.isEmpty()) { %>

      <div class="txn-empty">
        📭 No recent transactions.<br>
        <small>Your transaction history will appear here.</small>
      </div>

    <% } else {
         int count = 0;
         for (Transaction txn : recentTxns) {
           if (count >= 5) break; // sirf 5 dikhao

           // Type ke hisab se classes
           String typeClass = txn.getTransactionType() == TransactionType.CREDIT
                              ? "txn-credit" : "txn-debit";
           String amtClass  = txn.getTransactionType() == TransactionType.CREDIT
                              ? "credit" : "debit";
           String amtSign   = txn.getTransactionType() == TransactionType.CREDIT
                              ? "+" : "−";
           String emoji     = "";
           switch (txn.getTransactionType()) {
               case CREDIT:   emoji = "💚"; break;
               case DEBIT:    emoji = "🔴"; break;
               case TRANSFER: emoji = "🔵"; typeClass = "txn-debit"; amtClass = "debit"; amtSign = "−"; break;
           }
    %>

      <div class="txn-item">
        <div class="txn-icon <%= typeClass %>"><%= emoji %></div>
        <div class="txn-info">
          <div class="txn-title">
            <%= txn.getDescription() != null && !txn.getDescription().isEmpty()
                ? txn.getDescription()
                : txn.getTransactionType().toString() %>
          </div>
          <div class="txn-date">
            <%= txn.getTransactionTime() != null
                ? txn.getTransactionTime().toString().replace("T", " ").substring(0, 16)
                : "N/A" %>
          </div>
        </div>
        <div class="txn-amount <%= amtClass %>">
          <%= amtSign %> ₹<%= String.format("%,.2f", txn.getAmount()) %>
        </div>
      </div>

    <%   count++;
       }
    } %>
  </div>
</div>

        <!-- Notifications -->
        <div class="section-card">
          <div class="section-card-header">
            <span class="section-card-title">Notifications</span>
            <a href="<%= request.getContextPath() %>/notification"
               class="section-card-link">View all →</a>
          </div>
          <div class="notif-list">
            <%--
              NotificationServlet se data aane ke baad
              yahan List<Notification> loop karenge.
              Abhi placeholder.
            --%>
            <div class="notif-empty">
              🔔 No new notifications.
            </div>
          </div>
        </div>

      </div>

    </div><%-- end dashboard-body --%>
  </div><%-- end dashboard-main --%>

</div><%-- end dashboard-page --%>

<script>
  // ── Current Date ──
  const d = new Date();
  const opts = { weekday:'long', year:'numeric', month:'long', day:'numeric' };
  document.getElementById('currentDate').textContent =
    d.toLocaleDateString('en-IN', opts);

  // ── Mobile Sidebar Toggle ──
  function toggleSidebar() {
    document.getElementById('sidebar').classList.toggle('open');
  }

  // ── Show menu button on mobile ──
  function checkMobile() {
    const btn = document.getElementById('menuBtn');
    if (window.innerWidth <= 900) {
      btn.style.display = 'flex';
    } else {
      btn.style.display = 'none';
      document.getElementById('sidebar').classList.remove('open');
    }
  }
  checkMobile();
  window.addEventListener('resize', checkMobile);
</script>

</body>
</html>