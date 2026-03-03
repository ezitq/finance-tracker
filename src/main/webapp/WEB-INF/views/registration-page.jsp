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
            <h2>Sign up</h2>
            <p>Create your account</p>
        </div>

        <form action="${pageContext.request.contextPath}/register" method="POST" class="login-form" id="registerForm">
            <c:if test="${not empty registerError}">
                <p style="color: #ff0055; margin-bottom: 10px;">${registerError}</p>
            </c:if>

            <div class="form-group">
                <div class="input-wrapper">
                    <input type="text" id="email" name="email" required onkeyup="validEmail()">
                    <label for="email">Email</label>
                    <span class="input-line"></span>
                </div>
                <span class="error-message" id="emailError"></span>
            </div>

            <div class="form-group">
                <div class="input-wrapper password-wrapper">
                    <input type="password" id="password" name="password" required>
                    <label for="password">Password</label>
                    <button type="button" class="password-toggle" onclick="togglePassword('password', 'icon1')">
                        <span class="toggle-icon" id="icon1"></span>
                    </button>
                    <span class="input-line"></span>
                </div>

                <div class="input-wrapper password-wrapper">
                    <input type="password" id="confirmPassword" name="confirmPassword" required onkeyup="checkPasswordMatch()">
                    <label for="confirmPassword">Confirm your password</label>
                    <button type="button" class="password-toggle" onclick="togglePassword('confirmPassword', 'icon2')">
                        <span class="toggle-icon" id="icon2"></span>
                    </button>
                    <span class="input-line"></span>
                </div>
            </div>

            <span class="error-message" id="passwordError"></span>

            <button type="submit" class="login-btn btn">
                <span class="btn-text">Create Account</span>
                <span class="btn-glow"></span>
            </button>
        </form>

        <div class="divider"><span>or</span></div>

        <div class="signup-link">
            <p>Already have an account? <a href="${pageContext.request.contextPath}/">Sign In</a></p>
        </div>
    </div>

    <div class="background-effects">
        <div class="glow-orb glow-orb-1"></div>
        <div class="glow-orb glow-orb-2"></div>
        <div class="glow-orb glow-orb-3"></div>
    </div>
</div>

<script>
    function togglePassword(inputId, iconId) {
        const input = document.getElementById(inputId);
        const icon = document.getElementById(iconId);
        if (input.type === 'password') {
            input.type = 'text';
            icon.classList.add('show-password');
        } else {
            input.type = 'password';
            icon.classList.remove('show-password');
        }
    }

    function validEmail() {
        const email = document.getElementById('email').value;
        const error = document.getElementById('emailError');
        if (email.includes('@') && email.includes('.')) {
            error.textContent = '';
            error.classList.remove('show');
        } else {
            error.textContent = 'Email is not valid!';
            error.classList.add('show');
        }
    }

    function checkPasswordMatch() {
        const password = document.getElementById('password').value;
        const confirmPassword = document.getElementById('confirmPassword').value;
        const error = document.getElementById('passwordError');
        if (password !== confirmPassword) {
            error.textContent = 'Passwords do not match!';
            error.classList.add('show');
        } else {
            error.textContent = 'Passwords match.';
            error.classList.remove('show');
        }
    }
</script>
</body>
</html>
