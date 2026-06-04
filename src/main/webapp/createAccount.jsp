<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User, model.Account" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("loggedUser") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    User loggedUser   = (User) sess.getAttribute("loggedUser");
    Account activeAccount = (Account) sess.getAttribute("activeAccount");

    String initials = "";
    if (loggedUser.getFullName() != null) {
        String[] parts = loggedUser.getFullName().trim().split(" ");
        initials += parts[0].charAt(0);
        if (parts.length > 1) initials += parts[parts.length - 1].charAt(0);
    }
    initials = initials.toUpperCase();

    // ✅ createAccount.jsp?error=MESSAGE — from AccountServlet
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Open New Account — NovaTrust Bank</title>
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
        <a href="accounts.jsp" class="sidebar-nav-item active">
          <svg class="nav-icon" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
            <rect x="2" y="5" width="20" height="14" rx="2"/><line x1="2" y1="10" x2="22" y2="10"/>
          </svg>My Accounts
        </a>
        <a href="<%= activeAccount != null
            ? request.getContextPath() + "/transaction?action=history&accountId=" + activeAccount.getAccountId()
            : request.getContextPath() + "/dashboard" %>"
           class="sidebar-nav-item">
          <svg class="nav-icon" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
            <polyline points="23 6 13.5 15.5 8.5 10.5 1 18"/>
            <polyline points="17 6 23 6 23 12"/>
          </svg>Transactions
        </a>
        <a href="<%= activeAccount != null ? "transfer.jsp" : "createAccount.jsp" %>"
   class="sidebar-nav-item">
          <svg class="nav-icon" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
            <line x1="22" y1="2" x2="11" y2="13"/>
            <polygon points="22 2 15 22 11 13 2 9 22 2"/>
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
            <polyline points="20 12 20 22 4 22 4 12"/>
            <rect x="2" y="7" width="20" height="5"/>
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
            <path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/>
            <circle cx="12" cy="7" r="4"/>
          </svg>My Profile
        </a>
      </div>
    </nav>
    <div class="sidebar-footer">
      <a href="<%= request.getContextPath() %>/user?action=logout" class="sidebar-logout">
        <svg width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
          <path d="M9 21H5a2 2 0 01-2-2V5a2 2 0 012-2h4"/>
          <polyline points="16 17 21 12 16 7"/>
          <line x1="21" y1="12" x2="9" y2="12"/>
        </svg>Logout
      </a>
    </div>
  </aside>

  <!-- ══ MAIN CONTENT ══ -->
  <div class="page-content">

    <div class="page-topbar">
      <div class="page-topbar-title">🏦 Open New Account</div>
      <a href="accounts.jsp" class="page-topbar-back">← Back to Accounts</a>
    </div>

    <div class="page-body">

      <% if (error != null && !error.isEmpty()) { %>
        <div class="alert alert-error" style="margin-bottom:20px;">⚠️ <%= error %></div>
      <% } %>

      <div class="create-account-wrap">
        <div class="create-account-card">

          <div class="create-account-header">
            <h2>Open a New Account</h2>
            <p>Choose your account type and get started in minutes</p>
          </div>

          <div class="create-account-body">

            <%--
              ✅ POST /account
              ✅ action = create
              ✅ params: accountType (SAVINGS/CURRENT), accountNumber
              ✅ Success → accounts.jsp?msg=accountCreated
              ✅ Error   → createAccount.jsp?error=MESSAGE
            --%>
            <form action="<%= request.getContextPath() %>/account" method="POST">
              <input type="hidden" name="action" value="create">

              <!-- Account Type Selector -->
              <div class="form-group">
                <label class="form-label">Select Account Type</label>
                <div class="acc-type-selector">

                  <!-- ✅ value must match AccountType enum: SAVINGS -->
                  <div class="acc-type-option">
                    <input type="radio" id="savings" name="accountType"
                           value="SAVINGS" checked>
                    <label class="acc-type-label" for="savings">
                      <span class="acc-type-emoji">🏦</span>
                      <span class="acc-type-name">Savings</span>
                      <span class="acc-type-desc">Earn interest on your deposits. Best for personal use.</span>
                    </label>
                  </div>

                  <!-- ✅ value must match AccountType enum: CURRENT -->
                  <div class="acc-type-option">
                    <input type="radio" id="current" name="accountType"
                           value="CURRENT">
                    <label class="acc-type-label" for="current">
                      <span class="acc-type-emoji">💼</span>
                      <span class="acc-type-name">Current</span>
                      <span class="acc-type-desc">Unlimited transactions. Best for business use.</span>
                    </label>
                  </div>

                </div>
              </div>

              <!-- Account Number -->
              <div class="form-group">
                <label class="form-label" for="accountNumber">Account Number</label>
                <input type="text" id="accountNumber" name="accountNumber"
                       class="form-control"
                       placeholder="Enter desired account number"
                       required maxlength="20">
                <small style="color:var(--text-muted); font-size:0.78rem; margin-top:5px; display:block;">
                  Must be unique. Numbers only recommended.
                </small>
              </div>

              <!-- Benefits -->
              <div class="acc-benefits" id="benefitsBox">
                <div class="acc-benefits-title">✨ Savings Account Benefits</div>
                <ul class="acc-benefits-list">
                  <li>Up to 8.5% annual interest rate</li>
                  <li>Zero minimum balance requirement</li>
                  <li>Free NEFT/IMPS transfers</li>
                  <li>Instant account activation</li>
                </ul>
              </div>

              <button type="submit" class="create-submit-btn">
                🏦 Open Account Now
              </button>

            </form>
          </div>
        </div>
      </div>

    </div>
  </div>
</div>

<script>
  // Dynamic benefits based on account type selection
  const savingsBenefits = `
    <div class="acc-benefits-title">✨ Savings Account Benefits</div>
    <ul class="acc-benefits-list">
      <li>Up to 8.5% annual interest rate</li>
      <li>Zero minimum balance requirement</li>
      <li>Free NEFT/IMPS transfers</li>
      <li>Instant account activation</li>
    </ul>`;

  const currentBenefits = `
    <div class="acc-benefits-title">✨ Current Account Benefits</div>
    <ul class="acc-benefits-list">
      <li>Unlimited daily transactions</li>
      <li>Overdraft facility available</li>
      <li>Priority business support</li>
      <li>Multi-user access options</li>
    </ul>`;

  document.querySelectorAll('input[name="accountType"]').forEach(radio => {
    radio.addEventListener('change', function() {
      document.getElementById('benefitsBox').innerHTML =
        this.value === 'SAVINGS' ? savingsBenefits : currentBenefits;
    });
  });

  function toggleSidebar() {
    document.getElementById('sidebar').classList.toggle('open');
  }
</script>

</body>
</html>