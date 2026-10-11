<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch Sử Đặt Phòng - LuxStay</title>
</head>
<body>
<%@ include file="/WEB-INF/views/shared/header.jsp" %>

<main class="content-page"${empty bookings ? ' style="align-items:center; min-height:calc(100vh - 140px);"' : ''}>
    <div class="content-shell">
        <h2 class="page-title">Lịch sử đặt phòng</h2>
        <c:if test="${not empty success}">
            <p class="success">${success}</p>
        </c:if>
        <c:if test="${not empty error}">
            <p class="error">${error}</p>
        </c:if>

        <c:choose>
            <c:when test="${empty bookings}">
                <div class="empty-state">
                    <i class="fa-solid fa-calendar-check"></i>
                    <h3 style="margin-bottom: 8px;">Bạn chưa có đơn đặt phòng</h3>
                    <p>Chọn phòng và thêm vào giỏ để bắt đầu kỳ nghỉ.</p>
                    <a href="${pageContext.request.contextPath}/room/list" class="btn-accent">Đặt phòng ngay</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="panel-card">
                    <table class="data">
                        <thead>
                            <tr>
                                <th>Mã đơn</th>
                                <th>Nhận phòng</th>
                                <th>Trả phòng</th>
                                <th>Tổng tiền</th>
                                <th>Trạng thái</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="b" items="${bookings}">
                                <tr onclick="location.href='${pageContext.request.contextPath}/booking/detail/${b.bookingId}'">
                                    <td><strong>#${b.bookingId}</strong></td>
                                    <td>${b.checkInDate.dayOfMonth}/${b.checkInDate.monthValue}/${b.checkInDate.year}</td>
                                    <td>${b.checkOutDate.dayOfMonth}/${b.checkOutDate.monthValue}/${b.checkOutDate.year}</td>
                                    <td style="color:#ff385c; font-weight:700; white-space:nowrap;">
                                        <fmt:formatNumber value="${b.totalPrice}" type="number"/> ₫
                                    </td>
                                    <td>
                                        <span class="status-pill status-${b.status}">
                                            <c:choose>
                                                <c:when test="${b.status == 'PENDING' || b.status == 'Pending'}">Chờ thanh toán</c:when>
                                                <c:when test="${b.status == 'CONFIRMED' || b.status == 'Confirmed'}">Đã xác nhận</c:when>
                                                <c:when test="${b.status == 'CHECKED_IN'}">Đang ở</c:when>
                                                <c:when test="${b.status == 'CHECKED_OUT' || b.status == 'Completed'}">Đã trả phòng</c:when>
                                                <c:when test="${b.status == 'CANCELLED' || b.status == 'Cancelled'}">Đã hủy</c:when>
                                                <c:otherwise>${b.status}</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<%@ include file="/WEB-INF/views/shared/footer.jsp" %>
</body>
</html>
