<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kết Quả Thanh Toán - LuxStay</title>
</head>
<body>
<%@ include file="/WEB-INF/views/shared/header.jsp" %>

<div class="page-wrap" style="text-align: center;">
    <div class="card-box" style="display: inline-block; min-width: 360px;">
        <c:choose>
            <c:when test="${status == 'Success'}">
                <h2 style="color: #155724;">Thanh toán thành công</h2>
                <p>Cảm ơn bạn đã sử dụng dịch vụ. Mã giao dịch đã được ghi nhận.</p>
            </c:when>
            <c:otherwise>
                <h2 style="color: #721c24;">Thanh toán thất bại</h2>
                <p>Đã xảy ra lỗi trong quá trình xử lý. Vui lòng thử lại sau.</p>
            </c:otherwise>
        </c:choose>
        <a href="${pageContext.request.contextPath}/booking/history" class="btn-accent" style="margin-top: 16px;">Quay lại lịch sử đặt phòng</a>
    </div>
</div>

<%@ include file="/WEB-INF/views/shared/footer.jsp" %>
</body>
</html>
