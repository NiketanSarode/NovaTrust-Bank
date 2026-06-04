<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User, model.Account, model.Account.AccountStatus, java.util.List" %>
<%
    /* ── Session Check ── */
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("loggedUser") == null) {
        response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
        return;
    }

    User loggedUser       = (User)    sess.getAttribute("loggedUser");
    Account activeAccount = (Account) sess.getAttribute("activeAccount");
    List<Account> accounts = (List<Account>) sess.getAttribute("accounts");

    // User initials
    String initials = "";
    if (loggedUser.getFullName() != null) {
        String[] parts = loggedUser.getFullName().trim().split(" ");
        initials += parts[0].charAt(0);
        if (parts.length > 1) initials += parts[parts.length - 1].charAt(0);
    }
    initials = initials.toUpperCase();

    // Servlet se messages
    String error = request.getParameter("error");
    String msg   = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Fund Transfer — NovaTrust Bank</title>
  <link rel="stylesheet" href="CSS/global.css">
  <link rel="stylesheet" href="CSS/dashboard.css">
  <link rel="stylesheet" href="CSS/transactions.css">
</head>
<body>

<div class="dashboard-page">

  <!-- ══ SIDEBAR (same as dashboard) ══ -->
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
        <a href="account.jsp" class="sidebar-nav-item">
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
        <a href="transfer.jsp" class="sidebar-nav-item active">
          <svg class="nav-icon" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
            <line x1="22" y1="2" x2="11" y2="13"/><polygon points="22 2 15 22 11 13 2 9 22 2"/>
          </svg>Fund Transfer
        </a>
      </div>

      <div class="sidebar-nav-section">
        <span class="sidebar-nav-label">Services</span>
        <a href="<%= request.getContextPath() %>/loan" class="sidebar-nav-item">
          <svg class="nav-icon" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
            <line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 000 7h5a3.5 3.5 0 010 7H6"/>
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
            <line x1="12" y1="22" x2="12" y2="7"/>
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

    <!-- Topbar -->
    <div class="page-topbar">
      <div class="page-topbar-title">
        💸 Fund Transfer
      </div>
      <a href="<%= request.getContextPath() %>/dashboard" class="page-topbar-back">
        ← Back to Dashboard
      </a>
    </div>

    <div class="page-body">

      <%-- Messages --%>
      <% if (error != null && !error.isEmpty()) { %>
        <div class="alert alert-error" style="margin-bottom:20px;">
          ⚠️ <%= error %>
        </div>
      <% } %>
      <% if ("beneficiaryValid".equals(msg)) { %>
        <div class="alert alert-success" style="margin-bottom:20px;">
          ✅ Beneficiary account verified successfully!
        </div>
      <% } %>

      <% if (activeAccount == null) { %>
        <div class="alert alert-info">
          ℹ️ No active account found. Please select an account from the
          <a href="<%= request.getContextPath() %>/dashboard" style="color:var(--primary);font-weight:600;">Dashboard</a>.
        </div>
      <% } else if (activeAccount.getStatus() == AccountStatus.BLOCKED) { %>
        <div class="alert alert-error">
          🚫 Your active account is blocked. Fund transfer is not available.
        </div>
      <% } else { %>

      <div class="transfer-grid">

        <!-- ══ Transfer Form ══ -->
        <div class="transfer-form-card">
          <div class="transfer-form-header">
            <h2>Send Money</h2>
            <p>Transfer funds securely to any NovaTrust account</p>
          </div>

          <div class="transfer-form-body">

            <!-- Sender Account Info -->
            <div class="sender-account-box">
              <div>
                <div class="sender-acc-label">Sending From</div>
                <div class="sender-acc-num"><%= activeAccount.getAccountNumber() %></div>
                <div class="sender-acc-balance">
                  Balance: ₹<%= String.format("%,.2f", activeAccount.getBalance()) %>
                </div>
              </div>
              <span class="sender-acc-type"><%= activeAccount.getAccountType() %></span>
            </div>

            <%--
              ✅ POST /transaction
              ✅ action = transfer
              ✅ params: senderAccountId, receiverAccountId, amount
            --%>
            <form action="<%= request.getContextPath() %>/transaction"
                  method="POST"
                  id="transferForm">

              <input type="hidden" name="action" value="transfer">
              <%-- ✅ senderAccountId — activeAccount se --%>
              <input type="hidden" name="senderAccountId"
                     value="<%= activeAccount.getAccountId() %>">

              <!-- Receiver Account ID + Validate -->
              <div class="form-group">
                <label class="form-label" for="receiverAccountId">
                  Beneficiary Account Number
                </label>
                <div class="validate-row">
                  <div class="form-group">
                    <input type="text"
                           id="receiverAccountId"
                           name="receiverAccountId"
                           class="form-control"
                           placeholder="Enter account number"
                           required
                           oninput="resetValidation()">
                  </div>
                  <%--
                    ✅ GET /transaction?action=validateBeneficiary
                       &senderAccountId=X&receiverAccountId=Y
                  --%>
                  <button type="button"
                          class="validate-btn"
                          onclick="validateBeneficiary()">
                    Verify ✓
                  </button>
                </div>
              </div>

              <!-- Validation feedback -->
              <div id="validFeedback" class="beneficiary-valid-box"
                   style="display:none;">
                ✅ Account verified — ready to transfer
              </div>

              <!-- Amount -->
              <div class="form-group">
                <label class="form-label" for="amount">Transfer Amount</label>
                <div class="amount-input-wrap">
                  <span class="amount-prefix">₹</span>
                  <input type="number"
                         id="amount"
                         name="amount"
                         class="form-control"
                         placeholder="0.00"
                         min="1"
                         step="0.01"
                         required
                         oninput="updateAmountPreview()">
                </div>
              </div>

              <!-- Description (optional — servlet doesn't use it but UX ke liye) -->
              <div class="form-group">
                <label class="form-label" for="desc">Remarks (Optional)</label>
                <input type="text" id="desc" name="description"
                       class="form-control"
                       placeholder="e.g. Rent payment, Family transfer...">
              </div>

              <button type="submit"
                      class="transfer-submit-btn"
                      id="transferBtn">
                <svg width="18" height="18" fill="none" stroke="currentColor"
                     stroke-width="2" viewBox="0 0 24 24">
                  <line x1="22" y1="2" x2="11" y2="13"/>
                  <polygon points="22 2 15 22 11 13 2 9 22 2"/>
                </svg>
                Send Money
              </button>

            </form>
          </div>
        </div>

        <!-- ══ Info Panel ══ -->
        <div>
          <div class="transfer-info-card">
            <div class="transfer-info-title">📋 Transfer Summary</div>
            <div class="transfer-info-row">
              <span class="transfer-info-key">From Account</span>
              <span class="transfer-info-val" id="previewFrom">
                **** <%= activeAccount.getAccountNumber().length() >= 4
                        ? activeAccount.getAccountNumber().substring(activeAccount.getAccountNumber().length()-4)
                        : activeAccount.getAccountNumber() %>
              </span>
            </div>
            <div class="transfer-info-row">
              <span class="transfer-info-key">To Account</span>
              <span class="transfer-info-val" id="previewTo">—</span>
            </div>
            <div class="transfer-info-row">
              <span class="transfer-info-key">Amount</span>
              <span class="transfer-info-val" id="previewAmount">₹0.00</span>
            </div>
            <div class="transfer-info-row">
              <span class="transfer-info-key">Charges</span>
              <span class="transfer-info-val" style="color:var(--accent-dark);">FREE</span>
            </div>
            <div class="transfer-info-row">
              <span class="transfer-info-key">Processing Time</span>
              <span class="transfer-info-val">Instant</span>
            </div>
          </div>

          <div class="tips-box" style="margin-top:16px;">
            <div class="tips-title">⚠️ Important Tips</div>
            <ul class="tips-list">
              <li>Always verify the beneficiary account before transfer.</li>
              <li>NovaTrust will never ask for your password.</li>
              <li>Transfers are instant and cannot be reversed.</li>
              <li>Max transfer limit: ₹2,00,000 per transaction.</li>
              <li>Contact support if transfer fails.</li>
            </ul>
          </div>
        </div>

      </div>
      <% } %>

    </div><%-- page-body --%>
  </div><%-- page-content --%>

</div><%-- dashboard-page --%>

<script>
  // ── Live preview updates ──
  document.getElementById('receiverAccountId')
    ?.addEventListener('input', function() {
      const val = this.value.trim();
      document.getElementById('previewTo').textContent =
        val ? '**** ' + val.slice(-4) : '—';
    });

  function updateAmountPreview() {
    const val = parseFloat(document.getElementById('amount').value) || 0;
    document.getElementById('previewAmount').textContent =
      '₹' + val.toLocaleString('en-IN', {minimumFractionDigits: 2});
  }

  // ── Validate Beneficiary ──
  // GET /transaction?action=validateBeneficiary&senderAccountId=X&receiverAccountId=Y
  function validateBeneficiary() {
    const receiverId = document.getElementById('receiverAccountId').value.trim();
    const senderId   = '<%= activeAccount != null ? activeAccount.getAccountId() : "" %>';

    if (!receiverId) {
      alert('Please enter beneficiary account number first.');
      return;
    }

    const url = '<%= request.getContextPath() %>/transaction'
              + '?action=validateBeneficiary'
              + '&senderAccountId=' + senderId
              + '&receiverAccountId=' + receiverId;

    window.location.href = url;
  }

  function resetValidation() {
    document.getElementById('validFeedback').style.display = 'none';
  }

  // Show valid box if msg=beneficiaryValid
  <% if ("beneficiaryValid".equals(msg)) { %>
    document.getElementById('validFeedback').style.display = 'flex';
  <% } %>

  // ── Confirm before submit ──
  document.getElementById('transferForm')
    ?.addEventListener('submit', function(e) {
      const amount  = document.getElementById('amount').value;
      const toAcct  = document.getElementById('receiverAccountId').value;
      if (!confirm('Confirm transfer of ₹' + amount + ' to account ' + toAcct + '?')) {
        e.preventDefault();
      }
    });

  // Mobile sidebar
  function toggleSidebar() {
    document.getElementById('sidebar').classList.toggle('open');
  }
</script>

</body>
</html>