<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt Phòng - LuxStay</title>
</head>
<body>
<%@ include file="/WEB-INF/views/shared/header.jsp" %>

<div class="page-wrap" style="max-width: 800px;">
    <div class="card-box">
        <div style="display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #eee; padding-bottom: 16px; margin-bottom: 20px;">
            <div>
                <span style="font-size: 12px; color: #888; text-transform: uppercase;">Thông tin phòng chọn</span>
                <h2>Phòng ${room.roomNumber}<c:if test="${not empty room.roomType}"> - ${room.roomType.typeName}</c:if></h2>
            </div>
            <div style="font-size: 22px; font-weight: bold; color: #ff385c;">
                <c:if test="${not empty room.roomType}">
                    <fmt:formatNumber value="${room.roomType.basePrice}" type="number" /> ₫
                    <small style="font-size: 13px; color: #666; font-weight: normal;">/đêm</small>
                </c:if>
            </div>
        </div>

        <c:if test="${not empty error}">
            <p class="error">${error}</p>
        </c:if>

        <form action="${pageContext.request.contextPath}/booking/create" method="post">
            <input type="hidden" name="room.roomId" value="${room.roomId}">
            <div class="form-group">
                <label>Ngày nhận phòng</label>
                <input type="text" class="vn-date" name="checkInDate" value="${checkInDate}" required autocomplete="off">
            </div>
            <div class="form-group">
                <label>Ngày trả phòng</label>
                <input type="text" class="vn-date" name="checkOutDate" value="${checkOutDate}" required autocomplete="off">
            </div>
            <p style="font-size: 13px; color: #666; margin-bottom: 12px;">
                Tổng tiền = số đêm × giá loại phòng. Hệ thống sẽ tự tính khi đặt.
            </p>
            <button type="submit" class="btn-accent" style="width: 100%;">
                <i class="fa-solid fa-paper-plane"></i> Xác nhận đặt phòng
            </button>
        </form>
        <p style="margin-top: 12px;"><a href="${pageContext.request.contextPath}/room/detail/${room.roomId}" style="color: #ff385c;">← Quay lại chi tiết phòng</a></p>
    </div>
</div>

<%@ include file="/WEB-INF/views/shared/footer.jsp" %>
</body>
</html>
