<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.User, model.Account, java.util.List" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("loggedUser") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    User loggedUser        = (User)    sess.getAttribute("loggedUser");
    Account activeAccount  = (Account) sess.getAttribute("activeAccount");
    List<Account> accounts = (List<Account>) sess.getAttribute("accounts");

    String msg   = request.getParameter("msg");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Loan Options — NovaTrust Bank</title>
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
            <div class="sidebar-user-avatar">
                <%= loggedUser.getFullName().substring(0,1).toUpperCase() %>
            </div>
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

       <!-- Topbar -->
<div class="topbar">
    <div class="topbar-title">Loan Center</div>
    <div class="topbar-right">
        <a href="<%= request.getContextPath() %>/loan?action=myLoans"
           class="btn btn-outline" style="font-size:0.82rem;">
            📋 My Loans
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

        <!-- Body -->
        <div class="dashboard-body loan-page">

            <% if ("eligible".equals(msg)) { %>
            <div class="alert-success">✅ Your account is eligible! Fill the form below to apply.</div>
            <% } %>
            <% if (error != null && !error.isEmpty()) { %>
            <div class="alert-error">❌ <%= error %></div>
            <% } %>
            <% if (activeAccount == null) { %>
            <div class="alert-error">⚠️ No active account found. <a href="createAccount.jsp">Create an account</a> to apply for a loan.</div>
            <% } %>

            <!-- Hero -->
            <div class="loan-hero">
                <div class="loan-hero-text">
                    <h1>Instant Loan Approvals</h1>
                    <p>Get funds credited to your account within minutes. No paperwork, no hassle.</p>
                </div>
                <div class="loan-hero-badge">
                    <span class="rate-value">10.5%</span>
                    <span class="rate-label">p.a. interest rate</span>
                </div>
            </div>

            <!-- Eligibility Chips -->
            <div class="eligibility-bar">
                <div class="eligibility-chip"><span class="chip-icon">✓</span> Min. Balance ₹30,000 required</div>
                <div class="eligibility-chip"><span class="chip-icon">✓</span> Loan: ₹50,000 – ₹10,00,000</div>
                <div class="eligibility-chip"><span class="chip-icon">✓</span> Active account needed</div>
                <div class="eligibility-chip"><span class="chip-icon">✓</span> Auto-approved instantly</div>
            </div>

            <!-- Loan Type Cards -->
            <div class="section-card" style="margin-bottom: 24px;">
                <div class="section-card-header">
                    <span class="section-card-title">Choose Loan Type</span>
                </div>
                <div style="padding: 20px;">
                    <div class="loan-types-grid">

                        <div class="loan-type-card" data-type="home" onclick="selectLoanType(this, 'Home Loan')">
                            <span class="loan-card-select-badge">✓</span>
                            <div class="loan-card-icon">🏠</div>
                            <div class="loan-card-title">Home Loan</div>
                            <div class="loan-card-desc">Finance your dream home with flexible repayment and competitive rates.</div>
                            <div class="loan-card-meta">
                                <div class="loan-meta-item">
                                    <span class="loan-meta-label">Max Amount</span>
                                    <span class="loan-meta-value">₹10,00,000</span>
                                </div>
                                <div class="loan-meta-item">
                                    <span class="loan-meta-label">Rate</span>
                                    <span class="loan-meta-value">10.5% p.a.</span>
                                </div>
                            </div>
                        </div>

                        <div class="loan-type-card" data-type="personal" onclick="selectLoanType(this, 'Personal Loan')">
                            <span class="loan-card-select-badge">✓</span>
                            <div class="loan-card-icon">👤</div>
                            <div class="loan-card-title">Personal Loan</div>
                            <div class="loan-card-desc">For travel, weddings, medical needs — borrow instantly for any expense.</div>
                            <div class="loan-card-meta">
                                <div class="loan-meta-item">
                                    <span class="loan-meta-label">Max Amount</span>
                                    <span class="loan-meta-value">₹10,00,000</span>
                                </div>
                                <div class="loan-meta-item">
                                    <span class="loan-meta-label">Rate</span>
                                    <span class="loan-meta-value">10.5% p.a.</span>
                                </div>
                            </div>
                        </div>

                        <div class="loan-type-card" data-type="car" onclick="selectLoanType(this, 'Car Loan')">
                            <span class="loan-card-select-badge">✓</span>
                            <div class="loan-card-icon">🚗</div>
                            <div class="loan-card-title">Car Loan</div>
                            <div class="loan-card-desc">Drive your dream car today. Easy EMIs and fast approval for any vehicle.</div>
                            <div class="loan-card-meta">
                                <div class="loan-meta-item">
                                    <span class="loan-meta-label">Max Amount</span>
                                    <span class="loan-meta-value">₹10,00,000</span>
                                </div>
                                <div class="loan-meta-item">
                                    <span class="loan-meta-label">Rate</span>
                                    <span class="loan-meta-value">10.5% p.a.</span>
                                </div>
                            </div>
                        </div>

                        <div class="loan-type-card" data-type="education" onclick="selectLoanType(this, 'Education Loan')">
                            <span class="loan-card-select-badge">✓</span>
                            <div class="loan-card-icon">🎓</div>
                            <div class="loan-card-title">Education Loan</div>
                            <div class="loan-card-desc">Invest in your future. Cover tuition, books, and living expenses.</div>
                            <div class="loan-card-meta">
                                <div class="loan-meta-item">
                                    <span class="loan-meta-label">Max Amount</span>
                                    <span class="loan-meta-value">₹10,00,000</span>
                                </div>
                                <div class="loan-meta-item">
                                    <span class="loan-meta-label">Rate</span>
                                    <span class="loan-meta-value">10.5% p.a.</span>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
            </div>

            <!-- Apply Form -->
            <% if (activeAccount != null) { %>
            <div class="loan-apply-panel" id="applyPanel">
                <div class="loan-apply-header">
                    <h3>📝 Loan Application</h3>
                    <span id="selectedLoanTypeLabel" style="font-size:0.82rem;color:#6b7280;font-weight:500;">Select a loan type above</span>
                </div>
                <div class="loan-apply-body">

                    <div class="form-group">
                        <label class="form-label">Select Account</label>
                        <div class="account-select-row">
                            <% if (accounts != null) {
                                for (Account acc : accounts) {
                                    boolean isActive  = activeAccount.getAccountId().equals(acc.getAccountId());
                                    boolean isEligible = acc.getStatus() == model.Account.AccountStatus.ACTIVE;
                            %>
                            <div class="account-select-chip <%= isActive ? "active" : "" %>"
                                 onclick="selectAccount(<%= acc.getAccountId() %>, this)">
                                <span class="account-chip-number"><%= acc.getAccountNumber() %></span>
                                <span class="account-chip-balance">
                                    <%= isEligible ? "₹" + String.format("%,.2f", acc.getBalance()) : "⛔ " + acc.getStatus() %>
                                </span>
                            </div>
                            <% } } %>
                        </div>
                    </div>

                    <form action="<%= request.getContextPath() %>/loan" method="post" id="loanForm">
                        <input type="hidden" name="action" value="apply"/>
                        <input type="hidden" name="accountId" id="selectedAccountId" value="<%= activeAccount.getAccountId() %>"/>

                        <div class="loan-form-grid">
                            <div class="form-group">
                                <label class="form-label" for="loanAmount">Loan Amount (₹)</label>
                                <input type="number" class="form-control" id="loanAmount" name="loanAmount"
                                       min="50000" max="1000000" step="1000"
                                       placeholder="e.g. 200000"
                                       oninput="updateEMIPreview()" required/>
                                <small style="color:#9ca3af;font-size:0.72rem;margin-top:4px;display:block;">
                                    Min ₹50,000 — Max ₹10,00,000
                                </small>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Interest Rate</label>
                                <input type="text" class="form-control" value="10.5% per annum" readonly
                                       style="background:#f4f7fc;color:#6b7280;cursor:not-allowed;"/>
                            </div>

                            <div class="form-group tenure-slider-wrap">
                                <label class="form-label">Tenure (Months)</label>
                                <div class="tenure-display">
                                    <span style="font-size:0.82rem;color:#6b7280;">1 month</span>
                                    <span class="tenure-value-badge" id="tenureDisplay">12 months</span>
                                    <span style="font-size:0.82rem;color:#6b7280;">120 months</span>
                                </div>
                                <input type="range" class="tenure-input" id="tenureRange" name="tenureMonths"
                                       min="1" max="120" value="12"
                                       oninput="updateTenure(this.value)"/>
                            </div>
                        </div>

                        <!-- EMI Preview -->
                        <div class="emi-preview">
                            <div class="emi-preview-item">
                                <div class="emi-preview-label">Loan Amount</div>
                                <div class="emi-preview-value" id="previewAmount">₹0</div>
                            </div>
                            <div class="emi-preview-item">
                                <div class="emi-preview-label">Monthly EMI</div>
                                <div class="emi-preview-value highlight" id="previewEmi">₹0</div>
                            </div>
                            <div class="emi-preview-item">
                                <div class="emi-preview-label">Total Payable</div>
                                <div class="emi-preview-value" id="previewTotal">₹0</div>
                            </div>
                        </div>

                        <div class="eligibility-status" id="eligibilityStatus"></div>

                        <div style="display:flex;gap:12px;align-items:center;">
                            <button type="submit" class="btn btn-primary" onclick="return validateForm()">
                                Apply for Loan
                            </button>
                            <button type="button" class="btn btn-outline" onclick="checkEligibility()">
                                Check Eligibility First
                            </button>
                        </div>
                        <div style="display:flex; justify-content:flex-end; margin-bottom:16px;">
    <a href="<%= request.getContextPath() %>/loan?action=myLoans"
       class="btn btn-outline" style="font-size:0.85rem;">
        📋 View My Loans
    </a>
</div>
                    </form>

                    <form action="<%= request.getContextPath() %>/loan" method="post" id="eligibilityForm" style="display:none;">
                        <input type="hidden" name="action" value="eligibility"/>
                        <input type="hidden" name="accountId" id="eligAccountId" value="<%= activeAccount.getAccountId() %>"/>
                        <input type="hidden" name="loanAmount" id="eligLoanAmount"/>
                    </form>

                </div>
            </div>
            <% } else { %>
            <div class="section-card" style="text-align:center;padding:40px;">
                <div style="font-size:2.5rem;margin-bottom:12px;">🏦</div>
                <h3 style="color:#1a2b4a;margin-bottom:8px;">No Active Account</h3>
                <p style="color:#6b7280;margin-bottom:20px;">You need an active account to apply for a loan.</p>
                <a href="createAccount.jsp" class="btn btn-primary">Open an Account</a>
            </div>
            <% } %>

        </div><!-- /dashboard-body -->
    </div><!-- /dashboard-main -->
</div><!-- /dashboard-page -->

<script>
    function selectLoanType(card, typeName) {
        document.querySelectorAll('.loan-type-card').forEach(c => c.classList.remove('selected'));
        card.classList.add('selected');
        document.getElementById('selectedLoanTypeLabel').textContent = typeName + ' selected';
        document.getElementById('applyPanel')?.scrollIntoView({ behavior: 'smooth', block: 'start' });
    }

    function selectAccount(accountId, chip) {
        document.querySelectorAll('.account-select-chip').forEach(c => c.classList.remove('active'));
        chip.classList.add('active');
        document.getElementById('selectedAccountId').value = accountId;
        document.getElementById('eligAccountId').value = accountId;
    }

    function updateTenure(val) {
        document.getElementById('tenureDisplay').textContent = val + ' months';
        const input    = document.getElementById('tenureRange');
        const progress = ((val - input.min) / (input.max - input.min)) * 100;
        input.style.setProperty('--progress', progress + '%');
        updateEMIPreview();
    }

    function calculateEMI(principal, annualRate, months) {
        if (!principal || !months || principal <= 0 || months <= 0) return 0;
        const r = annualRate / 12 / 100;
        if (r === 0) return principal / months;
        return principal * r * Math.pow(1+r, months) / (Math.pow(1+r, months) - 1);
    }

    function formatINR(amount) {
        return '₹' + amount.toLocaleString('en-IN', { maximumFractionDigits: 0 });
    }

    function updateEMIPreview() {
        const amount = parseFloat(document.getElementById('loanAmount').value) || 0;
        const tenure = parseInt(document.getElementById('tenureRange').value) || 12;
        const emi    = calculateEMI(amount, 10.5, tenure);
        document.getElementById('previewAmount').textContent = formatINR(amount);
        document.getElementById('previewEmi').textContent    = emi > 0 ? formatINR(emi) : '₹0';
        document.getElementById('previewTotal').textContent  = emi > 0 ? formatINR(emi * tenure) : '₹0';
        if (amount > 0 && amount < 50000)  showEligibilityStatus(false, 'Minimum loan amount is ₹50,000.');
        else if (amount > 1000000)         showEligibilityStatus(false, 'Maximum loan amount is ₹10,00,000.');
        else if (amount > 0)               document.getElementById('eligibilityStatus').classList.remove('show');
    }

    function showEligibilityStatus(eligible, message) {
        const el = document.getElementById('eligibilityStatus');
        el.className = 'eligibility-status show ' + (eligible ? 'eligible' : 'ineligible');
        el.innerHTML = (eligible ? '✅ ' : '❌ ') + message;
    }

    function checkEligibility() {
        const amount = document.getElementById('loanAmount').value;
        if (!amount || amount < 50000 || amount > 1000000) {
            showEligibilityStatus(false, 'Enter a valid amount between ₹50,000 and ₹10,00,000.');
            return;
        }
        document.getElementById('eligLoanAmount').value = amount;
        document.getElementById('eligibilityForm').submit();
    }

    function validateForm() {
        const amount = parseFloat(document.getElementById('loanAmount').value);
        const tenure = parseInt(document.getElementById('tenureRange').value);
        if (!amount || amount < 50000 || amount > 1000000) {
            showEligibilityStatus(false, 'Enter a valid amount between ₹50,000 and ₹10,00,000.');
            return false;
        }
        if (!tenure || tenure < 1 || tenure > 120) {
            showEligibilityStatus(false, 'Enter a valid tenure between 1 and 120 months.');
            return false;
        }
        return true;
    }

    updateTenure(12);
</script>
</body>
</html>