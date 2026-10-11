<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm/Sửa Loại Phòng - LuxStay</title>
</head>
<body>
<%@ include file="/WEB-INF/views/shared/admin-header.jsp" %>

<div class="page-wrap form-wide">
    <div class="card-box">
        <h2>${empty roomType.typeId ? 'Thêm loại phòng' : 'Cập nhật loại phòng'}</h2>
        <form action="${pageContext.request.contextPath}/admin/room-type/save" method="post">
            <input type="hidden" name="typeId" value="${roomType.typeId}">
            <div class="form-group">
                <label>Tên loại phòng</label>
                <input type="text" name="typeName" value="${roomType.typeName}" required>
            </div>
            <div class="form-group">
                <label>Giá cơ bản (VNĐ)</label>
                <input type="number" name="basePrice" value="${roomType.basePrice}" required>
            </div>
            <div class="form-group">
                <label>Sức chứa (người)</label>
                <input type="number" name="capacity" value="${roomType.capacity}" required>
            </div>
            <div class="form-group">
                <label>Mô tả</label>
                <textarea name="description" rows="4">${roomType.description}</textarea>
            </div>
            <button type="submit" class="btn-accent" style="width: 100%;">Xác nhận lưu</button>
        </form>
        <p style="margin-top: 12px;">
            <a href="${pageContext.request.contextPath}/admin/room-type/list" style="color: #ff385c;">← Danh sách loại phòng</a>
        </p>
    </div>
</div>

<%@ include file="/WEB-INF/views/shared/footer.jsp" %>
</body>
</html>
