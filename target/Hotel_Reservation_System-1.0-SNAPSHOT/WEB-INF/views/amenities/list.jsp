<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tiện Ích - LuxStay</title>
</head>
<body>
<%@ include file="/WEB-INF/views/shared/admin-header.jsp" %>

<div class="page-wrap">
    <h2>Danh sách tiện ích khách sạn</h2>

    <div class="card-box" style="margin-bottom: 24px;">
        <h3 style="margin-bottom: 12px;">Thêm tiện ích</h3>
        <form action="${pageContext.request.contextPath}/admin/amenity/save" method="post">
            <div class="form-group">
                <label>Tên tiện ích</label>
                <input type="text" name="amenityName" required>
            </div>
            <div class="form-group">
                <label>Mô tả</label>
                <input type="text" name="description">
            </div>
            <button type="submit" class="btn-accent">Lưu tiện ích</button>
        </form>
    </div>

    <table class="data">
        <thead>
            <tr>
                <th>Mã</th>
                <th>Tên tiện ích</th>
                <th>Mô tả</th>
                <th>Thao tác</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="amenity" items="${amenities}">
                <tr>
                    <td>#${amenity.amenityId}</td>
                    <td><b>${amenity.amenityName}</b></td>
                    <td>${amenity.description}</td>
                    <td>
                        <div class="action-btns">
                            <a class="btn-sm btn-edit" href="${pageContext.request.contextPath}/admin/amenity/edit/${amenity.amenityId}">Sửa</a>
                            <a class="btn-sm btn-delete" href="${pageContext.request.contextPath}/admin/amenity/delete/${amenity.amenityId}"
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
