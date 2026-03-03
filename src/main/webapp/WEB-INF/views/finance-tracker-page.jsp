<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
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
        <li class="active">
            <a href="/home-page">
                <i class='bx bxs-dashboard bx-sm'></i>
                <span class="text">Dashboard</span>
            </a>
        </li>
        <li>
            <a href="/transaction-page">
                <i class='bx bx-transfer-alt bx-sm'></i>
                <span class="text">Transactions</span>
            </a>
        </li>
        <li>
            <a href="/analytics-page">
                <i class='bx bxs-doughnut-chart bx-sm'></i>
                <span class="text">Analytics</span>
            </a>
        </li>
        <li>
            <a href="/goals-page">
                <i class='bx bx-target-lock bx-sm'></i>
                <span class="text">Financial Goals</span>
            </a>
        </li>
    </ul>
    <ul class="side-menu bottom">
        <li>
            <a href="/profile-page">
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
                <h1>Main Dashboard</h1>
                <ul class="breadcrumb">
                    <li><a href="#">NeoFi</a></li>
                    <li><i class='bx bx-chevron-right'></i></li>
                    <li><a class="active" href="#">Overview</a></li>
                </ul>
            </div>
            <a href="#transactionModal" class="btn-download">
                <i class='bx bx-plus'></i>
                <span class="text">Add Transaction</span>
            </a>
        </div>

        <ul class="box-info">
            <li>
                <i class='bx bxs-wallet'></i>
                <span class="text">
                    <h3>$<fmt:formatNumber value="${totalBalance}" maxFractionDigits="2"/></h3>
                    <p>Total Balance</p>
                </span>
            </li>
            <li>
                <i class='bx bx-trending-up'></i>
                <span class="text">
                    <h3>$<fmt:formatNumber value="${incomeAmount}" maxFractionDigits="2"/></h3>
                    <p>Income (This Month)</p>
                </span>
            </li>
            <li>
                <i class='bx bx-trending-down'></i>
                <span class="text">
                    <h3>$<fmt:formatNumber value="${expenseAmount}" maxFractionDigits="2"/></h3>
                    <p>Expenses (This Month)</p>
                </span>
            </li>
        </ul>

        <div class="table-data">
            <div class="order">
                <div class="head">
                    <h3>Recent Transactions</h3>
                    <i class='bx bx-filter'></i>
                </div>
                <table>
                    <thead>
                    <tr>
                        <th>Category</th>
                        <th>Date</th>
                        <th>Amount</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${not empty financeRecords}">
                            <c:forEach items="${financeRecords}" var="record">
                                <tr>
                                    <td>
                                        <div class="icon-box netflix"><i class='bx bxs-credit-card'></i></div>
                                        <p>${record.title}</p>
                                    </td>
                                    <td>${record.date}</td>
                                    <td>
                                        <span class="${record.type == 'INCOME' ? 'status income' : 'status expense'}">
                                            ${record.type == 'INCOME' ? '+' : '-'}$<fmt:formatNumber value="${record.amount}" maxFractionDigits="2"/>
                                        </span>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr><td colspan="3"><p>No transactions yet</p></td></tr>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>

            <div class="todo">
                <div class="head">
                    <h3>Financial Goals</h3>
                    <a href="/goals-page"><i class='bx bx-plus icon'></i></a>
                </div>
                <ul class="todo-list">
                    <c:choose>
                        <c:when test="${not empty goalRecords}">
                            <c:forEach items="${goalRecords}" var="record">
                                <li class="${record.currentMoney >= record.goalMoney ? 'completed' : 'not-completed'}">
                                    <p>
                                        ${record.title} (
                                        $<c:choose>
                                            <c:when test="${record.currentMoney >= 1000}"><fmt:formatNumber value="${record.currentMoney / 1000}" maxFractionDigits="1"/>k</c:when>
                                            <c:otherwise><fmt:formatNumber value="${record.currentMoney}" maxFractionDigits="0"/></c:otherwise>
                                        </c:choose>
                                        /
                                        $<c:choose>
                                            <c:when test="${record.goalMoney >= 1000}"><fmt:formatNumber value="${record.goalMoney / 1000}" maxFractionDigits="1"/>k</c:when>
                                            <c:otherwise><fmt:formatNumber value="${record.goalMoney}" maxFractionDigits="0"/></c:otherwise>
                                        </c:choose>
                                        )
                                    </p>
                                    <i class='bx bx-check-circle'></i>
                                </li>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <p>There are no goals</p>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </div>
    </main>
</section>

<div id="transactionModal" class="modal">
    <a href="#" class="modal-overlay"></a>
    <div class="modal-content">
        <a href="#" class="close-btn">&times;</a>
        <h2>New Transaction</h2>
        <form action="${pageContext.request.contextPath}/save-transaction" method="POST">
            <div class="input-group">
                <label for="type">Operation Type</label>
                <select name="type" id="type">
                    <option value="EXPENSE">Expense</option>
                    <option value="INCOME">Income</option>
                </select>
            </div>
            <div class="input-group">
                <label for="title">Category</label>
                <input type="text" id="title" name="title" placeholder="e.g., Groceries, Salary" required>
            </div>
            <div class="input-group">
                <label for="amount">Amount ($)</label>
                <input type="number" id="amount" name="amount" step="0.01" placeholder="0.00" required>
            </div>
            <div class="input-group">
                <label for="date">Date</label>
                <input type="date" id="date" name="date" required>
            </div>
            <button type="submit" class="submit-btn">Save Transaction</button>
        </form>
    </div>
</div>

<script src="${pageContext.request.contextPath}/WEB-INF/script/script.js"></script>
</body>
</html>
