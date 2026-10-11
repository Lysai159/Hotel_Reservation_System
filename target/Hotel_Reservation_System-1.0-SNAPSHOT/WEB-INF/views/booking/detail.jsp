<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi Tiết Đơn #${booking.bookingId} - LuxStay</title>
</head>
<body>
<c:choose>
    <c:when test="${staffView}">
        <jsp:include page="/WEB-INF/views/shared/admin-header.jsp" />
        <div class="page-wrap form-wide">
            <div class="card-box">
    </c:when>
    <c:otherwise>
        <jsp:include page="/WEB-INF/views/shared/header.jsp" />
        <main class="content-page">
            <div class="content-shell" style="max-width: 680px;">
                <div class="auth-card" style="max-width: 680px; padding: 28px 30px;">
    </c:otherwise>
</c:choose>

                <div style="display:flex; justify-content:space-between; align-items:center; gap:12px; margin-bottom:18px;">
                    <h2 style="margin:0;">
                        <c:choose>
                            <c:when test="${staffView}">Chi tiết đơn #${booking.bookingId}</c:when>
                            <c:otherwise>Đơn đặt phòng</c:otherwise>
                        </c:choose>
                    </h2>
                    <c:if test="${!staffView}">
                    <span class="status-pill status-${booking.status}">
                        <c:choose>
                            <c:when test="${booking.status == 'PENDING' || booking.status == 'Pending'}">Chờ thanh toán</c:when>
                            <c:when test="${booking.status == 'CONFIRMED' || booking.status == 'Confirmed'}">Đã xác nhận</c:when>
                            <c:when test="${booking.status == 'CHECKED_IN'}">Đang ở</c:when>
                            <c:when test="${booking.status == 'CHECKED_OUT' || booking.status == 'Completed'}">Đã trả phòng</c:when>
                            <c:when test="${booking.status == 'CANCELLED' || booking.status == 'Cancelled'}">Đã hủy</c:when>
                            <c:otherwise>${booking.status}</c:otherwise>
                        </c:choose>
                    </span>
                    </c:if>
                    <c:if test="${staffView}"><span class="btn-outline" style="cursor:default;">${booking.status}</span></c:if>
                </div>

                <p><b>Khách hàng:</b> ${booking.customer.fullName}</p>
                <p><b>Email:</b> ${booking.customer.email}</p>
                <p><b>Số điện thoại:</b> ${booking.customer.phoneNumber}</p>
                <p>
                    <b>Phòng:</b> ${booking.room.roomNumber}
                    <c:if test="${not empty booking.room.roomType}"> - ${booking.room.roomType.typeName}</c:if>
                </p>
                <p><b>Ngày nhận phòng:</b> ${booking.checkInDate.dayOfMonth}/${booking.checkInDate.monthValue}/${booking.checkInDate.year}</p>
                <p><b>Ngày trả phòng:</b> ${booking.checkOutDate.dayOfMonth}/${booking.checkOutDate.monthValue}/${booking.checkOutDate.year}</p>
                <p>
                    <b>Tổng tiền:</b>
                    <span style="color:#ff385c; font-weight:700;">
                        <fmt:formatNumber value="${booking.totalPrice}" type="number"/> ₫
                    </span>
                </p>

                <c:if test="${staffView}">
                    <div class="action-btns" style="margin-top:18px;">
                        <c:if test="${booking.status == 'PENDING' || booking.status == 'Pending'}">
                            <form action="${pageContext.request.contextPath}/booking/admin/confirm/${booking.bookingId}" method="post">
                                <button type="submit" class="btn-sm btn-edit">Xác nhận</button>
                            </form>
                            <form action="${pageContext.request.contextPath}/booking/cancel/${booking.bookingId}" method="post">
                                <button type="submit" class="btn-sm btn-delete" onclick="return confirm('Hủy đơn này?')">Hủy</button>
                            </form>
                        </c:if>
                        <c:if test="${booking.status == 'CONFIRMED'}">
                            <form action="${pageContext.request.contextPath}/booking/admin/check-in/${booking.bookingId}" method="post">
                                <button type="submit" class="btn-sm btn-edit">Check-in</button>
                            </form>
                        </c:if>
                        <c:if test="${booking.status == 'CHECKED_IN'}">
                            <form action="${pageContext.request.contextPath}/booking/admin/check-out/${booking.bookingId}" method="post">
                                <button type="submit" class="btn-sm btn-accent">Check-out</button>
                            </form>
                        </c:if>
                    </div>
                    <p style="margin-top:16px;">
                        <a href="${pageContext.request.contextPath}/booking/admin/list" style="color:#ff385c;">← Danh sách đơn đặt phòng</a>
                    </p>
                </c:if>

                <c:if test="${!staffView && (booking.status == 'PENDING' || booking.status == 'Pending')}">
                    <div style="display:flex; gap:10px; margin-top:18px;">
                        <a href="${pageContext.request.contextPath}/payment/checkout/${booking.bookingId}" class="btn-accent">Thanh toán</a>
                        <form action="${pageContext.request.contextPath}/booking/cancel/${booking.bookingId}" method="post">
                            <button type="submit" class="btn-outline" onclick="return confirm('Bạn có muốn hủy đơn?')">Hủy đơn</button>
                        </form>
                    </div>
                </c:if>

                <c:if test="${!staffView}">
                    <p class="auth-switch">
                        <a href="${pageContext.request.contextPath}/booking/history" style="color: #ff385c;">← Lịch sử đặt phòng</a>
                    </p>
                </c:if>

<c:choose>
    <c:when test="${staffView}">
            </div>
        </div>
    </c:when>
    <c:otherwise>
                </div>
            </div>
        </main>
    </c:otherwise>
</c:choose>

<%@ include file="/WEB-INF/views/shared/footer.jsp" %>
</body>
</html>
