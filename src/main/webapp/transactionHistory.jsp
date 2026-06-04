<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User, model.Account, model.Transaction,
                 model.Transaction.TransactionType,
                 model.Transaction.TransactionStatus,
                 java.util.List, java.math.BigDecimal" %>
<%
    /* ── Session Check ── */
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("loggedUser") == null) {
        response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
        return;
    }

    User loggedUser       = (User)    sess.getAttribute("loggedUser");
    Account activeAccount = (Account) sess.getAttribute("activeAccount");

    // ✅ Session attribute — exact from TransactionServlet
    List<Transaction> transactions =
        (List<Transaction>) sess.getAttribute("transactions");

    // User initials
    String initials = "";
    if (loggedUser.getFullName() != null) {
        String[] parts = loggedUser.getFullName().trim().split(" ");
        initials += parts[0].charAt(0);
        if (parts.length > 1) initials += parts[parts.length - 1].charAt(0);
    }
    initials = initials.toUpperCase();

    // Summary calculation
    BigDecimal totalCredit   = BigDecimal.ZERO;
    BigDecimal totalDebit    = BigDecimal.ZERO;
    int        totalCount    = (transactions != null) ? transactions.size() : 0;

    if (transactions != null) {
        for (Transaction t : transactions) {
            if (t.getTransactionType() == TransactionType.CREDIT) {
                totalCredit = totalCredit.add(t.getAmount());
            } else if (t.getTransactionType() == TransactionType.DEBIT
                    || t.getTransactionType() == TransactionType.TRANSFER) {
                totalDebit = totalDebit.add(t.getAmount());
            }
        }
    }

    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Transaction History — NovaTrust Bank</title>
  <link rel="stylesheet" href="CSS/global.css">
  <link rel="stylesheet" href="CSS/dashboard.css">
  <link rel="stylesheet" href="CSS/transactions.css">
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
        <a href="account.jsp" class="sidebar-nav-item">
          <svg class="nav-icon" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
            <rect x="2" y="5" width="20" height="14" rx="2"/><line x1="2" y1="10" x2="22" y2="10"/>
          </svg>My Accounts
        </a>
        <a href="transactionHistory.jsp" class="sidebar-nav-item active">
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
          <polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/>
        </svg>Logout
      </a>
    </div>
  </aside>

  <!-- ══ MAIN CONTENT ══ -->
  <div class="page-content">

    <div class="page-topbar">
      <div class="page-topbar-title">📋 Transaction History</div>
      <a href="<%= request.getContextPath() %>/dashboard" class="page-topbar-back">
        ← Back to Dashboard
      </a>
    </div>

    <div class="page-body">

      <% if (error != null && !error.isEmpty()) { %>
        <div class="alert alert-error" style="margin-bottom:20px;">⚠️ <%= error %></div>
      <% } %>

      <!-- Header Bar -->
      <div class="history-header-bar">
        <div class="history-title">
          <% if (activeAccount != null) { %>
            Account: <%= activeAccount.getAccountNumber() %>
          <% } else { %>
            All Transactions
          <% } %>
        </div>
        <a href="transfer.jsp" class="btn btn-primary btn-sm">
          + New Transfer
        </a>
      </div>

      <!-- Summary Cards -->
      <div class="history-summary">
        <div class="history-sum-card">
          <div class="history-sum-icon sum-green">💰</div>
          <div>
            <div class="history-sum-label">Total Credits</div>
            <div class="history-sum-val" style="color:var(--accent-dark);">
              + ₹<%= String.format("%,.2f", totalCredit) %>
            </div>
          </div>
        </div>
        <div class="history-sum-card">
          <div class="history-sum-icon sum-red">💸</div>
          <div>
            <div class="history-sum-label">Total Debits</div>
            <div class="history-sum-val" style="color:var(--danger);">
              − ₹<%= String.format("%,.2f", totalDebit) %>
            </div>
          </div>
        </div>
        <div class="history-sum-card">
          <div class="history-sum-icon sum-blue">📊</div>
          <div>
            <div class="history-sum-label">Total Transactions</div>
            <div class="history-sum-val"><%= totalCount %></div>
          </div>
        </div>
      </div>

      <!-- Filter Bar -->
      <div class="filter-bar">
        <span class="filter-label">Filter:</span>
        <select id="filterType" onchange="filterTable()">
          <option value="all">All Types</option>
          <option value="CREDIT">Credit</option>
          <option value="DEBIT">Debit</option>
          <option value="TRANSFER">Transfer</option>
        </select>
        <select id="filterStatus" onchange="filterTable()">
          <option value="all">All Status</option>
          <option value="SUCCESS">Success</option>
          <option value="PENDING">Pending</option>
          <option value="FAILED">Failed</option>
        </select>
        <input type="text" id="searchInput"
               placeholder="Search by Ref ID or description..."
               oninput="filterTable()"
               style="min-width:200px;">
      </div>

      <!-- Transaction Table -->
      <div class="txn-table-card">
        <% if (transactions == null || transactions.isEmpty()) { %>
          <div class="txn-empty-state">
            <div class="txn-empty-icon">📭</div>
            <div class="txn-empty-title">No Transactions Found</div>
            <p class="txn-empty-desc">
              Your transaction history will appear here once you start banking.
            </p>
          </div>
        <% } else { %>
        <table class="txn-table" id="txnTable">
          <thead>
            <tr>
              <th>#</th>
              <th>Type & Reference</th>
              <th>Description</th>
              <th>Date & Time</th>
              <th>Amount</th>
              <th>Status</th>
            </tr>
          </thead>
          <tbody id="txnTableBody">
            <% int sr = 1;
               for (Transaction txn : transactions) {
                 String typeClass   = txn.getTransactionType().name().toLowerCase();
                 String amtClass    = "txn-amount-" + typeClass;
                 String amtSign     = txn.getTransactionType() == TransactionType.CREDIT ? "+" : "−";
                 String statusClass = "";
                 String statusLabel = "";
                 switch (txn.getTransactionStatus()) {
                   case SUCCESS: statusClass = "status-success"; statusLabel = "✅ Success"; break;
                   case PENDING: statusClass = "status-pending"; statusLabel = "⏳ Pending"; break;
                   case FAILED:  statusClass = "status-failed";  statusLabel = "❌ Failed";  break;
                 }
                 String typeEmoji = "";
                 switch (txn.getTransactionType()) {
                   case CREDIT:   typeEmoji = "💚"; break;
                   case DEBIT:    typeEmoji = "🔴"; break;
                   case TRANSFER: typeEmoji = "🔵"; break;
                 }
            %>
            <tr data-type="<%= txn.getTransactionType().name() %>"
                data-status="<%= txn.getTransactionStatus().name() %>"
                data-search="<%= (txn.getReferenceId() != null ? txn.getReferenceId() : "") + " " + (txn.getDescription() != null ? txn.getDescription() : "") %>">
              <td style="color:var(--text-muted); font-size:0.8rem;"><%= sr++ %></td>
              <td>
                <div class="txn-type-cell">
                  <div class="txn-type-dot type-<%= typeClass %>"><%= typeEmoji %></div>
                  <div>
                    <div class="txn-type-name"><%= txn.getTransactionType() %></div>
                    <div class="txn-type-ref">
                      Ref: <%= txn.getReferenceId() != null ? txn.getReferenceId() : "N/A" %>
                    </div>
                  </div>
                </div>
              </td>
              <td style="color:var(--text-secondary); font-size:0.85rem;">
                <%= txn.getDescription() != null && !txn.getDescription().isEmpty()
                    ? txn.getDescription() : "—" %>
              </td>
              <td style="font-size:0.83rem; color:var(--text-secondary);">
                <%= txn.getTransactionTime() != null
                    ? txn.getTransactionTime().toString().replace("T", " ").substring(0, 16)
                    : "N/A" %>
              </td>
              <td>
                <span class="<%= amtClass %>">
                  <%= amtSign %> ₹<%= String.format("%,.2f", txn.getAmount()) %>
                </span>
              </td>
              <td>
                <span class="status-badge <%= statusClass %>">
                  <%= statusLabel %>
                </span>
              </td>
            </tr>
            <% } %>
          </tbody>
        </table>

        <!-- Pagination Info -->
        <div class="pagination">
          <span class="pagination-info" id="paginationInfo">
            Showing all <%= totalCount %> transactions
          </span>
          <div class="pagination-btns" id="paginationBtns"></div>
        </div>

        <% } %>
      </div>

    </div><%-- page-body --%>
  </div><%-- page-content --%>

</div><%-- dashboard-page --%>

<script>
  // ── Filter Table ──
  function filterTable() {
    const typeFilter   = document.getElementById('filterType').value;
    const statusFilter = document.getElementById('filterStatus').value;
    const search       = document.getElementById('searchInput').value.toLowerCase();

    const rows = document.querySelectorAll('#txnTableBody tr');
    let visible = 0;

    rows.forEach(row => {
      const matchType   = typeFilter === 'all'   || row.dataset.type   === typeFilter;
      const matchStatus = statusFilter === 'all' || row.dataset.status === statusFilter;
      const matchSearch = !search || row.dataset.search.toLowerCase().includes(search);

      if (matchType && matchStatus && matchSearch) {
        row.style.display = '';
        visible++;
      } else {
        row.style.display = 'none';
      }
    });

    document.getElementById('paginationInfo').textContent =
      'Showing ' + visible + ' of <%= totalCount %> transactions';
  }

  // Mobile sidebar
  function toggleSidebar() {
    document.getElementById('sidebar').classList.toggle('open');
  }
</script>

</body>
</html>