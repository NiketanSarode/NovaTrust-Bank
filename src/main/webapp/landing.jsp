<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>NovaTrust Bank — Banking You Can Trust</title>
  <link rel="stylesheet" href="CSS/global.css">
  <link rel="stylesheet" href="CSS/landing.css">
</head>
<body>

<!-- ══════════════════════════════════
     NAVBAR
══════════════════════════════════ -->
<nav class="navbar">
  <a href="landing.jsp" class="navbar-brand">
    <div class="navbar-logo-icon">
      <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
        <path d="M12 2L2 7v2h20V7L12 2zm-8 9v6H2v2h20v-2h-2v-6h-2v6h-4v-6h-2v6H8v-6H4z"/>
      </svg>
    </div>
    <span class="navbar-brand-name">Nova<span>Trust</span></span>
  </a>

  <ul class="navbar-links">
    <li><a href="#services">Services</a></li>
    <li><a href="#why-us">Why Us</a></li>
    <li><a href="#about">About</a></li>
    <li><a href="#contact">Contact</a></li>
  </ul>

  <div class="navbar-actions">
    <a href="login.jsp" class="btn btn-outline">Sign In</a>
    <a href="register.jsp" class="btn btn-primary">Open Account</a>
  </div>
</nav>


<!-- ══════════════════════════════════
     HERO SECTION
══════════════════════════════════ -->
<section class="hero">
  <div class="hero-inner">

    <!-- Left Content -->
    <div class="hero-content">
      <div class="hero-tag">
        <span class="dot"></span>
        Trusted by 5 Lakh+ customers
      </div>

      <h1 class="hero-title">
        Modern Banking<br>
        Built for <span class="highlight">Your Future</span>
      </h1>

      <p class="hero-desc">
        NovaTrust Bank offers secure, fast, and intelligent banking solutions —
        from instant transfers and smart loans to insurance plans tailored for you.
      </p>

      <div class="hero-actions">
        <a href="register.jsp" class="btn btn-accent btn-lg">Open Free Account</a>
        <a href="#services" class="btn btn-outline btn-lg">Explore Services</a>
      </div>

      <div class="hero-trust">
        <div class="hero-trust-item">
          <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">
            <path d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
          </svg>
          RBI Regulated
        </div>
        <div class="hero-trust-item">
          <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">
            <path d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"/>
          </svg>
          256-bit SSL Secure
        </div>
        <div class="hero-trust-item">
          <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">
            <path d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
          </svg>
          24/7 Support
        </div>
      </div>
    </div>

    <!-- Right Visual -->
    <div class="hero-visual">
      <div class="hero-card-stack">

        <!-- Back Card -->
        <div class="bank-card bank-card-back"></div>

        <!-- Main Card -->
        <div class="bank-card bank-card-main">
          <div class="card-chip"></div>
          <div class="card-number">**** **** **** 4821</div>
          <div class="card-bottom">
            <div>
              <div class="card-holder">Card Holder</div>
              <div class="card-name">Rahul Sharma</div>
            </div>
            <div class="card-brand">NovaTrust</div>
          </div>
        </div>

        <!-- Stat Badge 1 -->
        <div class="stat-badge stat-badge-1">
          <div class="stat-badge-icon green">💸</div>
          <div>
            <div class="stat-badge-val">₹12,500</div>
            <div class="stat-badge-label">Transfer Done</div>
          </div>
        </div>

        <!-- Stat Badge 2 -->
        <div class="stat-badge stat-badge-2">
          <div class="stat-badge-icon blue">📈</div>
          <div>
            <div class="stat-badge-val">8.5%</div>
            <div class="stat-badge-label">Savings Rate</div>
          </div>
        </div>

      </div>
    </div>

  </div>
</section>


<!-- ══════════════════════════════════
     SERVICES SECTION
══════════════════════════════════ -->
<section class="section services-section" id="services">
  <div class="section-header">
    <span class="section-tag">What We Offer</span>
    <h2 class="section-title">Banking Services for Every Need</h2>
    <p class="section-subtitle">From everyday banking to long-term investments — we have it all under one roof.</p>
  </div>

  <div class="grid-3" style="max-width:1100px; margin:0 auto;">
    <div class="service-card">
      <div class="service-icon">🏦</div>
      <div class="service-title">Savings & Current Account</div>
      <p class="service-desc">Open zero-balance savings or current accounts with competitive interest rates and instant access.</p>
    </div>
    <div class="service-card">
      <div class="service-icon">💸</div>
      <div class="service-title">Instant Fund Transfer</div>
      <p class="service-desc">Send money instantly via NEFT, RTGS, and IMPS with zero hidden charges 24x7.</p>
    </div>
    <div class="service-card">
      <div class="service-icon">📋</div>
      <div class="service-title">Loan Services</div>
      <p class="service-desc">Home, personal, and education loans with low interest rates and quick approvals.</p>
    </div>
    <div class="service-card">
      <div class="service-icon">🛡️</div>
      <div class="service-title">Insurance Plans</div>
      <p class="service-desc">Life, health, and vehicle insurance plans designed to protect you and your family.</p>
    </div>
    <div class="service-card">
      <div class="service-icon">🎁</div>
      <div class="service-title">Exclusive Offers</div>
      <p class="service-desc">Cashback, discounts, and reward points on every transaction and card usage.</p>
    </div>
    <div class="service-card">
      <div class="service-icon">📊</div>
      <div class="service-title">Smart Dashboard</div>
      <p class="service-desc">Track your spending, income, and savings with an intelligent personal finance dashboard.</p>
    </div>
  </div>
</section>


<!-- ══════════════════════════════════
     STATS SECTION
══════════════════════════════════ -->
<section class="stats-section">
  <div class="stats-grid">
    <div>
      <div class="stat-item-val">5<span>L+</span></div>
      <div class="stat-item-label">Happy Customers</div>
    </div>
    <div>
      <div class="stat-item-val">₹200<span>Cr+</span></div>
      <div class="stat-item-label">Transactions Daily</div>
    </div>
    <div>
      <div class="stat-item-val">99<span>.9%</span></div>
      <div class="stat-item-label">Uptime Guaranteed</div>
    </div>
    <div>
      <div class="stat-item-val">24<span>/7</span></div>
      <div class="stat-item-label">Customer Support</div>
    </div>
  </div>
</section>


<!-- ══════════════════════════════════
     WHY US SECTION
══════════════════════════════════ -->
<section class="section" id="why-us">
  <div class="why-inner">
    <div>
      <span class="section-tag">Why NovaTrust</span>
      <h2 class="section-title" style="text-align:left; margin-bottom:32px;">Banking That Puts You First</h2>
      <div class="why-list">
        <div class="why-item">
          <div class="why-item-icon">🔒</div>
          <div>
            <div class="why-item-title">Bank-Grade Security</div>
            <p class="why-item-desc">256-bit encryption, 2FA, and real-time fraud monitoring keep your money safe always.</p>
          </div>
        </div>
        <div class="why-item">
          <div class="why-item-icon">⚡</div>
          <div>
            <div class="why-item-title">Lightning Fast Transfers</div>
            <p class="why-item-desc">Transfer funds across India in seconds — any time, any day including holidays.</p>
          </div>
        </div>
        <div class="why-item">
          <div class="why-item-icon">💡</div>
          <div>
            <div class="why-item-title">Smart Financial Insights</div>
            <p class="why-item-desc">Get personalized reports and spending analysis to help you save more every month.</p>
          </div>
        </div>
        <div class="why-item">
          <div class="why-item-icon">🤝</div>
          <div>
            <div class="why-item-title">Dedicated Support</div>
            <p class="why-item-desc">Our expert team is available round the clock via chat, call, or email.</p>
          </div>
        </div>
      </div>
    </div>

    <div class="why-image-block">
      <div class="why-block-icon">🏦</div>
      <div class="why-block-title">Your Trusted Financial Partner</div>
      <p class="why-block-desc">
        Since our founding, NovaTrust has been committed to making modern banking accessible,
        secure, and rewarding for every Indian household and business.
      </p>
      <br>
      <a href="auth/register.jsp" class="btn btn-accent" style="margin-top:8px;">
        Get Started Today →
      </a>
    </div>
  </div>
</section>


<!-- ══════════════════════════════════
     CTA SECTION
══════════════════════════════════ -->
<section class="cta-section">
  <span class="section-tag">Join NovaTrust</span>
  <h2 class="cta-title">Ready to Experience Smarter Banking?</h2>
  <p class="cta-desc">Open your account in less than 5 minutes — completely online, completely free.</p>
  <div class="cta-actions">
    <a href="auth/register.jsp" class="btn btn-primary btn-lg">Open Account Free</a>
    <a href="auth/login.jsp" class="btn btn-outline btn-lg">Login to NetBanking</a>
  </div>
</section>


<!-- ══════════════════════════════════
     FOOTER
══════════════════════════════════ -->
<footer class="footer" id="contact">
  <div class="footer-grid">
    <div>
      <div class="footer-brand-name">Nova<span>Trust</span> Bank</div>
      <p class="footer-desc">
        A modern, RBI-regulated digital bank committed to making banking accessible, secure,
        and rewarding for everyone.
      </p>
      <div style="display:flex; gap:12px;">
        <a href="#" style="color:rgba(255,255,255,0.5); font-size:1.2rem;">📘</a>
        <a href="#" style="color:rgba(255,255,255,0.5); font-size:1.2rem;">🐦</a>
        <a href="#" style="color:rgba(255,255,255,0.5); font-size:1.2rem;">📸</a>
      </div>
    </div>

    <div>
      <div class="footer-col-title">Services</div>
      <ul class="footer-links">
        <li><a href="#">Savings Account</a></li>
        <li><a href="#">Fund Transfer</a></li>
        <li><a href="#">Loans</a></li>
        <li><a href="#">Insurance</a></li>
        <li><a href="#">Offers</a></li>
      </ul>
    </div>

    <div>
      <div class="footer-col-title">Company</div>
      <ul class="footer-links">
        <li><a href="#">About Us</a></li>
        <li><a href="#">Careers</a></li>
        <li><a href="#">Press</a></li>
        <li><a href="#">Blog</a></li>
      </ul>
    </div>

    <div>
      <div class="footer-col-title">Support</div>
      <ul class="footer-links">
        <li><a href="#">Help Center</a></li>
        <li><a href="#">Privacy Policy</a></li>
        <li><a href="#">Terms of Service</a></li>
        <li><a href="#">Contact Us</a></li>
      </ul>
    </div>
  </div>

  <div class="footer-bottom">
    <span>© 2025 NovaTrust Bank. All rights reserved.</span>
    <span>RBI Reg. No: NBTB/2025/001 | FDIC Insured</span>
  </div>
</footer>

</body>
</html>