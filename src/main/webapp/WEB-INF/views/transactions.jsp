<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>

    <%--Styles--%>
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
        <li>
            <a href="/home-page">
                <i class='bx bxs-dashboard bx-sm' ></i>
                <span class="text">Dashboard</span>
            </a>
        </li>
        <li class="active">
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
        <li>
            <a href="/goals-page">
                <i class='bx bx-target-lock bx-sm' ></i>
                <span class="text">Financial Goals</span>
            </a>
        </li>
    </ul>
    <ul class="side-menu bottom">
        <li>
            <a href="#">
                <i class='bx bxs-cog bx-sm' ></i>
                <span class="text">Settings</span>
            </a>
        </li>
        <li>
            <a href="/" class="logout">
                <i class='bx bx-power-off bx-sm' ></i>
                <span class="text">Logout</span>
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

        <a href="#" class="profile" id="profileIcon">
            <img src="https://ui-avatars.com/api/?name=User&background=0D8ABC&color=fff" alt="Profile">
        </a>
    </nav>
    <main>
        <div class="head-title">
            <div class="left">
                <h1>Transactions</h1>
                <ul class="breadcrumb">
                    <li><a href="#">NeoFi</a></li>
                    <li><i class='bx bx-chevron-right' ></i></li>
                    <li><a class="active" href="#">Transactions</a></li>
                </ul>
            </div>
            <a href="#transactionModal" class="btn-download">
                <i class='bx bx-plus' ></i>
                <span class="text">Add Transaction</span>
            </a>
        </div>

        <div class="table-data">
            <div class="order">
                <div class="head">
                    <h3>Transaction History</h3>
                    <div class="filters">
                        <input type="month" class="date-filter">
                        <i class='bx bx-filter' ></i>
                    </div>
                </div>
                <table>
                    <thead>
                    <tr>
                        <th>Title</th>
                        <th>Type</th>
                        <th>Date</th>
                        <th>Amount</th>
                        <th>Action</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>

                    <c:when test="${not empty financeRecords}">

                    <c:forEach items="${financeRecords}" var="record">



                        <tr>
                            <td>
                                <div class="icon-box food"><i class='bx bx-restaurant'></i></div>
                                <p>${record.title}</p>
                            </td>
                            <td>${record.type}</td>
                            <td>${record.date}</td>
                            <td><span class="${record.type == "INCOME" ? "status income" : "status expense"} ">
                                    ${record.type == "INCOME" ? "" : "-"}$${record.amount}</span></td>
                            <td>
                        <c:choose>

                                <c:when test="${record.type != 'GOAL'}">

                                    <button class="action-btn edit"
                                            data-id="${record.id}"
                                            data-type="${record.type}"
                                            data-title="${record.title}"
                                            data-amount="${record.amount}"
                                            data-date="${record.date}"
                                            onclick="openEditModal(this)">
                                        <i class='bx bx-edit'></i>
                                    </button>

                                </c:when>


                        </c:choose>
                                <form action="/delete-transaction" method="post">

                                    <input type="hidden" name="id" value="${record.id}">
                                    <button type="submit" class="action-btn delete"><i class='bx bx-trash'></i></button>

                                </form>

                            </td>
                        </tr>

                    </c:forEach>
                    </c:when>
                    <c:otherwise >
                        <tr>
                            <td>
                                <p>There are no transactions</p>
                            </td>

                        </tr>



                    </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
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
            <input type="hidden" id="recordId" name="id" value="">
            <div class="input-group">
                <label for="type">Operation Type</label>
                <select name="type" id="type">
                    <option value="EXPENSE">Expense</option>
                    <option value="INCOME">Income</option>
                </select>
            </div>

            <div class="input-group">
                <label for="title">Title</label>
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




<script>
    function openEditModal(btn) {
        const form = document.querySelector('#transactionModal form');

        // Switch form to update mode
        form.action = '/update-transaction';
        document.getElementById('recordId').value = btn.dataset.id;

        // Pre-fill the fields
        document.getElementById('type').value        = btn.dataset.type;
        document.getElementById('title').value    = btn.dataset.title;
        document.getElementById('amount').value      = btn.dataset.amount;
        document.getElementById('date').value        = btn.dataset.date;

        // Update modal title
        document.querySelector('#transactionModal h2').textContent = 'Edit Transaction';

        // Open the modal
        window.location.hash = 'transactionModal';
    }

    document.querySelector('a[href="#transactionModal"]').addEventListener('click', () => {
        const form = document.querySelector('#transactionModal form');
        form.action = '/save-transaction';
        form.reset();
        document.getElementById('recordId').value = '';
        document.querySelector('#transactionModal h2').textContent = 'New Transaction';
    });


</script>
</body>
</html>