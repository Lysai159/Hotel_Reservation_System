<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sửa tiện ích - LuxStay</title>
</head>
<body>
<%@ include file="/WEB-INF/views/shared/admin-header.jsp" %>

<div class="page-wrap form-wide">
    <div class="card-box">
        <h2>Cập nhật tiện ích</h2>
        <form action="${pageContext.request.contextPath}/admin/amenity/save" method="post">
            <input type="hidden" name="amenityId" value="${amenity.amenityId}">
            <div class="form-group">
                <label>Tên tiện ích</label>
                <input type="text" name="amenityName" value="${amenity.amenityName}" required>
            </div>
            <div class="form-group">
                <label>Mô tả</label>
                <textarea name="description" rows="4">${amenity.description}</textarea>
            </div>
            <button type="submit" class="btn-accent" style="width: 100%;">Lưu tiện ích</button>
        </form>
        <p style="margin-top: 12px;">
            <a href="${pageContext.request.contextPath}/admin/amenity/list" style="color: #ff385c;">← Danh sách tiện ích</a>
        </p>
    </div>
</div>

<%@ include file="/WEB-INF/views/shared/footer.jsp" %>
</body>
</html>
