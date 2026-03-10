/**
 * currency-theme.js
 * -----------------
 * Читає data-currency з <body>, застосовує CSS-тему
 * і замінює всі символи валюти на сторінці.
 *
 * Підключати у КОЖНОМУ JSP перед закриваючим </body>:
 *   <script src="/resources/scripts/currency-theme.js"></script>
 *
 * У <body> потрібен атрибут:
 *   <body data-currency="${user.currency != null ? user.currency : 'USD'}">
 */

(function () {
    'use strict';

    /* ── 1. Конфіг валют ─────────────────────────────────── */
    var CURRENCIES = {
        USD: { symbol: '$',  label: 'USD', cssClass: 'currency-USD' },
        EUR: { symbol: '€',  label: 'EUR', cssClass: 'currency-EUR' },
        UAH: { symbol: '₴',  label: 'UAH', cssClass: 'currency-UAH' },
        GBP: { symbol: '£',  label: 'GBP', cssClass: 'currency-GBP' },
        PLN: { symbol: 'zł', label: 'PLN', cssClass: 'currency-PLN' },
        CHF: { symbol: '₣',  label: 'CHF', cssClass: 'currency-CHF' },
    };

    var DEFAULT = 'USD';

    /* ── 2. Читаємо поточну валюту ───────────────────────── */
    var body     = document.body;
    var raw      = (body.dataset.currency || DEFAULT).trim().toUpperCase();
    var config   = CURRENCIES[raw] || CURRENCIES[DEFAULT];

    /* ── 3. Застосовуємо CSS-клас теми ──────────────────── */
    // Прибираємо старі currency-* класи
    body.className = body.className
        .replace(/\bcurrency-\S+/g, '')
        .trim();
    body.classList.add(config.cssClass);

    /* ── 4. Замінюємо символ "$" у текстових вузлах ─────── */
    // Тільки якщо валюта не USD ($ залишається без змін)
    if (config.symbol !== '$') {
        replaceCurrencySymbols(document.body, '$', config.symbol);
    }

    /* ── 5. Оновлюємо лейбл у формі Amount ($) тощо ─────── */
    updateAmountLabels(config.symbol);

    /* ── 6. Вставляємо бейдж валюти у navbar ────────────── */
    injectCurrencyBadge(config);

    /* ── 7. Слухаємо зміну select на сторінці профілю ───── */
    var currencySelect = document.querySelector('select[name="currency"]');
    if (currencySelect) {
        currencySelect.addEventListener('change', function () {
            var next = (this.value || DEFAULT).trim().toUpperCase();
            applyTheme(CURRENCIES[next] || CURRENCIES[DEFAULT]);
        });
    }

    /* ═══════════════════════════════════════════════════════
       ДОПОМІЖНІ ФУНКЦІЇ
       ═══════════════════════════════════════════════════════ */

    /**
     * Рекурсивно обходить DOM і замінює символ валюти
     * у текстових вузлах (не чіпаємо атрибути/скрипти/стилі).
     */
    function replaceCurrencySymbols(root, from, to) {
        var skipTags = { SCRIPT: 1, STYLE: 1, TEXTAREA: 1, INPUT: 1 };

        function walk(node) {
            if (node.nodeType === Node.TEXT_NODE) {
                if (node.textContent.indexOf(from) !== -1) {
                    node.textContent = node.textContent.split(from).join(to);
                }
            } else if (node.nodeType === Node.ELEMENT_NODE) {
                if (skipTags[node.tagName]) return;
                // Не чіпаємо data-атрибути — вони потрібні JS
                for (var i = 0; i < node.childNodes.length; i++) {
                    walk(node.childNodes[i]);
                }
            }
        }

        walk(root);
    }

    /**
     * Оновлює label-текст у формах де захардкоджено "($)"
     * наприклад: "Amount ($)" → "Amount (₴)"
     */
    function updateAmountLabels(symbol) {
        var labels = document.querySelectorAll('label');
        labels.forEach(function (label) {
            label.textContent = label.textContent.replace(/\(\$\)/g, '(' + symbol + ')');
        });

        // Також placeholder у input[placeholder="0.00"] не потребує змін,
        // але label for="amount" "Amount ($)" → оновлюємо
        var amountLabel = document.getElementById('amountLabel');
        if (amountLabel) {
            amountLabel.textContent = amountLabel.textContent.replace(/\(\$\)/g, '(' + symbol + ')');
        }
    }

    /**
     * Вставляє бейдж з символом валюти в navbar
     * між іконкою меню і пошуковою формою.
     */
    function injectCurrencyBadge(cfg) {
        // Видаляємо старий бейдж якщо є (при динамічній зміні)
        var old = document.getElementById('currency-badge');
        if (old) old.remove();

        var nav = document.querySelector('#content nav');
        if (!nav) return;

        var badge = document.createElement('span');
        badge.id = 'currency-badge';
        badge.className = 'currency-badge';
        badge.title = cfg.label;
        badge.textContent = cfg.symbol;

        // Вставляємо після .bx-menu кнопки
        var menuBtn = nav.querySelector('#menu-toggle');
        if (menuBtn && menuBtn.nextSibling) {
            nav.insertBefore(badge, menuBtn.nextSibling);
        } else {
            nav.appendChild(badge);
        }
    }

    /**
     * Повна зміна теми (при зміні select в real-time).
     * Не робить reload — лише CSS клас + символи.
     */
    function applyTheme(cfg) {
        // Оновлюємо data-атрибут
        body.dataset.currency = cfg.label;

        // Міняємо CSS клас
        body.className = body.className.replace(/\bcurrency-\S+/g, '').trim();
        body.classList.add(cfg.cssClass);

        // Оновлюємо бейдж
        var badge = document.getElementById('currency-badge');
        if (badge) {
            badge.textContent = cfg.symbol;
            badge.title = cfg.label;
        }

        // Символи на сторінці — перезавантажуємо через невидимий clone
        // (простіший підхід: reload після збереження форми — символи
        //  підставляються при завантаженні сторінки з бекенду)
        // Тут тільки badge оновлюємо в реальному часі.
    }

})();
