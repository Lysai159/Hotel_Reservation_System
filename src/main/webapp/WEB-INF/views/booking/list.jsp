<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Đặt Phòng - LuxStay</title>
    <style>
        table.data tbody tr { cursor: pointer; }
        table.data tbody tr:hover { background: #fff7f8; }
    </style>
</head>
<body>
<%@ include file="/WEB-INF/views/shared/admin-header.jsp" %>

<div class="page-wrap">
    <h2>Tất cả đơn đặt phòng</h2>
    <table class="data">
        <thead>
            <tr>
                <th>Mã đơn</th>
                <th>Phòng</th>
                <th>Check-in</th>
                <th>Check-out</th>
                <th>Số đêm</th>
                <th>Tổng tiền</th>
                <th>Trạng thái</th>
                <th>Thao tác</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="b" items="${bookings}">
                <tr onclick="if (!event.target.closest('.action-btns')) location.href='${pageContext.request.contextPath}/booking/detail/${b.bookingId}'">
                    <td>#${b.bookingId}</td>
                    <td>Phòng ${b.room.roomNumber}</td>
                    <td>${b.checkInDate}</td>
                    <td>${b.checkOutDate}</td>
                    <td>${b.totalNights}</td>
                    <td>${b.totalPrice} VNĐ</td>
                    <td><b>${b.status}</b></td>
                    <td>
                        <div class="action-btns">
                        <c:if test="${b.status == 'PENDING' || b.status == 'Pending'}">
                            <form action="${pageContext.request.contextPath}/booking/admin/confirm/${b.bookingId}" method="post">
                                <button type="submit" class="btn-sm btn-edit">Xác nhận</button>
                            </form>
                            <form action="${pageContext.request.contextPath}/booking/cancel/${b.bookingId}" method="post">
                                <button type="submit" class="btn-sm btn-delete">Hủy</button>
                            </form>
                        </c:if>
                        <c:if test="${b.status == 'CONFIRMED'}">
                            <form action="${pageContext.request.contextPath}/booking/admin/check-in/${b.bookingId}" method="post">
                                <button type="submit" class="btn-sm btn-edit">Check-in</button>
                            </form>
                        </c:if>
                        <c:if test="${b.status == 'CHECKED_IN'}">
                            <form action="${pageContext.request.contextPath}/booking/admin/check-out/${b.bookingId}" method="post">
                                <button type="submit" class="btn-sm btn-accent">Check-out</button>
                            </form>
                        </c:if>
                        </div>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

<%@ include file="/WEB-INF/views/shared/footer.jsp" %>
</body>
</html>
