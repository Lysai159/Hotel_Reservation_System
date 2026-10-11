<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ Sơ Cá Nhân - LuxStay</title>
</head>
<body>
<c:choose>
    <c:when test="${staffView}">
        <jsp:include page="/WEB-INF/views/shared/admin-header.jsp" />
        <div class="page-wrap form-wide">
    </c:when>
    <c:otherwise>
        <jsp:include page="/WEB-INF/views/shared/header.jsp" />
        <main class="content-page">
            <div class="content-shell" style="max-width: 640px;">
    </c:otherwise>
</c:choose>

                <h2 class="page-title" style="text-align:${staffView ? 'left' : 'center'};">Hồ sơ cá nhân</h2>
                <c:if test="${not empty success}">
                    <p class="success">${success}</p>
                </c:if>

                <div class="${staffView ? 'card-box' : 'auth-card'}" style="max-width: 640px; ${staffView ? 'margin-bottom: 20px;' : 'margin: 0 auto 20px; padding: 28px 30px;'}">
                    <h3 style="margin-bottom: 18px;">Thông tin cá nhân</h3>
                    <c:if test="${not empty infoError}">
                        <p class="error">${infoError}</p>
                    </c:if>
                    <form action="${pageContext.request.contextPath}/customer/profile" method="post">
                        <div class="form-group">
                            <label>Họ và tên</label>
                            <input type="text" name="fullName" value="${profile.fullName}" required>
                        </div>
                        <div class="form-group">
                            <label>Email</label>
                            <input type="email" name="email" value="${profile.email}" required>
                        </div>
                        <div class="form-group">
                            <label>Số điện thoại</label>
                            <input type="text" name="phoneNumber" value="${profile.phoneNumber}" required>
                        </div>
                        <div class="form-group">
                            <label>Địa chỉ</label>
                            <input type="text" name="address" value="${profile.address}">
                        </div>
                        <button type="submit" class="btn-accent" style="width: 100%; padding: 12px 18px;">Lưu thông tin</button>
                    </form>
                </div>

                <div class="${staffView ? 'card-box' : 'auth-card'}" style="max-width: 640px; ${staffView ? '' : 'margin: 0 auto; padding: 28px 30px;'}">
                    <h3 style="margin-bottom: 18px;">Đổi mật khẩu</h3>
                    <c:if test="${not empty passwordError}">
                        <p class="error">${passwordError}</p>
                    </c:if>
                    <form action="${pageContext.request.contextPath}/customer/profile/password" method="post">
                        <div class="form-group">
                            <label>Mật khẩu hiện tại</label>
                            <input type="password" name="currentPassword" required autocomplete="current-password">
                        </div>
                        <div class="form-group">
                            <label>Mật khẩu mới</label>
                            <input type="password" name="newPassword" required minlength="6" autocomplete="new-password">
                        </div>
                        <div class="form-group">
                            <label>Xác nhận mật khẩu mới</label>
                            <input type="password" name="confirmPassword" required minlength="6" autocomplete="new-password">
                        </div>
                        <button type="submit" class="btn-accent" style="width: 100%; padding: 12px 18px;">Đổi mật khẩu</button>
                    </form>
                </div>

<c:choose>
    <c:when test="${staffView}">
        </div>
    </c:when>
    <c:otherwise>
            </div>
        </main>
    </c:otherwise>
</c:choose>

<%@ include file="/WEB-INF/views/shared/footer.jsp" %>
</body>
</html>
