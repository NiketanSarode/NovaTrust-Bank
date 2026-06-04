<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Agar already logged in hai toh dashboard pe bhejo
    if (session.getAttribute("loggedUser") != null) {
        response.sendRedirect(request.getContextPath() + "/dashboard");
        return;
    }

    // Servlet se aaye messages
    String error = request.getParameter("error");
    String msg   = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Register — NovaTrust Bank</title>
  <link rel="stylesheet" href="CSS/global.css">
  <link rel="stylesheet" href="CSS/auth.css">
</head>
<body>

<div class="auth-page">

  <!-- ══ LEFT PANEL ══ -->
  <div class="auth-left">
    <div class="auth-left-logo">
      <div class="auth-left-logo-icon">
        <svg viewBox="0 0 24 24"><path d="M12 2L2 7v2h20V7L12 2zm-8 9v6H2v2h20v-2h-2v-6h-2v6h-4v-6h-2v6H8v-6H4z"/></svg>
      </div>
      <span class="auth-left-logo-name">Nova<span>Trust</span></span>
    </div>

    <div class="auth-left-content">
      <span class="auth-left-tag">Free Account Opening</span>
      <h2 class="auth-left-title">Join 5 Lakh+<br>Happy Customers</h2>
      <p class="auth-left-desc">
        Open your NovaTrust account in minutes. No paperwork,
        no hidden charges — just smart, secure banking.
      </p>

      <div class="auth-features">
        <div class="auth-feature-item">
          <div class="auth-feature-icon">🏦</div>
          <span class="auth-feature-text">Zero balance savings account</span>
        </div>
        <div class="auth-feature-item">
          <div class="auth-feature-icon">💸</div>
          <span class="auth-feature-text">Instant fund transfers — 24x7</span>
        </div>
        <div class="auth-feature-item">
          <div class="auth-feature-icon">🎁</div>
          <span class="auth-feature-text">Exclusive offers & cashback rewards</span>
        </div>
        <div class="auth-feature-item">
          <div class="auth-feature-icon">📊</div>
          <span class="auth-feature-text">Smart spending insights dashboard</span>
        </div>
      </div>
    </div>
  </div>

  <!-- ══ RIGHT PANEL (FORM) ══ -->
  <div class="auth-right">
    <div class="auth-form-box" style="max-width:480px;">

      <div class="auth-form-header">
        <h1 class="auth-form-title">Create Account</h1>
        <p class="auth-form-subtitle">
          Already have an account?
          <a href="login.jsp">Sign in here</a>
        </p>
      </div>

      <%-- ❌ Error from servlet --%>
      <% if (error != null && !error.isEmpty()) { %>
        <div class="auth-alert auth-alert-error">
          ⚠️ <%= error %>
        </div>
      <% } %>

      <%-- ✅ Account deleted message --%>
      <% if ("accountDeleted".equals(msg)) { %>
        <div class="auth-alert auth-alert-success">
          Account has been deleted successfully.
        </div>
      <% } %>

      <%--
        ✅ FORM ACTION  : /user   (UserServlet @WebServlet("/user"))
        ✅ METHOD       : POST
        ✅ action param : register (switch-case "register" in doPost)
        ✅ Params       : fullName, email, phone, password,
                          address, gender, dob
      --%>
      <form class="auth-form"
            action="<%= request.getContextPath() %>/user"
            method="POST">

        <input type="hidden" name="action" value="register">

        <!-- Full Name -->
        <div class="form-group">
          <label class="form-label" for="fullName">Full Name</label>
          <div class="input-icon-wrap">
            <span class="input-icon">
              <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                <path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/>
                <circle cx="12" cy="7" r="4"/>
              </svg>
            </span>
            <input type="text" id="fullName" name="fullName"
                   class="form-control"
                   placeholder="Rahul Sharma"
                   required autocomplete="name">
          </div>
        </div>

        <!-- Email + Phone -->
        <div class="form-row">
          <div class="form-group">
            <label class="form-label" for="email">Email</label>
            <div class="input-icon-wrap">
              <span class="input-icon">
                <svg width="15" height="15" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                  <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/>
                  <polyline points="22,6 12,13 2,6"/>
                </svg>
              </span>
              <input type="email" id="email" name="email"
                     class="form-control"
                     placeholder="you@email.com"
                     required autocomplete="email">
            </div>
          </div>

          <div class="form-group">
            <label class="form-label" for="phone">Phone</label>
            <div class="input-icon-wrap">
              <span class="input-icon">
                <svg width="15" height="15" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                  <path d="M22 16.92v3a2 2 0 01-2.18 2 19.79 19.79 0 01-8.63-3.07A19.5 19.5 0 013.07 9.81 19.79 19.79 0 01.01 1.18 2 2 0 012 0h3a2 2 0 012 1.72c.127.96.361 1.903.7 2.81a2 2 0 01-.45 2.11L6.09 7.91a16 16 0 006 6l1.27-1.27a2 2 0 012.11-.45c.907.339 1.85.573 2.81.7A2 2 0 0122 14.92z"/>
                </svg>
              </span>
              <input type="tel" id="phone" name="phone"
                     class="form-control"
                     placeholder="9876543210"
                     required autocomplete="tel">
            </div>
          </div>
        </div>

        <!-- Password -->
        <div class="form-group">
          <label class="form-label" for="password">Password</label>
          <div class="input-icon-wrap">
            <span class="input-icon">
              <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
                <path d="M7 11V7a5 5 0 0110 0v4"/>
              </svg>
            </span>
            <input type="password" id="password" name="password"
                   class="form-control"
                   placeholder="Min. 8 characters"
                   required autocomplete="new-password"
                   minlength="8">
            <button type="button" class="toggle-password"
                    onclick="togglePassword('password', this)">
              <svg width="17" height="17" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                <circle cx="12" cy="12" r="3"/>
              </svg>
            </button>
          </div>
        </div>

        <!-- Gender + DOB -->
        <div class="form-row">
          <div class="form-group">
            <label class="form-label" for="gender">Gender</label>
            <select id="gender" name="gender" class="form-control" required>
              <option value="" disabled selected>Select</option>
              <%-- ✅ Must match Gender enum: MALE, FEMALE, OTHER --%>
              <option value="MALE">Male</option>
              <option value="FEMALE">Female</option>
              <option value="OTHER">Other</option>
            </select>
          </div>

          <div class="form-group">
            <label class="form-label" for="dob">Date of Birth</label>
            <input type="date" id="dob" name="dob"
                   class="form-control"
                   required
                   max="<%= java.time.LocalDate.now().minusYears(18) %>">
          </div>
        </div>

        <!-- Address -->
        <div class="form-group">
          <label class="form-label" for="address">Address</label>
          <textarea id="address" name="address"
                    class="form-control"
                    placeholder="Your full residential address"
                    required rows="2"></textarea>
        </div>

        <!-- Submit -->
        <button type="submit" class="auth-submit-btn">
          Create My Account →
        </button>

      </form>

      <div class="auth-bottom-link">
        Already have an account?
        <a href="login.jsp">Sign in here</a>
      </div>

    </div>
  </div>

</div>

<script>
  function togglePassword(fieldId, btn) {
    const field = document.getElementById(fieldId);
    const isPass = field.type === 'password';
    field.type = isPass ? 'text' : 'password';
    btn.innerHTML = isPass
      ? `<svg width="17" height="17" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
           <path d="M17.94 17.94A10.07 10.07 0 0112 20c-7 0-11-8-11-8a18.45 18.45 0 015.06-5.94"/>
           <path d="M9.9 4.24A9.12 9.12 0 0112 4c7 0 11 8 11 8a18.5 18.5 0 01-2.16 3.19"/>
           <line x1="1" y1="1" x2="23" y2="23"/>
         </svg>`
      : `<svg width="17" height="17" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
           <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
           <circle cx="12" cy="12" r="3"/>
         </svg>`;
  }
</script>

</body>
</html>