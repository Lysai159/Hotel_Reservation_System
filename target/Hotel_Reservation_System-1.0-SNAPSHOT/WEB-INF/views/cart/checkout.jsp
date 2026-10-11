<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán - LuxStay</title>
</head>
<body>
<%@ include file="/WEB-INF/views/shared/header.jsp" %>

<main class="content-page">
    <div class="content-shell" style="max-width: 640px;">
        <h2 class="page-title">Thanh toán giỏ hàng</h2>
        <div class="auth-card" style="max-width: 640px; padding: 28px 30px;">
            <c:if test="${not empty error}">
                <p class="error">${error}</p>
            </c:if>

            <c:forEach var="item" items="${cart.items}">
                <div style="display:flex; justify-content:space-between; gap:12px; padding:14px 0; border-bottom:1px solid #eee;">
                    <div>
                        <strong>Phòng ${item.roomNumber}</strong>
                        <c:if test="${not empty item.typeName}"> - ${item.typeName}</c:if>
                        <div style="font-size:13px; color:#666; margin-top:4px;">
                            ${item.checkInDate.dayOfMonth}/${item.checkInDate.monthValue}/${item.checkInDate.year}
                            → ${item.checkOutDate.dayOfMonth}/${item.checkOutDate.monthValue}/${item.checkOutDate.year}
                            · ${item.nights} đêm
                        </div>
                    </div>
                    <div style="font-weight:700; color:#ff385c; white-space:nowrap;">
                        <fmt:formatNumber value="${item.totalAmount}" type="number"/> ₫
                    </div>
                </div>
            </c:forEach>

            <p style="margin: 18px 0; font-size: 20px; font-weight: 700; display:flex; justify-content:space-between;">
                <span>Tổng thanh toán</span>
                <span style="color:#ff385c;"><fmt:formatNumber value="${cart.grandTotal}" type="number"/> ₫</span>
            </p>

            <form action="${pageContext.request.contextPath}/cart/checkout" method="post">
                <div class="form-group">
                    <label>Phương thức thanh toán</label>
                    <select name="paymentMethod" required>
                        <option value="Credit Card">Thẻ tín dụng</option>
                        <option value="Banking">Chuyển khoản</option>
                        <option value="Cash">Tiền mặt khi nhận phòng</option>
                    </select>
                </div>
                <button type="submit" class="btn-accent">Xác nhận thanh toán</button>
            </form>
            <p class="auth-switch">
                <a href="${pageContext.request.contextPath}/cart" style="color:#ff385c;">← Quay lại giỏ hàng</a>
            </p>
        </div>
    </div>
</main>

<%@ include file="/WEB-INF/views/shared/footer.jsp" %>
</body>
</html>
