<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Phòng - LuxStay</title>
    <style>
        .preview { width: 100%; max-height: 340px; object-fit: cover; border-radius: 12px; margin-bottom: 18px; }
    </style>
</head>
<body>
<%@ include file="/WEB-INF/views/shared/admin-header.jsp" %>

<div class="page-wrap form-wide">
    <div class="card-box">
        <h2>${empty room.roomId ? 'Thêm phòng mới' : 'Cập nhật phòng'}</h2>
        <c:if test="${not empty error}">
            <p class="error">${error}</p>
        </c:if>
        <form action="${pageContext.request.contextPath}/admin/room/save" method="post" enctype="multipart/form-data">
            <c:if test="${not empty room.roomId}">
                <input type="hidden" name="roomId" value="${room.roomId}">
            </c:if>

            <c:choose>
                <c:when test="${not empty room.imageUrl}">
                    <img class="preview" src="${pageContext.request.contextPath}${room.imageUrl}" alt="Phòng ${room.roomNumber}">
                </c:when>
                <c:otherwise>
                    <img class="preview" src="${pageContext.request.contextPath}/assets/images/default-room.svg" alt="Ảnh mặc định">
                </c:otherwise>
            </c:choose>

            <div class="form-group">
                <label>Số phòng</label>
                <input type="text" name="roomNumber" value="${room.roomNumber}" required>
            </div>
            <div class="form-group">
                <label>Loại phòng</label>
                <select name="typeId" required>
                    <c:forEach var="type" items="${roomTypes}">
                        <option value="${type.typeId}" ${type.typeId == room.roomType.typeId ? 'selected' : ''}>
                            ${type.typeName} (${type.basePrice} VNĐ)
                        </option>
                    </c:forEach>
                </select>
            </div>
            <div class="form-group">
                <label>Trạng thái</label>
                <select name="status">
                    <option value="Available" ${room.status == 'Available' ? 'selected' : ''}>Sẵn sàng (Available)</option>
                    <option value="Occupied" ${room.status == 'Occupied' ? 'selected' : ''}>Đang có khách (Occupied)</option>
                    <option value="Maintenance" ${room.status == 'Maintenance' ? 'selected' : ''}>Bảo trì (Maintenance)</option>
                </select>
            </div>
            <div class="form-group">
                <label>Mô tả phòng</label>
                <textarea name="description" rows="12" placeholder="Nhập mô tả chi tiết về phòng: diện tích, giường, view, tiện nghi...">${room.description}</textarea>
                <small style="color:#666; display:block; margin-top:6px;">
                    Mô tả này hiện trên trang chi tiết phòng. Nếu để trống, hệ thống sẽ dùng mô tả của loại phòng.
                </small>
            </div>
            <div class="form-group">
                <label>Ảnh phòng (jpg/png/webp, tối đa 20MB)</label>
                <input type="file" name="imageFile" accept="image/png,image/jpeg,image/jpg,image/webp">
                <small style="color:#666; display:block; margin-top:6px;">
                    Ảnh lưu trực tiếp vào thư mục <code>uploads/rooms</code> (tên file theo mã phòng, không lưu đường dẫn trong database).
                </small>
            </div>
            <button type="submit" class="btn-accent" style="width: 100%;">Lưu phòng</button>
        </form>
        <p style="margin-top: 12px;"><a href="${pageContext.request.contextPath}/admin/room/list" style="color: #ff385c;">← Danh sách phòng</a></p>
    </div>
</div>

<%@ include file="/WEB-INF/views/shared/footer.jsp" %>
</body>
</html>
