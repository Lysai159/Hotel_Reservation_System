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
        margin-left: 240px;
        min-height: 100vh;
        display: flex;
        flex-direction: column;
    }
    a { text-decoration: none; color: inherit; }

    .site-sidebar {
        position: fixed; top: 0; left: 0; bottom: 0; width: 240px;
        background: #fff; border-right: 1px solid #eee; z-index: 1100;
        display: flex; flex-direction: column; overflow-y: auto;
    }
    .sidebar-logo {
        display: block; padding: 20px 18px; font-size: 22px; font-weight: bold;
        color: #ff385c; border-bottom: 1px solid #f1f1f1;
    }
    .sidebar-nav { list-style: none; padding: 12px 10px; margin: 0; }
    .sidebar-nav .nav-label {
        display: block; font-size: 11px; letter-spacing: 0.6px; text-transform: uppercase;
        color: #999; padding: 12px 12px 6px;
    }
    .sidebar-nav a {
        display: flex; align-items: center; gap: 10px;
        padding: 10px 12px; border-radius: 8px; color: #333; font-weight: 500;
    }
    .sidebar-nav a i { width: 18px; text-align: center; color: #ff385c; }
    .sidebar-nav a:hover { background: #fff1f3; color: #ff385c; }

    .site-header { background: #fff; box-shadow: 0 2px 10px rgba(0,0,0,0.08); position: sticky; top: 0; z-index: 1000; }
    .site-header-inner { padding: 12px 20px; display: flex; align-items: center; justify-content: flex-end; }
    .header-actions { display: flex; align-items: center; gap: 10px; white-space: nowrap; }

    .btn-accent { background: #ff385c; color: #fff !important; padding: 8px 14px; border-radius: 8px; font-weight: 600; border: none; cursor: pointer; display: inline-block; }
    .btn-accent:hover { background: #e03150; }
    .btn-outline { border: 1px solid #ddd; padding: 8px 14px; border-radius: 8px; font-weight: 500; }
    .btn-sm {
        padding: 6px 14px; font-size: 13px; border-radius: 8px; font-weight: 600;
        display: inline-block; cursor: pointer; border: 1px solid transparent; line-height: 1.4;
    }
    .btn-edit { background: #fff; border-color: #ff385c; color: #ff385c; }
    .btn-edit:hover { background: #fff1f3; }
    .btn-delete { background: #fff; border-color: #dc3545; color: #dc3545 !important; }
    .btn-delete:hover { background: #fff5f5; }
    .action-btns { display: flex; gap: 8px; align-items: center; flex-wrap: wrap; }
    .page-wrap { width: 100%; max-width: none; margin: 24px 0 0; padding: 0 36px 48px; box-sizing: border-box; }
    .page-wrap.form-wide { max-width: 920px; margin: 28px auto 40px; padding: 0 24px; }
    .page-title { margin-bottom: 22px; font-size: 1.6rem; }
    .card-box { background: #fff; padding: 32px 40px; border-radius: 16px; box-shadow: 0 2px 10px rgba(0,0,0,0.06); }
    table.data { width: 100%; border-collapse: collapse; background: #fff; border-radius: 16px; overflow: hidden; box-shadow: 0 2px 10px rgba(0,0,0,0.06); margin-top: 18px; }
    table.data th, table.data td { padding: 16px 18px; border-bottom: 1px solid #eee; text-align: left; font-size: 15px; }
    table.data th { background: #222; color: #fff; }
    .form-group { margin-bottom: 15px; }
    .form-group label { display: block; margin-bottom: 6px; font-weight: 600; font-size: 14px; }
    .form-group input, .form-group select, .form-group textarea { width: 100%; padding: 10px; border: 1px solid #ced4da; border-radius: 8px; font-size: 15px; }
    .error { color: #dc3545; margin-bottom: 12px; }
    .success { color: #155724; background: #d4edda; padding: 10px 12px; border-radius: 8px; margin-bottom: 12px; }
    footer, .site-footer { margin-top: auto; width: 100%; flex-shrink: 0; }
</style>

<aside class="site-sidebar">
    <c:choose>
        <c:when test="${sessionScope.currentUser.roleId == 2}">
            <a href="${pageContext.request.contextPath}/booking/admin/list" class="sidebar-logo">
                <i class="fa-solid fa-hotel"></i> LuxStay Lễ tân
            </a>
        </c:when>
        <c:otherwise>
            <a href="${pageContext.request.contextPath}/admin/room/list" class="sidebar-logo">
                <i class="fa-solid fa-hotel"></i> LuxStay Admin
            </a>
        </c:otherwise>
    </c:choose>
    <ul class="sidebar-nav">
        <li class="nav-label">Quản trị</li>
        <c:if test="${sessionScope.currentUser.roleId == 1}">
            <li><a href="${pageContext.request.contextPath}/admin/room/list"><i class="fa-solid fa-door-open"></i> Quản lý phòng</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/room-type/list"><i class="fa-solid fa-layer-group"></i> Loại phòng</a></li>
        </c:if>
        <li><a href="${pageContext.request.contextPath}/booking/admin/list"><i class="fa-solid fa-clipboard-list"></i> Đơn đặt phòng</a></li>
        <c:if test="${sessionScope.currentUser.roleId == 1}">
            <li><a href="${pageContext.request.contextPath}/admin/amenity/list"><i class="fa-solid fa-spa"></i> Tiện ích</a></li>
        </c:if>
        <li class="nav-label">Khác</li>
        <li><a href="${pageContext.request.contextPath}/"><i class="fa-solid fa-globe"></i> Trang khách</a></li>
    </ul>
</aside>

<header class="site-header">
    <div class="site-header-inner">
        <div class="header-actions">
            <c:if test="${not empty sessionScope.currentUser}">
                <a href="${pageContext.request.contextPath}/customer/profile">
                    <i class="fa-solid fa-user"></i> ${sessionScope.currentUser.fullName}
                </a>
            </c:if>
            <a href="${pageContext.request.contextPath}/customer/logout" class="btn-outline">Đăng xuất</a>
        </div>
    </div>
</header>
