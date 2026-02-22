<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/styles/finance-trakcer-pages.css">
    <title>Neon Finance Tracker</title>
</head>
<body>
<section id="sidebar">
    <a href="/home-page" class="brand">
        <i class='bx bx-wallet-alt bx-sm'></i>
        <span class="text">NeoFi Tracker</span>
    </a>
    <ul class="side-menu top">
        <li >
            <a href="/home-page">
                <i class='bx bxs-dashboard bx-sm' ></i>
                <span class="text">Dashboard</span>
            </a>
        </li>
        <li>
            <a href="/transaction-page">
                <i class='bx bx-transfer-alt bx-sm' ></i>
                <span class="text">Transactions</span>
            </a>
        </li>
        <li>
            <a href="/analytics-page">
                <i class='bx bxs-doughnut-chart bx-sm' ></i>
                <span class="text">Analytics</span>
            </a>
        </li>
        <li class="active">
            <a href="/goals-page">
                <i class='bx bx-target-lock bx-sm' ></i>
                <span class="text">Financial Goals</span>
            </a>
        </li>
    </ul>
</section>
<section id="content">
    <nav>
        <i class='bx bx-menu bx-sm' ></i>
        <form action="#">
            <div class="form-input">
                <input type="search" placeholder="Search transactions...">
                <button type="submit" class="search-btn"><i class='bx bx-search' ></i></button>
            </div>
        </form>

        <a href="#" class="notification" id="notificationIcon">
            <i class='bx bxs-bell bx-tada-hover' ></i>
            <span class="num">2</span>
        </a>

        <a href="/profile-page" class="profile" id="profileIcon">
            <img src="https://ui-avatars.com/api/?name=User&background=0D8ABC&color=fff" alt="Profile">
        </a>
    </nav>
    <main>
        <div class="head-title">
            <div class="left">
                <h1>Financial Goals</h1>
                <ul class="breadcrumb">
                    <li><a href="#">NeoFi</a></li>
                    <li><i class='bx bx-chevron-right' ></i></li>
                    <li><a class="active" href="#">Goals</a></li>
                </ul>
            </div>
            <a href="#" class="btn-download">
                <i class='bx bx-target-lock' ></i>
                <span class="text">New Goal</span>
            </a>
        </div>

        <div class="goals-grid">
            <div class="goal-card">
                <div class="goal-header">
                    <i class='bx bx-car icon car'></i>
                    <i class='bx bx-dots-horizontal-rounded menu'></i>
                </div>
                <h3>New Car</h3>
                <p class="goal-amount">$8,000 <span>/ $20,000</span></p>
                <div class="progress-bar">
                    <div class="progress" style="width: 40%;"></div>
                </div>
                <p class="goal-status">40% Completed</p>
            </div>

            <div class="goal-card">
                <div class="goal-header">
                    <i class='bx bx-briefcase-alt-2 icon shield'></i>
                    <i class='bx bx-dots-horizontal-rounded menu'></i>
                </div>
                <h3>Emergency Fund</h3>
                <p class="goal-amount">$5,000 <span>/ $5,000</span></p>
                <div class="progress-bar">
                    <div class="progress completed" style="width: 100%;"></div>
                </div>
                <p class="goal-status status-done">100% Completed</p>
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
                <label for="category">Category</label>
                <input type="text" id="category" name="category" placeholder="e.g., Groceries, Salary" required>
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