<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        color: #333;
        background-color: #f8f9fa;
        line-height: 1.6;
        min-height: 100vh;
        display: flex;
        flex-direction: column;
    }
    a { text-decoration: none; color: inherit; }

    .customer-header { background: #fff; box-shadow: 0 2px 10px rgba(0,0,0,0.08); position: sticky; top: 0; z-index: 1000; }
    .customer-header .navbar {
        display: grid;
        grid-template-columns: 1fr auto 1fr;
        align-items: center;
        max-width: 1200px;
        margin: 0 auto;
        padding: 15px 20px;
        gap: 16px;
    }
    .logo { font-size: 24px; font-weight: bold; color: #ff385c; white-space: nowrap; justify-self: start; }
    .nav-links {
        display: flex; list-style: none; gap: 28px; margin: 0; padding: 0;
        align-items: center; justify-content: center;
    }
    .nav-links a { font-weight: 500; color: #333; white-space: nowrap; }
    .nav-links a:hover { color: #ff385c; }
    .auth-buttons { display: flex; gap: 10px; align-items: center; justify-self: end; white-space: nowrap; }
    .cart-link { position: relative; display: inline-flex; align-items: center; gap: 6px; }
    .cart-badge {
        min-width: 18px; height: 18px; padding: 0 5px; border-radius: 999px;
        background: #ff385c; color: #fff; font-size: 11px; font-weight: 700;
        display: inline-flex; align-items: center; justify-content: center;
    }
    .success { color: #155724; background: #d4edda; padding: 10px 12px; border-radius: 8px; margin-bottom: 12px; }

    .btn, .btn-accent, .btn-outline { padding: 8px 18px; border-radius: 20px; border: none; cursor: pointer; font-weight: 600; display: inline-block; }
    .btn-outline { border: 1px solid #ff385c; color: #ff385c; background: transparent; }
    .btn-accent, .btn-primary { background: #ff385c; color: #fff !important; }
    .btn:hover, .btn-accent:hover { opacity: 0.85; }

    .page-wrap { width: 100%; max-width: 1200px; margin: 30px auto; padding: 0 20px 40px; flex: 1 0 auto; }
    .card-box { background: #fff; padding: 24px; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); }
    .auth-page {
        flex: 1 0 auto;
        display: flex;
        align-items: center;
        justify-content: center;
        width: 100%;
        padding: 40px 20px;
        min-height: 0;
    }
    .auth-card {
        width: 100%;
        max-width: 440px;
        padding: 36px 32px;
        border-radius: 16px;
        box-shadow: 0 8px 28px rgba(0,0,0,0.08);
        border: 1px solid #eee;
        background: #fff;
    }
    .auth-card h2 { text-align: center; margin-bottom: 24px; font-size: 1.6rem; }
    .auth-card .btn-accent { width: 100%; padding: 12px 18px; font-size: 15px; }
    .auth-card .auth-switch { text-align: center; margin-top: 18px; }
    .content-page {
        flex: 1 0 auto;
        width: 100%;
        display: flex;
        justify-content: center;
        align-items: flex-start;
        padding: 36px 20px 48px;
    }
    .content-shell { width: 100%; max-width: 980px; }
    .page-title { text-align: center; margin-bottom: 22px; font-size: 1.6rem; }
    .panel-card {
        background: #fff;
        border: 1px solid #eee;
        border-radius: 16px;
        box-shadow: 0 8px 28px rgba(0,0,0,0.06);
        overflow: hidden;
    }
    .empty-state { text-align: center; padding: 56px 24px; background: #fff; border: 1px solid #eee; border-radius: 16px; box-shadow: 0 8px 28px rgba(0,0,0,0.06); }
    .empty-state i { font-size: 38px; color: #ff385c; margin-bottom: 12px; }
    .empty-state p { color: #666; margin-bottom: 18px; }
    .status-pill { display: inline-block; padding: 4px 10px; border-radius: 999px; font-size: 12px; font-weight: 700; background: #f3f3f3; color: #444; }
    .status-PENDING, .status-Pending { background: #fff4e5; color: #8a5a00; }
    .status-CONFIRMED, .status-Confirmed { background: #e8f6ee; color: #1e7e34; }
    .status-CHECKED_IN { background: #e8f1ff; color: #1d4ed8; }
    .status-CHECKED_OUT { background: #eef0f3; color: #4b5563; }
    .status-CANCELLED, .status-Cancelled { background: #fde8e8; color: #b42318; }
    .cart-layout { display: grid; grid-template-columns: minmax(0, 1fr) 320px; gap: 20px; align-items: start; }
    .cart-item { display: flex; gap: 16px; align-items: center; background: #fff; padding: 16px; border-radius: 16px; border: 1px solid #eee; margin-bottom: 14px; box-shadow: 0 4px 16px rgba(0,0,0,0.05); }
    .cart-item img { width: 148px; height: 108px; object-fit: cover; border-radius: 10px; flex-shrink: 0; }
    .cart-summary { background: #fff; padding: 22px; border-radius: 16px; border: 1px solid #eee; box-shadow: 0 8px 28px rgba(0,0,0,0.06); position: sticky; top: 90px; }
    .cart-summary .btn-accent, .cart-summary .btn-outline { width: 100%; text-align: center; margin-top: 10px; padding: 11px 18px; }
    table.data { width: 100%; border-collapse: collapse; background: #fff; border-radius: 12px; overflow: hidden; box-shadow: 0 2px 8px rgba(0,0,0,0.05); margin-top: 15px; }
    .panel-card table.data tbody tr { cursor: pointer; }
    .panel-card table.data tbody tr:hover { background: #fff7f8; }
    .panel-card table.data th:first-child { padding-left: 20px; }
    .panel-card table.data td:first-child { padding-left: 20px; }
    .action-cell { display: flex; gap: 8px; flex-wrap: wrap; align-items: center; }
    @media (max-width: 800px) {
        .cart-layout { grid-template-columns: 1fr; }
        .cart-item { flex-direction: column; align-items: stretch; }
        .cart-item img { width: 100%; height: 180px; }
        .cart-summary { position: static; }
    }
    table.data th, table.data td { padding: 12px; border-bottom: 1px solid #eee; text-align: left; }
    table.data th { background: #222; color: #fff; }
    .form-group { margin-bottom: 15px; }
    .form-group label { display: block; margin-bottom: 6px; font-weight: 600; font-size: 14px; }
    .form-group input, .form-group select, .form-group textarea { width: 100%; padding: 10px; border: 1px solid #ced4da; border-radius: 8px; font-size: 15px; }
    .error { color: #dc3545; margin-bottom: 12px; }

    .vn-date-wrap { position: relative; display: block; width: 100%; }
    .search-item .vn-date-wrap { width: auto; min-width: 148px; }
    .vn-date-wrap .vn-date { width: 100%; padding-right: 36px !important; }
    .vn-date-wrap .vn-date-btn {
        position: absolute; right: 2px; top: 50%; transform: translateY(-50%);
        width: 32px; height: 32px; border: 0; background: transparent;
        color: #666; cursor: pointer; z-index: 3; display: flex;
        align-items: center; justify-content: center;
    }
    .vn-date-wrap .vn-date-btn:hover { color: #ff385c; }
    .vn-cal {
        position: fixed; z-index: 2500; width: 280px; background: #fff; color: #333;
        border-radius: 12px; box-shadow: 0 10px 30px rgba(0,0,0,0.18); padding: 12px;
    }
    .vn-cal-head { display: flex; align-items: center; justify-content: space-between; margin-bottom: 8px; }
    .vn-cal-head strong { font-size: 14px; }
    .vn-cal-head button {
        width: 28px; height: 28px; border: 0; border-radius: 50%; background: #f3f3f3; cursor: pointer;
    }
    .vn-cal-grid { display: grid; grid-template-columns: repeat(7, 1fr); gap: 2px; text-align: center; font-size: 13px; }
    .vn-cal-grid .dow { color: #888; font-weight: 600; padding: 6px 0; }
    .vn-cal-grid button {
        border: 0; background: transparent; padding: 7px 0; border-radius: 8px; cursor: pointer; color: #333;
    }
    .vn-cal-grid button:hover { background: #fff1f3; color: #ff385c; }
    .vn-cal-grid button.muted { color: #ccc; }
    .vn-cal-grid button.today { box-shadow: inset 0 0 0 1px #ff385c; }
    .vn-cal-grid button.selected { background: #ff385c; color: #fff; }
    footer, .site-footer { margin-top: auto; width: 100%; flex-shrink: 0; }
</style>
<header class="customer-header">
    <div class="navbar">
        <a href="${pageContext.request.contextPath}/" class="logo"><i class="fa-solid fa-hotel"></i> LuxStay</a>
        <ul class="nav-links">
            <li><a href="${pageContext.request.contextPath}/room/list">Đặt phòng</a></li>
            <li><a href="${pageContext.request.contextPath}/booking/history">Lịch sử</a></li>
            <li><a href="${pageContext.request.contextPath}/cart" class="cart-link">
                Giỏ hàng
                <c:if test="${not empty sessionScope.cart && sessionScope.cart.itemCount > 0}">
                    <span class="cart-badge">${sessionScope.cart.itemCount}</span>
                </c:if>
            </a></li>
            <li><a href="${pageContext.request.contextPath}/#noi-bat">Nổi bật</a></li>
        </ul>
        <div class="auth-buttons">
            <c:choose>
                <c:when test="${not empty sessionScope.currentUser}">
                    <c:if test="${sessionScope.currentUser.roleId == 1}">
                        <a href="${pageContext.request.contextPath}/admin/room/list" class="btn-outline">Quản trị</a>
                    </c:if>
                    <c:if test="${sessionScope.currentUser.roleId == 2}">
                        <a href="${pageContext.request.contextPath}/booking/admin/list" class="btn-outline">Đơn đặt phòng</a>
                    </c:if>
                    <a href="${pageContext.request.contextPath}/customer/profile" class="btn-outline">
                        <i class="fa-solid fa-user"></i> ${sessionScope.currentUser.fullName}
                    </a>
                    <a href="${pageContext.request.contextPath}/customer/logout" class="btn-accent">Đăng xuất</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/customer/login" class="btn-outline">Đăng nhập</a>
                    <a href="${pageContext.request.contextPath}/customer/register" class="btn-accent">Đăng ký</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</header>
<script>
(function () {
    var MONTHS = ['Tháng 1','Tháng 2','Tháng 3','Tháng 4','Tháng 5','Tháng 6','Tháng 7','Tháng 8','Tháng 9','Tháng 10','Tháng 11','Tháng 12'];
    var DAYS = ['CN','T2','T3','T4','T5','T6','T7'];
    var openCal = null;
    var origSubmit = HTMLFormElement.prototype.submit;

    function pad(n) { return n < 10 ? '0' + n : '' + n; }
    function isoToVn(value) {
        var m = String(value || '').trim().match(/^(\d{4})-(\d{2})-(\d{2})$/);
        return m ? m[3] + '/' + m[2] + '/' + m[1] : value;
    }
    function vnToIso(value) {
        var m = String(value || '').trim().match(/^(\d{2})\/(\d{2})\/(\d{4})$/);
        return m ? m[3] + '-' + m[2] + '-' + m[1] : '';
    }
    function convertFormDates(form) {
        if (!form || !form.querySelectorAll) return;
        form.querySelectorAll('input.vn-date').forEach(function (field) {
            var iso = vnToIso(field.value);
            if (iso) field.value = iso;
        });
    }
    HTMLFormElement.prototype.submit = function () {
        convertFormDates(this);
        origSubmit.call(this);
    };
    document.addEventListener('submit', function (e) {
        convertFormDates(e.target);
    }, true);
    function formatTyping(value) {
        var digits = String(value || '').replace(/\D/g, '').slice(0, 8);
        if (digits.length >= 5) return digits.slice(0, 2) + '/' + digits.slice(2, 4) + '/' + digits.slice(4);
        if (digits.length >= 3) return digits.slice(0, 2) + '/' + digits.slice(2);
        return digits;
    }
    function parseVnDate(value) {
        var iso = vnToIso(value);
        if (!iso) return null;
        var p = iso.split('-');
        return new Date(Number(p[0]), Number(p[1]) - 1, Number(p[2]));
    }
    function submitIsoForm(form) {
        if (!form) return;
        form.querySelectorAll('input.vn-date').forEach(function (field) {
            var iso = vnToIso(field.value);
            if (iso) field.value = iso;
        });
        form.submit();
    }
    function closeCalendar() {
        if (openCal) {
            openCal.remove();
            openCal = null;
        }
    }
    function openCalendar(input, btn) {
        closeCalendar();
        var selected = parseVnDate(input.value) || new Date();
        var view = new Date(selected.getFullYear(), selected.getMonth(), 1);
        var cal = document.createElement('div');
        cal.className = 'vn-cal';
        document.body.appendChild(cal);
        openCal = cal;

        function render() {
            var y = view.getFullYear();
            var m = view.getMonth();
            var html = '<div class="vn-cal-head"><button type="button" data-nav="-1">&lt;</button><strong>' +
                MONTHS[m] + ' ' + y + '</strong><button type="button" data-nav="1">&gt;</button></div><div class="vn-cal-grid">';
            DAYS.forEach(function (d) { html += '<div class="dow">' + d + '</div>'; });
            var first = new Date(y, m, 1);
            var start = first.getDay();
            var daysInMonth = new Date(y, m + 1, 0).getDate();
            var prevDays = new Date(y, m, 0).getDate();
            var today = new Date();
            var cells = [];
            var i;
            for (i = 0; i < start; i++) cells.push({ d: prevDays - start + 1 + i, muted: true, date: new Date(y, m - 1, prevDays - start + 1 + i) });
            for (i = 1; i <= daysInMonth; i++) cells.push({ d: i, muted: false, date: new Date(y, m, i) });
            while (cells.length % 7 !== 0) {
                var next = cells.length - (start + daysInMonth) + 1;
                cells.push({ d: next, muted: true, date: new Date(y, m + 1, next) });
            }
            cells.forEach(function (cell) {
                var cls = cell.muted ? 'muted' : '';
                if (cell.date.getFullYear() === today.getFullYear() && cell.date.getMonth() === today.getMonth() && cell.date.getDate() === today.getDate()) cls += ' today';
                if (cell.date.getFullYear() === selected.getFullYear() && cell.date.getMonth() === selected.getMonth() && cell.date.getDate() === selected.getDate() && vnToIso(input.value)) cls += ' selected';
                html += '<button type="button" class="' + cls.trim() + '" data-y="' + cell.date.getFullYear() + '" data-m="' + cell.date.getMonth() + '" data-d="' + cell.date.getDate() + '">' + cell.d + '</button>';
            });
            html += '</div>';
            cal.innerHTML = html;
            var rect = btn.getBoundingClientRect();
            var top = rect.bottom + 8;
            var left = rect.right - 280;
            if (left < 8) left = 8;
            if (top + 320 > window.innerHeight) top = Math.max(8, rect.top - 320);
            cal.style.top = top + 'px';
            cal.style.left = left + 'px';
        }

        cal.addEventListener('click', function (e) {
            e.stopPropagation();
            var nav = e.target.getAttribute('data-nav');
            if (nav) {
                view.setMonth(view.getMonth() + Number(nav));
                render();
                return;
            }
            var dayBtn = e.target.closest('button[data-d]');
            if (!dayBtn) return;
            var picked = new Date(Number(dayBtn.getAttribute('data-y')), Number(dayBtn.getAttribute('data-m')), Number(dayBtn.getAttribute('data-d')));
            input.value = pad(picked.getDate()) + '/' + pad(picked.getMonth() + 1) + '/' + picked.getFullYear();
            closeCalendar();
            if (input.dataset.autosubmit === 'true') submitIsoForm(input.form);
        });
        render();
    }

    document.addEventListener('click', closeCalendar);
    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape') closeCalendar();
    });
    document.addEventListener('DOMContentLoaded', function () {
        document.querySelectorAll('input.vn-date').forEach(function (input) {
            if (input.dataset.vnReady === '1') return;
            input.dataset.vnReady = '1';
            input.setAttribute('placeholder', 'dd/mm/yyyy');
            input.setAttribute('maxlength', '10');
            input.setAttribute('inputmode', 'numeric');
            if (input.value) input.value = isoToVn(input.value);

            var wrap = document.createElement('div');
            wrap.className = 'vn-date-wrap';
            input.parentNode.insertBefore(wrap, input);
            wrap.appendChild(input);

            var btn = document.createElement('button');
            btn.type = 'button';
            btn.className = 'vn-date-btn';
            btn.setAttribute('aria-label', 'Chọn ngày');
            btn.innerHTML = '<i class="fa-solid fa-calendar-days"></i>';
            wrap.appendChild(btn);

            btn.addEventListener('click', function (e) {
                e.preventDefault();
                e.stopPropagation();
                if (openCal) closeCalendar();
                else openCalendar(input, btn);
            });
            input.addEventListener('input', function () {
                input.value = formatTyping(input.value);
            });
            input.addEventListener('blur', function () {
                if (input.dataset.autosubmit === 'true' && vnToIso(input.value)) {
                    setTimeout(function () {
                        if (!openCal) submitIsoForm(input.form);
                    }, 200);
                }
            });
        });
    });
})();
</script>
