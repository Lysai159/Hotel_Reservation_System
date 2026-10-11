<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh Toán - LuxStay</title>
</head>
<body>
<%@ include file="/WEB-INF/views/shared/header.jsp" %>

<div class="page-wrap" style="max-width: 420px;">
    <div class="card-box">
        <h2>Thanh toán đơn #${bookingId}</h2>
        <c:if test="${not empty error}">
            <p class="error">${error}</p>
        </c:if>
        <form action="${pageContext.request.contextPath}/payment/process" method="post">
            <input type="hidden" name="booking.bookingId" value="${bookingId}">
            <div class="form-group">
                <label>Số tiền (VNĐ)</label>
                <input type="number" name="amount" value="${booking.totalPrice}" readonly>
            </div>
            <div class="form-group">
                <label>Phương thức thanh toán</label>
                <select name="paymentMethod">
                    <option value="Credit Card">Thẻ tín dụng</option>
                    <option value="Cash">Tiền mặt</option>
                    <option value="Banking">Chuyển khoản</option>
                </select>
            </div>
            <button type="submit" class="btn-accent" style="width: 100%;">Xác nhận thanh toán</button>
        </form>
        <p style="margin-top: 12px;">
            <a href="${pageContext.request.contextPath}/booking/history" style="color: #ff385c;">← Lịch sử đặt phòng</a>
        </p>
    </div>
</div>

<%@ include file="/WEB-INF/views/shared/footer.jsp" %>
</body>
</html>
