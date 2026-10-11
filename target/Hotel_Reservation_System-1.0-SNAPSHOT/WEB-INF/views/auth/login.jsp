<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Nhập - LuxStay</title>
</head>
<body>
<%@ include file="/WEB-INF/views/shared/header.jsp" %>

<main class="auth-page">
    <div class="auth-card">
        <h2>Đăng nhập</h2>
        <c:if test="${not empty loginMessage}">
            <p style="background:#fff4e5; color:#8a5a00; padding:10px 12px; border-radius:8px; margin-bottom:12px;">${loginMessage}</p>
        </c:if>
        <c:if test="${not empty error}">
            <div class="error">${error}</div>
        </c:if>
        <form action="${pageContext.request.contextPath}/customer/login" method="post">
            <div class="form-group">
                <label>Email</label>
                <input type="email" name="email" required>
            </div>
            <div class="form-group">
                <label>Mật khẩu</label>
                <input type="password" name="password" required>
            </div>
            <button type="submit" class="btn-accent">Đăng nhập</button>
        </form>
        <p class="auth-switch">
            <a href="${pageContext.request.contextPath}/customer/register" style="color: #ff385c;">Chưa có tài khoản? Đăng ký ngay</a>
        </p>
    </div>
</main>

<%@ include file="/WEB-INF/views/shared/footer.jsp" %>
</body>
</html>
