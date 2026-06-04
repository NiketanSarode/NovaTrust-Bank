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
  <title>Login — NovaTrust Bank</title>
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
      <span class="auth-left-tag">Secure NetBanking</span>
      <h2 class="auth-left-title">Welcome Back<br>to NovaTrust</h2>
      <p class="auth-left-desc">
        Access your accounts, transfer funds, manage loans and insurance —
        all in one secure place.
      </p>

      <div class="auth-features">
        <div class="auth-feature-item">
          <div class="auth-feature-icon">🔒</div>
          <span class="auth-feature-text">256-bit SSL encrypted login</span>
        </div>
        <div class="auth-feature-item">
          <div class="auth-feature-icon">⚡</div>
          <span class="auth-feature-text">Instant access to all banking services</span>
        </div>
        <div class="auth-feature-item">
          <div class="auth-feature-icon">🛡️</div>
          <span class="auth-feature-text">RBI regulated & FDIC insured</span>
        </div>
      </div>
    </div>
  </div>

  <!-- ══ RIGHT PANEL (FORM) ══ -->
  <div class="auth-right">
    <div class="auth-form-box">

      <div class="auth-form-header">
        <h1 class="auth-form-title">Sign In</h1>
        <p class="auth-form-subtitle">
          Don't have an account?
          <a href="register.jsp">Open for free</a>
        </p>
      </div>

      <%-- ✅ Success Message (after register or logout) --%>
      <% if ("registered".equals(msg)) { %>
        <div class="auth-alert auth-alert-success">
          ✅ Account created successfully! Please login.
        </div>
      <% } else if ("logout".equals(msg)) { %>
        <div class="auth-alert auth-alert-success">
          👋 You have been logged out safely.
        </div>
      <% } %>

      <%-- ❌ Error Message (from UserServlet login fail) --%>
      <% if (error != null && !error.isEmpty()) { %>
        <div class="auth-alert auth-alert-error">
          ⚠️ <%= error %>
        </div>
      <% } %>

      <%-- 
        ✅ FORM ACTION  : /user  (UserServlet @WebServlet("/user"))
        ✅ METHOD       : POST
        ✅ action param : login  (switch-case "login" in doPost)
        ✅ Params       : email, password
      --%>
      <form class="auth-form"
            action="<%= request.getContextPath() %>/user"
            method="POST">

        <!-- Hidden action — servlet ka switch-case trigger karega -->
        <input type="hidden" name="action" value="login">

        <!-- Email -->
        <div class="form-group">
          <label class="form-label" for="email">Email Address</label>
          <div class="input-icon-wrap">
            <span class="input-icon">
              <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/>
                <polyline points="22,6 12,13 2,6"/>
              </svg>
            </span>
            <input
              type="email"
              id="email"
              name="email"
              class="form-control"
              placeholder="yourname@email.com"
              required
              autocomplete="email"
            >
          </div>
        </div>

        <!-- Password -->
        <div class="form-group">
          <label class="form-label" for="password">Password</label>
          <div class="input-icon-wrap">
            <span class="input-icon">
              <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
                <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
              </svg>
            </span>
            <input
              type="password"
              id="password"
              name="password"
              class="form-control"
              placeholder="Enter your password"
              required
              autocomplete="current-password"
            >
            <button type="button"
                    class="toggle-password"
                    onclick="togglePassword('password', this)"
                    aria-label="Show password">
              <!-- Eye Icon -->
              <svg id="eye-password" width="17" height="17" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                <circle cx="12" cy="12" r="3"/>
              </svg>
            </button>
          </div>
        </div>

        <!-- Remember me + Forgot -->
        <div class="auth-form-options">
          <label class="auth-checkbox">
            <input type="checkbox" name="rememberMe">
            Remember me
          </label>
          <a href="#" class="auth-forgot">Forgot password?</a>
        </div>

        <!-- Submit -->
        <button type="submit" class="auth-submit-btn">
          Sign In to NetBanking →
        </button>

      </form>

      <div class="auth-bottom-link">
        New to NovaTrust?
        <a href="register.jsp">Create free account</a>
      </div>

    </div>
  </div>

</div>

<script>
  // Password show/hide toggle
  function togglePassword(fieldId, btn) {
    const field = document.getElementById(fieldId);
    const isPass = field.type === 'password';
    field.type = isPass ? 'text' : 'password';

    // Eye icon swap
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