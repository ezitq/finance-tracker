<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/styles/finance-trakcer-pages.css">
    <title>Neon Finance Tracker</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>

<script th:inline="javascript">
    /* МАГІЯ THYMELEAF: Він автоматично перетворить Java Map у JS об'єкт JSON */
    const chartDataFromJava = /*[[${chartData}]]*/ {'Порожньо': 1};

    // Розділяємо ключі (категорії) та значення (суми)
    const labels = Object.keys(chartDataFromJava);
    const dataValues = Object.values(chartDataFromJava);

    // Знаходимо наш canvas
    const ctx = document.getElementById('expenseChart').getContext('2d');

    // Малюємо неоновий бублик (Doughnut Chart)
    new Chart(ctx, {
        type: 'doughnut', // 'pie' для звичайного круга, 'doughnut' для бублика
        data: {
            labels: labels,
            datasets: [{
                data: dataValues,
                // Наші фірмові неонові кольори
                backgroundColor: [
                    '#ff0055', // Neon Pink
                    '#00f3ff', // Neon Cyan
                    '#00ff66', // Neon Green
                    '#bc13fe', // Neon Purple
                    '#ffaa00'  // Neon Orange
                ],
                borderWidth: 2, // Товщина ліній між секторами
                borderColor: '#131318', // Колір фону вашої картки, щоб зробити відступи
                hoverOffset: 10 // Ефект висування сектора при наведенні мишки
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            cutout: '70%', // Робить бублик тоншим (для більшого стилю)
            plugins: {
                legend: {
                    position: 'right', // Легенда праворуч
                    labels: {
                        color: '#888899', // Колір тексту легенди (сірий)
                        font: {
                            family: "'Poppins', sans-serif",
                            size: 14
                        },
                        padding: 20
                    }
                }
            }
        }
    });
</script>


<body>
<section id="sidebar">
    <a href="/home-page" class="brand">
        <i class='bx bx-wallet-alt bx-sm'></i>
        <span class="text">NeoFi Tracker</span>
    </a>
    <ul class="side-menu top">
        <li>
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
        <li  class="active">
            <a href="/analytics-page">
                <i class='bx bxs-doughnut-chart bx-sm' ></i>
                <span class="text">Analytics</span>
            </a>
        </li>
        <li>
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
                <h1>Analytics</h1>
                <ul class="breadcrumb">
                    <li><a href="#">NeoFi</a></li>
                    <li><i class='bx bx-chevron-right' ></i></li>
                    <li><a class="active" href="#">Analytics</a></li>
                </ul>
            </div>
        </div>

        <div class="table-data">
            <div class="order">
                <div class="head">
                    <h3>Expenses VS Incomes</h3>
                </div>
                <div id="chartContainer" style="height: 370px; width: 100%;"></div>
            </div>
        </div>

        <script src="https://cdn.canvasjs.com/canvasjs.min.js"></script>

        <script type="text/javascript">
            window.onload = function() {

                // Створюємо порожній масив для JavaScript
                var dps = [];

                // МАГІЯ JSP: Сервер пройдеться по вашому списку з Java і згенерує JS-код
                <c:forEach items="${dataPointsList}" var="dataPoint">
                dps.push({
                    label: "${dataPoint.label}",
                    y: parseFloat("${dataPoint.y}")
                });
                </c:forEach>

                // Налаштовуємо графік
                var chart = new CanvasJS.Chart("chartContainer", {
                    theme: "dark2", // Темна тема!
                    backgroundColor: "transparent", // Прозорий фон, щоб видно було вашу картку
                    animationEnabled: true,
                    title: {
                        text: "Monthly",
                        fontFamily: "Poppins",
                        fontColor: "#00f3ff" // Неоновий блакитний
                    },
                    data: [{
                        type: "doughnut", // Можна змінити на "pie", якщо хочете суцільний круг
                        showInLegend: true,
                        legendText: "{label}",
                        indexLabelFontSize: 14,
                        indexLabelFontColor: "#fff",
                        indexLabel: "{label} - ${y}", // Знак долара перед сумою
                        dataPoints: dps // Передаємо наш згенерований масив
                    }]
                });

                // Малюємо графік
                chart.render();
            }
        </script>

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
                <input type="text" id="pageTitle" name="pageTitle" value="analytics-page" hidden="hidden">
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