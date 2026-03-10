<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
    <link rel="stylesheet" href="/resources/styles/goals.css">
    <link rel="stylesheet" href="/resources/styles/base.css">
    <link rel="stylesheet" href="/resources/styles/sidebar.css">
    <link rel="stylesheet" href="/resources/styles/layout.css">
    <link rel="stylesheet" href="/resources/styles/dashboard.css">
    <link rel="stylesheet" href="/resources/styles/modal.css">
    <title>Neon Finance Tracker</title>
    <style>
        .menu-wrapper { position: relative; display: inline-block; }
        .menu-toggle { background: none; border: none; cursor: pointer; color: var(--dark); font-size: 20px; }
        .menu-dropdown { display: none; position: absolute; right: 0; background: #fff; box-shadow: 0 4px 10px rgba(0,0,0,0.1); border-radius: 8px; z-index: 1000; min-width: 150px; }
        .menu-dropdown.show { display: block; }
        .menu-item { padding: 10px 15px; display: flex; align-items: center; gap: 8px; text-decoration: none; color: #333; font-size: 14px; transition: 0.3s; width: 100%; text-align: left; border: none; background: none; cursor: pointer; }
        .menu-item:hover { background: #f4f4f4; }
        .delete-btn { color: #db504a; border-top: 1px solid #eee; }
        .goal-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px; }
        .goal-header h3 { margin: 0; }
    </style>
</head>
<body data-currency="${not empty user.currency ? user.currency : 'USD'}">
<c:set var="currencySymbol"><c:choose><c:when test="${user.currency.name() == 'USD'}">$</c:when><c:when test="${user.currency.name() == 'EUR'}">€</c:when><c:when test="${user.currency.name() == 'UAH'}">₴</c:when><c:otherwise>${not empty user.currency.name() ? user.currency.name() : '$'}</c:otherwise></c:choose></c:set>

<section id="sidebar">
    <a href="/home-page" class="brand">
        <i class='bx bx-wallet-alt bx-sm'></i>
        <span class="text">NeoFi Tracker</span>
    </a>
    <ul class="side-menu top">
        <li><a href="/home-page"><i class='bx bxs-dashboard bx-sm'></i><span class="text">Dashboard</span></a></li>
        <li><a href="/transaction-page"><i class='bx bx-transfer-alt bx-sm'></i><span class="text">Transactions</span></a></li>
        <li><a href="/analytics-page"><i class='bx bxs-doughnut-chart bx-sm'></i><span class="text">Analytics</span></a></li>
        <li class="active"><a href="/goals-page"><i class='bx bx-target-lock bx-sm'></i><span class="text">Financial Goals</span></a></li>
    </ul>
    <ul class="side-menu bottom">
        <li><a href="/profile-page"><i class='bx bxs-cog bx-sm'></i><span class="text">Settings</span></a></li>
        <li><a href="/logout" class="logout"><i class='bx bx-power-off bx-sm'></i><span class="text">Logout</span></a></li>
    </ul>
</section>
<div id="sidebar-overlay"></div>
<section id="content">
    <nav>
        <i class='bx bx-menu bx-sm' id='menu-toggle'></i>
        <form action="#">
            <div class="form-input">
                <input type="search" placeholder="Search...">
                <button type="submit" class="search-btn"><i class='bx bx-search'></i></button>
            </div>
        </form>
        <a href="/profile-page" class="profile">
            <img src="https://ui-avatars.com/api/?name=User&background=0D8ABC&color=fff" alt="Profile">
        </a>
    </nav>

    <main>
        <div class="head-title">
            <div class="left">
                <h1>Financial Goals</h1>
                <ul class="breadcrumb">
                    <li><a href="#">NeoFi</a></li>
                    <li><i class='bx bx-chevron-right'></i></li>
                    <li><a class="active" href="#">Goals</a></li>
                </ul>
            </div>
            <a href="#transactionModal" class="btn-download" onclick="prepareCreateModal()">
                <i class='bx bx-target-lock'></i>
                <span class="text">New Goal</span>
            </a>
        </div>

        <div class="goals-grid">
            <c:choose>
                <c:when test="${not empty goalRecords}">
                    <c:forEach items="${goalRecords}" var="record">
                        <div class="goal-card">
                            <div class="goal-header">
                                <h3>${record.title}</h3>
                                <div class="menu-wrapper">
                                    <button class="menu-toggle" onclick="toggleMenu(this)">
                                        <i class='bx bx-dots-horizontal-rounded'></i>
                                    </button>
                                    <div class="menu-dropdown">
                                        <button type="button" class="menu-item"
                                                onclick="openAddFundsModal('${record.id}', '${record.title}', '${record.currentMoney}', '${record.goalMoney}')">
                                            <i class='bx bx-plus-circle'></i> Add Money
                                        </button>
                                        <form action="${pageContext.request.contextPath}/delete-goal" method="POST"
                                              onsubmit="return confirm('Delete this goal?')">
                                            <input type="hidden" name="id" value="${record.id}">
                                            <button type="submit" class="menu-item delete-btn">
                                                <i class='bx bx-trash'></i> Delete
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </div>

                            <p class="goal-amount">
                                ${currencySymbol}<fmt:formatNumber value="${record.currentMoney}" maxFractionDigits="2"/>
                                <span>/ ${currencySymbol}<fmt:formatNumber value="${record.goalMoney}" maxFractionDigits="2"/></span>
                            </p>

                            <div class="progress-bar">
                                <div class="${record.progress >= 100 ? 'progress completed' : 'progress'}"
                                     style="width: ${record.progress}%;"></div>
                            </div>
                            <p class="goal-status"><fmt:formatNumber value="${record.progress}" maxFractionDigits="1"/>% completed</p>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <p>There are no goals</p>
                </c:otherwise>
            </c:choose>
        </div>
    </main>
</section>

<div id="transactionModal" class="modal">
    <a href="#" class="modal-overlay"></a>
    <div class="modal-content">
        <a href="#" class="close-btn" onclick="window.location.hash=''">×</a>
        <h2 id="modalTitle">New Goal</h2>

        <form id="goal-form" action="${pageContext.request.contextPath}/save-goal" method="POST"
              onsubmit="return validateBalance(this)">
            <input type="hidden" id="goalId" name="id" value="">

            <div class="input-group" id="categoryGroup">
                <label for="categoryInput">Goal Name</label>
                <input type="text" id="categoryInput" name="title" placeholder="e.g. New Car">
            </div>

            <div class="input-group" id="goalMoneyGroup">
                <label for="goalMoneyInput">Goal Amount (${currencySymbol})</label>
                <input type="number" id="goalMoneyInput" name="goalMoney" step="0.01" min="0.01">
            </div>

            <div class="input-group">
                <label id="amountLabel" for="amountInput">Initial Amount (${currencySymbol})</label>
                <input type="number" id="amountInput" name="currentMoney" step="0.01" value="0" required>
                <small id="currentStatusContainer" style="display:none;">
                    Current: <span id="currentStatus"></span>
                </small>
            </div>

            <button type="submit" id="submitBtn" class="submit-btn">Save</button>
        </form>
    </div>
</div>

<script>
    function toggleMenu(btn) {
        document.querySelectorAll('.menu-dropdown').forEach(d => {
            if (d !== btn.nextElementSibling) d.classList.remove('show');
        });
        btn.nextElementSibling.classList.toggle('show');
    }

    window.onclick = function(e) {
        if (!e.target.closest('.menu-wrapper')) {
            document.querySelectorAll('.menu-dropdown').forEach(d => d.classList.remove('show'));
        }
    };

    const userTotalBalance = ${totalBalance != null ? totalBalance : 0};
    const goalForm = document.getElementById('goal-form');

    function openAddFundsModal(id, title, current, goal) {
        document.getElementById('modalTitle').innerText = 'Add Funds to ' + title;
        document.getElementById('submitBtn').innerText = 'Deposit';
        goalForm.action = '${pageContext.request.contextPath}/add-funds-to-goal';

        document.getElementById('goalId').value = id;
        document.getElementById('categoryGroup').style.display = 'none';
        document.getElementById('categoryInput').required = false;
        document.getElementById('goalMoneyGroup').style.display = 'none';
        document.getElementById('goalMoneyInput').required = false;

        document.getElementById('amountLabel').innerText = 'Add Amount (${currencySymbol})';
        document.getElementById('amountInput').name = 'amount';
        document.getElementById('amountInput').value = '';

        document.getElementById('currentStatusContainer').style.display = 'block';
        document.getElementById('currentStatus').innerText = '$' + current + ' / $' + goal;

        window.location.hash = 'transactionModal';
    }

    function prepareCreateModal() {
        document.getElementById('modalTitle').innerText = 'New Goal';
        document.getElementById('submitBtn').innerText = 'Create Goal';
        goalForm.action = '${pageContext.request.contextPath}/save-goal';
        goalForm.reset();

        document.getElementById('goalId').value = '';
        document.getElementById('categoryGroup').style.display = 'block';
        document.getElementById('categoryInput').required = true;
        document.getElementById('goalMoneyGroup').style.display = 'block';
        document.getElementById('goalMoneyInput').required = true;

        document.getElementById('amountLabel').innerText = 'Initial Amount (${currencySymbol})';
        document.getElementById('amountInput').name = 'currentMoney';

        document.getElementById('currentStatusContainer').style.display = 'none';

        window.location.hash = 'transactionModal';
    }

    function validateBalance(form) {
        if (form.action.includes('add-funds-to-goal')) {
            const amount = parseFloat(document.getElementById('amountInput').value);
            if (amount > userTotalBalance) {
                return confirm('Warning! The amount ($' + amount + ') exceeds your balance ($' + userTotalBalance + '). Deposit anyway?');
            }
        }
        return true;
    }
</script>

<script>
(function () {
    var sidebar = document.getElementById("sidebar");
    var overlay = document.getElementById("sidebar-overlay");
    var menuBtn = document.getElementById("menu-toggle");
    if (!sidebar || !menuBtn) return;

    function isMobile()  { return window.innerWidth <= 480; }
    function isTablet()  { return window.innerWidth > 480 && window.innerWidth <= 768; }

    function openSidebar() {
        sidebar.classList.add("mobile-open");
        overlay.style.cssText = "display:block;opacity:1;";
        document.body.style.overflow = "hidden";
    }
    function closeSidebar() {
        sidebar.classList.remove("mobile-open");
        overlay.style.opacity = "0";
        setTimeout(function(){ overlay.style.display = "none"; }, 300);
        document.body.style.overflow = "";
    }

    menuBtn.addEventListener("click", function () {
        if (isMobile() || isTablet()) {
            sidebar.classList.contains("mobile-open") ? closeSidebar() : openSidebar();
        } else {
            sidebar.classList.toggle("hide");
        }
    });

    overlay.addEventListener("click", closeSidebar);

    sidebar.querySelectorAll(".side-menu li a").forEach(function (link) {
        link.addEventListener("click", function () {
            if (isMobile() || isTablet()) closeSidebar();
        });
    });

    window.addEventListener("resize", function () {
        if (window.innerWidth > 768) {
            sidebar.classList.remove("mobile-open");
            overlay.style.cssText = "display:none;opacity:0;";
            document.body.style.overflow = "";
        }
    });

    var touchStartX = 0;
    sidebar.addEventListener("touchstart", function (e) { touchStartX = e.touches[0].clientX; }, { passive: true });
    sidebar.addEventListener("touchend", function (e) {
        if (e.changedTouches[0].clientX - touchStartX < -60 && isMobile()) closeSidebar();
    }, { passive: true });
})();
</script>
</body>
</html>
