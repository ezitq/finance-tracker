<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
<body data-currency="${not empty user.currency ? user.currency : 'USD'}">
<c:set var="currencySymbol"><c:choose><c:when test="${user.currency.name() == 'USD'}">$</c:when><c:when test="${user.currency.name() == 'EUR'}">€</c:when><c:when test="${user.currency.name() == 'UAH'}">₴</c:when><c:otherwise>${not empty user.currency.name() ? user.currency.name() : '$'}</c:otherwise></c:choose></c:set>

<section id="sidebar">
    <a href="/home-page" class="brand">
        <i class='bx bx-wallet-alt bx-sm'></i>
        <span class="text">NeoFi Tracker</span>
    </a>
    <ul class="side-menu top">
        <li>
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
        <li class="active">
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
<div id="sidebar-overlay"></div>
<section id="content">
    <nav>
        <i class='bx bx-menu bx-sm' id='menu-toggle'></i>
        <form action="#">
            <div class="form-input">
                <input type="search" placeholder="Search transactions...">
                <button type="submit" class="search-btn"><i class='bx bx-search'></i></button>
            </div>
        </form>
        <a href="/profile-page" class="profile" id="profileIcon">
            <img src="https://ui-avatars.com/api/?name=User&background=0D8ABC&color=fff" alt="Profile">
        </a>
    </nav>

    <main>
        <div class="head-title">
            <div class="left">
                <h1>Analytics</h1>
                <ul class="breadcrumb">
                    <li><a href="#">NeoFi</a></li>
                    <li><i class='bx bx-chevron-right'></i></li>
                    <li><a class="active" href="#">Analytics</a></li>
                </ul>
            </div>
        </div>

        <div class="table-data">
            <div class="order">
                <div class="head">
                    <h3>Expenses VS Incomes</h3>
                </div>
                <div id="chartContainer" style="height: 370px; width: 100%; position: relative;">
                    <canvas id="expenseChart"></canvas>
                </div>
            </div>
        </div>
    </main>
</section>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    var labels = [];
    var dataValues = [];

    <c:forEach items="${dataPointsList}" var="entry">
    labels.push("${entry.key}");
    dataValues.push(parseFloat("${entry.value}"));
    </c:forEach>

    var ctx = document.getElementById('expenseChart').getContext('2d');
    new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: labels,
            datasets: [{
                data: dataValues,
                backgroundColor: ['#ff0055', '#00f3ff', '#00ff66', '#bc13fe', '#ffaa00', '#ff6600', '#0099ff'],
                borderWidth: 2,
                borderColor: '#131318',
                hoverOffset: 10
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            cutout: '70%',
            plugins: {
                legend: {
                    position: 'right',
                    labels: {
                        color: '#888899',
                        font: { family: "'Poppins', sans-serif", size: 14 },
                        padding: 20
                    }
                }
            }
        }
    });
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
