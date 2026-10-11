<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Ký - LuxStay</title>
</head>
<body>
<%@ include file="/WEB-INF/views/shared/header.jsp" %>

<main class="auth-page">
    <div class="auth-card">
        <h2>Đăng ký</h2>
        <c:if test="${not empty error}">
            <div class="error">${error}</div>
        </c:if>
        <form action="${pageContext.request.contextPath}/customer/register" method="post">
            <div class="form-group">
                <label>Họ và tên</label>
                <input type="text" name="fullName" required>
            </div>
            <div class="form-group">
                <label>Email</label>
                <input type="email" name="email" required>
            </div>
            <div class="form-group">
                <label>Mật khẩu</label>
                <input type="password" name="passwordHash" required>
            </div>
            <div class="form-group">
                <label>Số điện thoại</label>
                <input type="text" name="phoneNumber" required>
            </div>
            <div class="form-group">
                <label>Địa chỉ</label>
                <input type="text" name="address">
            </div>
            <button type="submit" class="btn-accent">Tạo tài khoản</button>
        </form>
        <p class="auth-switch">
            <a href="${pageContext.request.contextPath}/customer/login" style="color: #ff385c;">Đã có tài khoản? Đăng nhập</a>
        </p>
    </div>
</main>

<%@ include file="/WEB-INF/views/shared/footer.jsp" %>
</body>
</html>
