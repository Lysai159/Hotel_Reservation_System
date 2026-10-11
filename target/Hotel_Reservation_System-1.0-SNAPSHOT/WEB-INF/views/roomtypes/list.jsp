<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Loại Phòng - LuxStay</title>
</head>
<body>
<%@ include file="/WEB-INF/views/shared/admin-header.jsp" %>

<div class="page-wrap">
    <div style="display: flex; justify-content: space-between; align-items: center;">
        <h2>Danh sách loại phòng</h2>
        <a href="${pageContext.request.contextPath}/admin/room-type/add" class="btn-accent">+ Thêm loại phòng</a>
    </div>
    <table class="data">
        <thead>
            <tr>
                <th>ID</th>
                <th>Tên loại phòng</th>
                <th>Mô tả</th>
                <th>Giá cơ bản (VNĐ)</th>
                <th>Sức chứa</th>
                <th>Thao tác</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="type" items="${roomTypes}">
                <tr>
                    <td>${type.typeId}</td>
                    <td>${type.typeName}</td>
                    <td>${type.description}</td>
                    <td>${type.basePrice}</td>
                    <td>${type.capacity} người</td>
                    <td>
                        <div class="action-btns">
                            <a class="btn-sm btn-edit" href="${pageContext.request.contextPath}/admin/room-type/edit/${type.typeId}">Sửa</a>
                            <a class="btn-sm btn-delete" href="${pageContext.request.contextPath}/admin/room-type/delete/${type.typeId}"
                               onclick="return confirm('Bạn chắc chắn muốn xóa?')">Xóa</a>
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
