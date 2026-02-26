<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/styles/finance-trakcer-pages.css">
    <title>Neon Finance Tracker</title>
    <style>
        .menu-wrapper { position: relative; display: inline-block; }
        .menu-toggle { background: none; border: none; cursor: pointer; color: var(--dark); font-size: 20px; }
        .menu-dropdown {
            display: none;
            position: absolute;
            right: 0;
            background: #fff;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            border-radius: 8px;
            z-index: 1000;
            min-width: 150px;
        }
        .menu-dropdown.show { display: block; }
        .menu-item {
            padding: 10px 15px;
            display: flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
            color: #333;
            font-size: 14px;
            transition: 0.3s;
            width: 100%;
            text-align: left;
            border: none;
            background: none;
            cursor: pointer;
        }
        .menu-item:hover { background: #f4f4f4; }
        .delete-btn { color: #db504a; border-top: 1px solid #eee; }
        .goal-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px; }
        .goal-header h3 { margin: 0; }
    </style>
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
        <li class="active"><a href="/goals-page"><i class='bx bx-target-lock bx-sm'></i><span class="text">Financial Goals</span></a></li>
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
        <a href="/profile-page" class="profile"><img src="https://ui-avatars.com/api/?name=User&background=0D8ABC&color=fff"></a>
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
                        <c:if test="${record.currentMoney / record.goalMoney * 100 >= 100}">
                            <form action="${pageContext.request.contextPath}/delete-goal" method="POST"
                                  onsubmit="return confirm('Видалити ціль?')" style="display:inline;">
                                <input type="hidden" name="id" value="${record.id}">
                                <button type="submit" class="quick-delete-btn">
                                    <i class="">Delete?</i> </button>
                            </form>
                        </c:if>
                        <div class="menu-wrapper">
                            <button class="menu-toggle" onclick="toggleMenu(this)">
                                <i class='bx bx-dots-horizontal-rounded'></i>
                            </button>
                            <div class="menu-dropdown">
                                <button type="button" class="menu-item"
                                        onclick="openAddFundsModal('${record.id}', '${record.title}', '${record.currentMoney}', '${record.goalMoney}')">
                                    <i class='bx bx-plus-circle'></i> Add Money
                                </button>

                                <form action=" ${pageContext.request.contextPath}/delete-goal" method="POST" onsubmit="return confirm('Delete this goal?')">
                                    <input type="hidden" name="id" value="${record.id}">
                                    <button type="submit" class="menu-item delete-btn">
                                        <i class='bx bx-trash'></i> Delete
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>

                    <p class="goal-amount">$${record.currentMoney} <span>/ $${record.goalMoney}</span></p>

                    <c:set var="percent" value="${recordService.calculatePercentage(record)}" />
                    <div class="progress-bar" >
                        <div class="${percent >=100 ? 'progress completed' : 'progress'}" style="width: ${percent}%;"></div>
                    </div>
                    <p class="goal-status">${percent}% completed</p>
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
        <a href="#" class="close-btn" onclick="window.location.hash=''">&times;</a>
        <h2 id="modalTitle">Goal</h2>

                <form id="goal-form" action="${pageContext.request.contextPath}/save-goal" method="POST"
                onsubmit="validateBalance(this)">
                    <input type="hidden" id="goalId" name="id" value="">

                    <div class="input-group" id="categoryGroup">
                        <label for="categoryInput">Goal Name</label>
                        <input type="text" id="categoryInput" name="category" placeholder="e.g. New Car">
                    </div>

                    <div class="input-group">
                        <label id="amountLabel" for="amountInput">Amount ($) </label>
                        <input type="number" id="amountInput" name="amount" step="0.01" required>
                        <small id="currentStatusContainer" style="display:none;">
                            Current: <span id="currentStatus"></span>
                        </small>
                    </div>

                    <button type="submit" id="submitBtn" class="submit-btn">Save</button>
                </form>

    </div>
</div>

<script>
    // --- Логіка Dropdown меню ---
    function toggleMenu(btn) {
        // Закриваємо всі інші відкриті меню
        document.querySelectorAll('.menu-dropdown').forEach(d => {
            if (d !== btn.nextElementSibling) d.classList.remove('show');
        });
        // Відкриваємо/закриваємо поточне
        btn.nextElementSibling.classList.toggle('show');
    }

    // Закриття меню при кліку поза ним
    window.onclick = function(e) {
        if (!e.target.closest('.menu-wrapper')) {
            document.querySelectorAll('.menu-dropdown').forEach(d => d.classList.remove('show'));
        }
    }

    // --- Логіка Модального вікна ---
    const userTotalBalance = ${totalBalance != null ? totalBalance : 0};
    const goalForm = document.getElementById('goal-form');
    const modalTitle = document.getElementById('modalTitle');
    const submitBtn = document.getElementById('submitBtn');
    const categoryInput = document.getElementById('categoryInput');
    const amountLabel = document.getElementById('amountLabel');
    const amountInput = document.getElementById('amountInput');
    const statusContainer = document.getElementById('currentStatusContainer');

    function openAddFundsModal(id, title, current, goal) {
        modalTitle.innerText = 'Add Funds to ' + title;
        submitBtn.innerText = 'Deposit';
        goalForm.action = '${pageContext.request.contextPath}/add-funds';

        document.getElementById('goalId').value = id;

        // Для поповнення нам не треба редагувати назву
        document.getElementById('categoryGroup').style.display = 'none';
        categoryInput.required = false;

        amountLabel.innerText = 'Add Amount ($))';
        amountInput.name = 'amountToAdd';
        amountInput.value = '';

        statusContainer.style.display = 'block';
        document.getElementById('currentStatus').innerText = '$' + current + ' / $' + goal;

        window.location.hash = 'transactionModal';
    }

    function validateBalance(form) {
        // Перевіряємо тільки якщо ми в режимі "Add Funds" (Deposit)
        if (form.action.includes('add-funds')) {
            const amountToDeposit = parseFloat(document.getElementById('amountInput').value);

            if (amountToDeposit > userTotalBalance) {
                // Вискакує стандартне вікно браузера з питанням
                const proceed = confirm("Warning! The amount ($" + amountToDeposit + ") is bigger than your current balance($" + userTotalBalance + "). Deposit anyway?");

                // Якщо юзер натиснув "Скасувати" (Cancel) - форма НЕ відправиться
                if (!proceed) {
                    return false;
                }
            }
        }
        return true; // Якщо балансу ок або юзер підтвердив - форма відправляється
    }

    function prepareCreateModal() {
        modalTitle.innerText = 'New Goal';
        submitBtn.innerText = 'Create Goal';
        goalForm.action = '${pageContext.request.contextPath}/save-goal';

        document.getElementById('goalId').value = '';
        document.getElementById('categoryGroup').style.display = 'block';
        categoryInput.required = true;
        categoryInput.value = '';

        amountLabel.innerText = 'Goal Amount ($)';
        amountInput.name = 'amount';
        amountInput.value = '';

        statusContainer.style.display = 'none';

        window.location.hash = 'transactionModal';
    }

</script>
</body>
</html>