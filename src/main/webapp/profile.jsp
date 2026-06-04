<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User, model.User.Gender, model.User.Status,
                 model.Account, java.util.List" %>
<%
    /* ── Session Check ── */
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("loggedUser") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // ✅ Session attributes
    User loggedUser       = (User)    sess.getAttribute("loggedUser");
    Account activeAccount = (Account) sess.getAttribute("activeAccount");
    List<Account> accounts = (List<Account>) sess.getAttribute("accounts");

    // Servlet messages
    // ✅ profile.jsp?msg=updated / passwordChanged
    // ✅ profile.jsp?error=MESSAGE
    String error = request.getParameter("error");
    String msg   = request.getParameter("msg");

    // User initials
    String initials = "";
    if (loggedUser.getFullName() != null) {
        String[] parts = loggedUser.getFullName().trim().split(" ");
        initials += parts[0].charAt(0);
        if (parts.length > 1) initials += parts[parts.length - 1].charAt(0);
    }
    initials = initials.toUpperCase();

    // Member since
    String memberSince = "N/A";
    if (loggedUser.getCreatedAt() != null) {
        memberSince = loggedUser.getCreatedAt().toLocalDate().toString();
    }

    // Account count
    int accountCount = (accounts != null) ? accounts.size() : 0;

    // Age from DOB
    String age = "N/A";
    if (loggedUser.getDob() != null) {
        long years = java.time.temporal.ChronoUnit.YEARS.between(
            loggedUser.getDob(), java.time.LocalDate.now());
        age = years + " years";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>My Profile — NovaTrust Bank</title>
  <link rel="stylesheet" href="CSS/global.css">
<link rel="stylesheet" href="CSS/dashboard.css">
<link rel="stylesheet" href="CSS/profile.css">
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
        <a href="accounts.jsp" class="sidebar-nav-item">
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
        <a href="profile.jsp" class="sidebar-nav-item active">
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
  <div class="dashboard-main">

    <div class="page-topbar">
      <div class="page-topbar-title">👤 My Profile</div>
      <a href="<%= request.getContextPath() %>/dashboard" class="page-topbar-back">
        ← Back to Dashboard
      </a>
    </div>

    <div class="page-body">

      <%-- ✅ Messages from UserServlet --%>
      <% if ("updated".equals(msg)) { %>
        <div class="alert alert-success" style="margin-bottom:20px;">
          ✅ Profile updated successfully!
        </div>
      <% } else if ("passwordChanged".equals(msg)) { %>
        <div class="alert alert-success" style="margin-bottom:20px;">
          🔒 Password changed successfully!
        </div>
      <% } %>

      <% if (error != null && !error.isEmpty()) { %>
        <div class="alert alert-error" style="margin-bottom:20px;">
          ⚠️ <%= error %>
        </div>
      <% } %>

      <div class="profile-grid">

        <!-- ══ LEFT PANEL ══ -->
        <div class="profile-left">

          <!-- Profile Card -->
          <div class="profile-card">
            <div class="profile-card-top">
              <div class="profile-avatar"><%= initials %></div>
              <div class="profile-name"><%= loggedUser.getFullName() %></div>
              <div class="profile-email"><%= loggedUser.getEmail() %></div>
              <% if (Boolean.TRUE.equals(loggedUser.getIsVerified())) { %>
                <div class="profile-verified-badge">✓ Verified Account</div>
              <% } else { %>
                <div class="profile-verified-badge"
                     style="background:rgba(243,156,18,0.2); color:#d68910; border-color:rgba(243,156,18,0.3);">
                  ⚠ Not Verified
                </div>
              <% } %>
            </div>

            <div class="profile-card-bottom">
              <div class="profile-info-row">
                <div class="profile-info-icon">📱</div>
                <div>
                  <div class="profile-info-key">Phone</div>
                  <div class="profile-info-val">
                    <%= loggedUser.getPhone() != null ? loggedUser.getPhone() : "Not set" %>
                  </div>
                </div>
              </div>
              <div class="profile-info-row">
                <div class="profile-info-icon">🎂</div>
                <div>
                  <div class="profile-info-key">Date of Birth</div>
                  <div class="profile-info-val">
                    <%= loggedUser.getDob() != null ? loggedUser.getDob().toString() : "Not set" %>
                    <% if (!age.equals("N/A")) { %>
                      <span style="color:var(--text-muted); font-weight:400;">
                        (<%= age %>)
                      </span>
                    <% } %>
                  </div>
                </div>
              </div>
              <div class="profile-info-row">
                <div class="profile-info-icon">⚧</div>
                <div>
                  <div class="profile-info-key">Gender</div>
                  <div class="profile-info-val">
                    <%= loggedUser.getGender() != null ? loggedUser.getGender() : "Not set" %>
                  </div>
                </div>
              </div>
              <div class="profile-info-row">
                <div class="profile-info-icon">📍</div>
                <div>
                  <div class="profile-info-key">Address</div>
                  <div class="profile-info-val" style="font-size:0.82rem;">
                    <%= loggedUser.getAddress() != null ? loggedUser.getAddress() : "Not set" %>
                  </div>
                </div>
              </div>
              <div class="profile-info-row">
                <div class="profile-info-icon">🔐</div>
                <div>
                  <div class="profile-info-key">Account Status</div>
                  <div class="profile-info-val">
                    <% if (loggedUser.getStatus() == Status.ACTIVE) { %>
                      <span class="badge badge-success">Active</span>
                    <% } else if (loggedUser.getStatus() == Status.BLOCKED) { %>
                      <span class="badge badge-danger">Blocked</span>
                    <% } else { %>
                      <span class="badge badge-warning">Deleted</span>
                    <% } %>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Stats Card -->
          <div class="profile-stats-card">
            <div class="profile-stats-title">Account Stats</div>
            <div class="profile-stat-item">
              <span class="profile-stat-key">Member Since</span>
              <span class="profile-stat-val"><%= memberSince %></span>
            </div>
            <div class="profile-stat-item">
              <span class="profile-stat-key">Total Accounts</span>
              <span class="profile-stat-val"><%= accountCount %></span>
            </div>
            <div class="profile-stat-item">
              <span class="profile-stat-key">Active Account</span>
              <span class="profile-stat-val">
                <%= activeAccount != null ? activeAccount.getAccountNumber() : "None" %>
              </span>
            </div>
            <div class="profile-stat-item">
              <span class="profile-stat-key">User ID</span>
              <span class="profile-stat-val">#<%= loggedUser.getUserId() %></span>
            </div>
          </div>

        </div>

        <!-- ══ RIGHT PANEL ══ -->
        <div class="profile-right">

          <!-- ── Edit Profile Form ── -->
          <div class="profile-form-card">
            <div class="profile-form-header">
              <div class="profile-form-header-icon icon-blue">✏️</div>
              <div>
                <div class="profile-form-header-title">Edit Profile</div>
                <div class="profile-form-header-desc">
                  Update your personal information
                </div>
              </div>
            </div>

            <div class="profile-form-body">
              <%--
                ✅ POST /user
                ✅ action = updateProfile
                ✅ params: fullName, phone, address
                ✅ Session: loggedUser updated
                ✅ Redirect: profile.jsp?msg=updated
              --%>
              <form action="<%= request.getContextPath() %>/user" method="POST">
                <input type="hidden" name="action" value="updateProfile">

                <div class="profile-form-row">
                  <div class="form-group">
                    <label class="form-label" for="fullName">Full Name</label>
                    <input type="text" id="fullName" name="fullName"
                           class="form-control"
                           value="<%= loggedUser.getFullName() != null ? loggedUser.getFullName() : "" %>"
                           required>
                  </div>
                  <div class="form-group">
                    <label class="form-label" for="phone">Phone Number</label>
                    <input type="tel" id="phone" name="phone"
                           class="form-control"
                           value="<%= loggedUser.getPhone() != null ? loggedUser.getPhone() : "" %>"
                           required>
                  </div>
                </div>

                <div class="form-group">
                  <label class="form-label" for="address">Address</label>
                  <textarea id="address" name="address"
                            class="form-control"
                            rows="3"
                            required><%= loggedUser.getAddress() != null ? loggedUser.getAddress() : "" %></textarea>
                </div>

                <%-- Email & DOB — read only (servlet update nahi karta) --%>
                <div class="profile-form-row">
                  <div class="form-group">
                    <label class="form-label">Email Address</label>
                    <input type="email" class="form-control"
                           value="<%= loggedUser.getEmail() %>"
                           disabled
                           style="background:var(--bg); cursor:not-allowed;">
                    <small style="color:var(--text-muted); font-size:0.75rem;">
                      Email cannot be changed
                    </small>
                  </div>
                  <div class="form-group">
                    <label class="form-label">Date of Birth</label>
                    <input type="date" class="form-control"
                           value="<%= loggedUser.getDob() != null ? loggedUser.getDob().toString() : "" %>"
                           disabled
                           style="background:var(--bg); cursor:not-allowed;">
                    <small style="color:var(--text-muted); font-size:0.75rem;">
                      DOB cannot be changed
                    </small>
                  </div>
                </div>

                <button type="submit" class="profile-submit-btn">
                  💾 Save Changes
                </button>
              </form>
            </div>
          </div>

          <!-- ── Change Password Form ── -->
          <div class="profile-form-card">
            <div class="profile-form-header">
              <div class="profile-form-header-icon icon-orange">🔒</div>
              <div>
                <div class="profile-form-header-title">Change Password</div>
                <div class="profile-form-header-desc">
                  Keep your account secure with a strong password
                </div>
              </div>
            </div>

            <div class="profile-form-body">
              <%--
                ✅ POST /user
                ✅ action = changePassword
                ✅ params: newPassword
                ✅ Redirect: profile.jsp?msg=passwordChanged
              --%>
              <form action="<%= request.getContextPath() %>/user" method="POST"
                    id="passwordForm">
                <input type="hidden" name="action" value="changePassword">

                <div class="form-group">
                  <label class="form-label" for="newPassword">New Password</label>
                  <div class="input-icon-wrap">
                    <span class="input-icon">
                      <svg width="16" height="16" fill="none" stroke="currentColor"
                           stroke-width="2" viewBox="0 0 24 24">
                        <rect x="3" y="11" width="18" height="11" rx="2"/>
                        <path d="M7 11V7a5 5 0 0110 0v4"/>
                      </svg>
                    </span>
                    <input type="password" id="newPassword" name="newPassword"
                           class="form-control"
                           placeholder="Enter new password"
                           minlength="8" required
                           oninput="checkStrength(this.value)">
                    <button type="button" class="toggle-password"
                            onclick="togglePassword('newPassword', this)">
                      <svg width="16" height="16" fill="none" stroke="currentColor"
                           stroke-width="2" viewBox="0 0 24 24">
                        <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                        <circle cx="12" cy="12" r="3"/>
                      </svg>
                    </button>
                  </div>
                  <!-- Password Strength -->
                  <div class="password-strength">
                    <div class="strength-bar">
                      <div class="strength-fill" id="strengthFill"></div>
                    </div>
                    <span class="strength-text" id="strengthText"
                          style="color:var(--text-muted);">
                      Enter password
                    </span>
                  </div>
                </div>

                <div class="form-group">
                  <label class="form-label" for="confirmPassword">
                    Confirm New Password
                  </label>
                  <div class="input-icon-wrap">
                    <span class="input-icon">
                      <svg width="16" height="16" fill="none" stroke="currentColor"
                           stroke-width="2" viewBox="0 0 24 24">
                        <rect x="3" y="11" width="18" height="11" rx="2"/>
                        <path d="M7 11V7a5 5 0 0110 0v4"/>
                      </svg>
                    </span>
                    <input type="password" id="confirmPassword"
                           class="form-control"
                           placeholder="Confirm new password"
                           required>
                    <button type="button" class="toggle-password"
                            onclick="togglePassword('confirmPassword', this)">
                      <svg width="16" height="16" fill="none" stroke="currentColor"
                           stroke-width="2" viewBox="0 0 24 24">
                        <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                        <circle cx="12" cy="12" r="3"/>
                      </svg>
                    </button>
                  </div>
                  <div id="matchMsg" style="font-size:0.75rem; margin-top:5px;"></div>
                </div>

                <button type="submit" class="profile-submit-btn">
                  🔒 Update Password
                </button>
              </form>
            </div>
          </div>

          <!-- ── Danger Zone ── -->
          <div class="danger-zone-card">
            <div class="danger-zone-header">
              <div class="profile-form-header-icon icon-red">⚠️</div>
              <div class="danger-zone-title">Danger Zone</div>
            </div>
            <div class="danger-zone-body">
              <p class="danger-zone-desc">
                Deleting your account is permanent and cannot be undone.
                All your data including accounts, transactions and loan history
                will be permanently removed.
              </p>
              <div class="danger-warning-box">
                ⚠️ Warning: This will close all your bank accounts and
                delete all associated data permanently.
              </div>
              <%--
                ✅ POST /user
                ✅ action = deleteUser
                ✅ Session invalidate hogi
                ✅ Redirect: register.jsp?msg=accountDeleted
              --%>
              <form action="<%= request.getContextPath() %>/user" method="POST"
                    onsubmit="return confirmDelete()">
                <input type="hidden" name="action" value="deleteUser">
                <button type="submit" class="btn-danger-full">
                  🗑️ Delete My Account Permanently
                </button>
              </form>
            </div>
          </div>

        </div>
      </div>

    </div>
  </div>
</div>

<script>
  // ── Password Toggle ──
  function togglePassword(fieldId, btn) {
    const field = document.getElementById(fieldId);
    const isPass = field.type === 'password';
    field.type = isPass ? 'text' : 'password';
    btn.innerHTML = isPass
      ? `<svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
           <path d="M17.94 17.94A10.07 10.07 0 0112 20c-7 0-11-8-11-8a18.45 18.45 0 015.06-5.94"/>
           <path d="M9.9 4.24A9.12 9.12 0 0112 4c7 0 11 8 11 8a18.5 18.5 0 01-2.16 3.19"/>
           <line x1="1" y1="1" x2="23" y2="23"/>
         </svg>`
      : `<svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
           <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
           <circle cx="12" cy="12" r="3"/>
         </svg>`;
  }

  // ── Password Strength ──
  function checkStrength(val) {
    const fill = document.getElementById('strengthFill');
    const text = document.getElementById('strengthText');

    fill.className = 'strength-fill';

    if (val.length === 0) {
      text.textContent = 'Enter password';
      text.style.color = 'var(--text-muted)';
    } else if (val.length < 6) {
      fill.classList.add('strength-weak');
      text.textContent = 'Weak';
      text.style.color = 'var(--danger)';
    } else if (val.length < 10 || !/[A-Z]/.test(val) || !/[0-9]/.test(val)) {
      fill.classList.add('strength-medium');
      text.textContent = 'Medium';
      text.style.color = 'var(--warning)';
    } else {
      fill.classList.add('strength-strong');
      text.textContent = 'Strong ✓';
      text.style.color = 'var(--accent-dark)';
    }
  }

  // ── Password Match Check ──
  document.getElementById('confirmPassword')
    .addEventListener('input', function() {
      const newPass = document.getElementById('newPassword').value;
      const msg = document.getElementById('matchMsg');
      if (this.value === '') {
        msg.textContent = '';
      } else if (this.value === newPass) {
        msg.textContent = '✅ Passwords match';
        msg.style.color = 'var(--accent-dark)';
      } else {
        msg.textContent = '❌ Passwords do not match';
        msg.style.color = 'var(--danger)';
      }
    });

  // ── Password Form Validate ──
  document.getElementById('passwordForm').addEventListener('submit', function(e) {
    const newPass  = document.getElementById('newPassword').value;
    const confPass = document.getElementById('confirmPassword').value;
    if (newPass !== confPass) {
      e.preventDefault();
      alert('Passwords do not match! Please try again.');
    }
  });

  // ── Delete Confirm ──
  function confirmDelete() {
    return confirm(
      '⚠️ Are you absolutely sure?\n\n' +
      'This will permanently delete your account and ALL associated data.\n' +
      'This action CANNOT be undone!'
    );
  }

  // ── Mobile Sidebar ──
  function toggleSidebar() {
    document.getElementById('sidebar').classList.toggle('open');
  }
</script>

</body>
</html>