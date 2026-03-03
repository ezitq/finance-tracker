<!DOCTYPE html>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Neon Minimalist Login Form</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/styles/main-page-style.css">
</head>
<body>
<div class="login-container">
    <div class="login-card">
        <div class="login-header">
            <h2>Sign In</h2>
            <p>Access your account</p>
        </div>

        <form action="${pageContext.request.contextPath}/login" method="POST" class="login-form" id="loginForm">
            <c:if test="${not empty loginError}">
                <p style="color: #ff0055; margin-bottom: 10px;">${loginError}</p>
            </c:if>

            <div class="form-group">
                <div class="input-wrapper">
                    <input type="email" id="email" name="email" required>
                    <label for="email">Email</label>
                    <span class="input-line"></span>
                </div>
            </div>

            <div class="form-group">
                <div class="input-wrapper password-wrapper">
                    <input type="password" id="password" name="password" required>
                    <label for="password">Password</label>
                    <button type="button" class="password-toggle" onclick="togglePassword()" aria-label="Toggle password visibility">
                        <span class="toggle-icon" id="toggleIcon"></span>
                    </button>
                    <span class="input-line"></span>
                </div>
            </div>

            <button type="submit" class="login-btn btn">
                <span class="btn-text">Sign In</span>
                <span class="btn-glow"></span>
            </button>
        </form>

        <div class="divider"><span>or</span></div>

        <div class="signup-link">
            <p>New here? <a href="${pageContext.request.contextPath}/show-registration-page">Create an account</a></p>
        </div>
    </div>

    <div class="background-effects">
        <div class="glow-orb glow-orb-1"></div>
        <div class="glow-orb glow-orb-2"></div>
        <div class="glow-orb glow-orb-3"></div>
    </div>
</div>

<script>
    function togglePassword() {
        const input = document.getElementById('password');
        const icon = document.getElementById('toggleIcon');
        if (input.type === 'password') {
            input.type = 'text';
            icon.classList.add('show-password');
        } else {
            input.type = 'password';
            icon.classList.remove('show-password');
        }
    }
</script>
</body>
</html>
