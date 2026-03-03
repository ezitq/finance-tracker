<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
    <link rel="stylesheet" href="/resources/styles/profile.css">
    <link rel="stylesheet" href="/resources/styles/base.css">
    <link rel="stylesheet" href="/resources/styles/sidebar.css">
    <link rel="stylesheet" href="/resources/styles/layout.css">
    <link rel="stylesheet" href="/resources/styles/dashboard.css">
    <link rel="stylesheet" href="/resources/styles/modal.css">
    <title>Neon Finance Tracker</title>
</head>
<body>
<section id="sidebar">
    <a href="/home-page" class="brand">
        <i class='bx bx-wallet-alt bx-sm'></i>
        <span class="text">NeoFi Tracker</span>
    </a>
    <ul class="side-menu top">
        <li><a href="/home-page"><i class='bx bxs-dashboard bx-sm'></i><span class="text">Dashboard</span></a></li>
        <li><a href="/transaction-page"><i class='bx bx-transfer-alt bx-sm'></i><span class="text">Transactions</span></a></li>
        <li><a href="/analytics-page"><i class='bx bxs-doughnut-chart bx-sm'></i><span class="text">Analytics</span></a></li>
        <li><a href="/goals-page"><i class='bx bx-target-lock bx-sm'></i><span class="text">Financial Goals</span></a></li>
    </ul>
    <ul class="side-menu bottom">
        <li>
            <a href="/profile-page" class="active">
                <i class='bx bxs-cog bx-sm'></i>
                <span class="text">Settings</span>
            </a>
        </li>
        <li>
            <a href="/logout" class="logout">
                <i class='bx bx-power-off bx-sm'></i>
                <span class="text">Logout</span>
            </a>
        </li>
    </ul>
</section>

<section id="content">
    <nav>
        <i class='bx bx-menu bx-sm'></i>
        <form action="#">
            <div class="form-input">
                <input type="search" placeholder="Search transactions...">
                <button type="submit" class="search-btn"><i class='bx bx-search'></i></button>
            </div>
        </form>
        <a href="/profile-page" class="profile" id="profileIcon">
            <img src="https://ui-avatars.com/api/?name=${user.name != null ? user.name : 'User'}&background=0D8ABC&color=fff" alt="Profile">
        </a>
    </nav>

    <main>
        <div class="head-title">
            <div class="left">
                <h1>User Profile</h1>
                <ul class="breadcrumb">
                    <li><a href="#">NeoFi</a></li>
                    <li><i class='bx bx-chevron-right'></i></li>
                    <li><a class="active" href="#">Profile</a></li>
                </ul>
            </div>
        </div>

        <c:if test="${not empty profileSuccess}">
            <p style="color: #00ff66; margin-bottom: 10px;">${profileSuccess}</p>
        </c:if>
        <c:if test="${not empty passwordError}">
            <p style="color: #ff0055; margin-bottom: 10px;">${passwordError}</p>
        </c:if>
        <c:if test="${not empty passwordSuccess}">
            <p style="color: #00ff66; margin-bottom: 10px;">${passwordSuccess}</p>
        </c:if>

        <div class="profile-container">
            <div class="profile-card order">
                <img src="https://ui-avatars.com/api/?name=${user.name != null ? user.name : 'User'}&background=0D8ABC&color=fff&size=150"
                     alt="Avatar" class="profile-avatar">
                <h3>
                    <c:choose>
                        <c:when test="${user.name != null}">${user.name} ${user.secondName}</c:when>
                        <c:otherwise>No name set</c:otherwise>
                    </c:choose>
                </h3>
                <p>${user.email}</p>
                <p>Member since: ${user.registrationDate}</p>
            </div>

            <div class="profile-settings order">
                <div class="head">
                    <h3>Edit Details</h3>
                </div>
                <form action="${pageContext.request.contextPath}/update-profile" method="POST" class="profile-form">
                    <div class="input-group">
                        <label>First Name</label>
                        <input type="text" name="name" value="${user.name != null ? user.name : ''}">
                    </div>
                    <div class="input-group">
                        <label>Last Name</label>
                        <input type="text" name="secondName" value="${user.secondName != null ? user.secondName : ''}">
                    </div>
                    <div class="input-group">
                        <label>Preferred Currency</label>
                        <select name="currency">
                            <c:forEach items="${currencies}" var="cur">
                                <option value="${cur}" ${user.currency == cur ? 'selected' : ''}>${cur}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <button type="submit" class="submit-btn">Save Changes</button>
                </form>
            </div>

            <div class="profile-settings order">
                <div class="head">
                    <h3>Change Password</h3>
                </div>
                <form action="${pageContext.request.contextPath}/update-password" method="POST" class="profile-form">
                    <div class="input-group">
                        <label>Current Password</label>
                        <input type="password" name="oldPassword" required>
                    </div>
                    <div class="input-group">
                        <label>New Password</label>
                        <input type="password" name="newPassword" required minlength="8">
                    </div>
                    <button type="submit" class="submit-btn">Update Password</button>
                </form>
            </div>

            <div class="profile-settings order">
                <div class="head">
                    <h3>Danger Zone</h3>
                </div>
                <form action="${pageContext.request.contextPath}/delete-account" method="POST"
                      onsubmit="return confirm('Are you sure? This cannot be undone.')">
                    <button type="submit" class="submit-btn" style="background: #ff0055;">Delete Account</button>
                </form>
            </div>
        </div>
    </main>
</section>
</body>
</html>
