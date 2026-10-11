<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giỏ hàng - LuxStay</title>
</head>
<body>
<%@ include file="/WEB-INF/views/shared/header.jsp" %>

<main class="content-page"${empty cart.items ? ' style="align-items:center; min-height:calc(100vh - 140px);"' : ''}>
    <div class="content-shell">
        <h2 class="page-title">Giỏ hàng</h2>
        <c:if test="${not empty success}">
            <p class="success">${success}</p>
        </c:if>
        <c:if test="${not empty error}">
            <p class="error">${error}</p>
        </c:if>

        <c:choose>
            <c:when test="${empty cart.items}">
                <div class="empty-state">
                    <i class="fa-solid fa-bag-shopping"></i>
                    <h3 style="margin-bottom: 8px;">Giỏ hàng đang trống</h3>
                    <p>Chưa có phòng nào. Hãy chọn phòng phù hợp cho kỳ nghỉ của bạn.</p>
                    <a href="${pageContext.request.contextPath}/room/list" class="btn-accent">Chọn phòng</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="cart-layout">
                    <div>
                        <c:forEach var="item" items="${cart.items}">
                            <div class="cart-item">
                                <c:choose>
                                    <c:when test="${not empty item.imageUrl}">
                                        <img src="${pageContext.request.contextPath}${item.imageUrl}" alt="Phòng ${item.roomNumber}">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}/assets/images/default-room.svg" alt="Phòng ${item.roomNumber}">
                                    </c:otherwise>
                                </c:choose>
                                <div style="flex:1;">
                                    <h3>Phòng ${item.roomNumber}<c:if test="${not empty item.typeName}"> - ${item.typeName}</c:if></h3>
                                    <p style="color:#666; font-size:14px; margin-top:6px;">
                                        <i class="fa-solid fa-calendar-days"></i>
                                        ${item.checkInDate.dayOfMonth}/${item.checkInDate.monthValue}/${item.checkInDate.year}
                                        → ${item.checkOutDate.dayOfMonth}/${item.checkOutDate.monthValue}/${item.checkOutDate.year}
                                        · ${item.nights} đêm
                                    </p>
                                    <p style="color:#ff385c; font-weight:700; margin-top:8px; font-size:18px;">
                                        <fmt:formatNumber value="${item.totalAmount}" type="number"/> ₫
                                    </p>
                                </div>
                                <form action="${pageContext.request.contextPath}/cart/remove" method="post">
                                    <input type="hidden" name="itemId" value="${item.itemId}">
                                    <button type="submit" class="btn-outline">Xóa</button>
                                </form>
                            </div>
                        </c:forEach>
                    </div>
                    <aside class="cart-summary">
                        <h3 style="margin-bottom: 14px;">Tóm tắt</h3>
                        <div style="display:flex; justify-content:space-between; color:#666; margin-bottom:8px;">
                            <span>Số phòng</span>
                            <span>${cart.itemCount}</span>
                        </div>
                        <div style="display:flex; justify-content:space-between; align-items:baseline; padding-top:12px; border-top:1px solid #eee;">
                            <span>Tổng cộng</span>
                            <strong style="color:#ff385c; font-size:22px;">
                                <fmt:formatNumber value="${cart.grandTotal}" type="number"/> ₫
                            </strong>
                        </div>
                        <a href="${pageContext.request.contextPath}/cart/checkout" class="btn-accent">Thanh toán</a>
                        <a href="${pageContext.request.contextPath}/room/list" class="btn-outline">Thêm phòng</a>
                    </aside>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<%@ include file="/WEB-INF/views/shared/footer.jsp" %>
</body>
</html>
