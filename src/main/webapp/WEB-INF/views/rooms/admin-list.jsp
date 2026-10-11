<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Phòng - LuxStay</title>
    <style>
        .thumb { width: 120px; height: 84px; object-fit: cover; border-radius: 10px; }
        table.data tbody tr { cursor: pointer; }
        table.data tbody tr:hover { background: #fff7f8; }
        .desc-cell { max-width: 280px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; color: #555; }
    </style>
</head>
<body>
<%@ include file="/WEB-INF/views/shared/admin-header.jsp" %>

<div class="page-wrap">
    <div style="display: flex; justify-content: space-between; align-items: center;">
        <h2>Quản lý phòng</h2>
        <a href="${pageContext.request.contextPath}/admin/room/add" class="btn-accent">+ Thêm phòng</a>
    </div>
    <table class="data">
        <thead>
            <tr>
                <th>Ảnh</th>
                <th>Số phòng</th>
                <th>Loại phòng</th>
                <th>Giá/đêm</th>
                <th>Trạng thái</th>
                <th>Mô tả</th>
                <th>Thao tác</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="room" items="${rooms}">
                <tr onclick="if (!event.target.closest('.action-btns')) location.href='${pageContext.request.contextPath}/admin/room/edit/${room.roomId}'">
                    <td>
                        <c:choose>
                            <c:when test="${not empty room.imageUrl}">
                                <img class="thumb" src="${pageContext.request.contextPath}${room.imageUrl}" alt="Phòng ${room.roomNumber}">
                            </c:when>
                            <c:otherwise>
                                <img class="thumb" src="${pageContext.request.contextPath}/assets/images/default-room.svg" alt="Phòng ${room.roomNumber}">
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>${room.roomNumber}</td>
                    <td>${room.roomType.typeName}</td>
                    <td>${room.roomType.basePrice}</td>
                    <td>${room.status}</td>
                    <td class="desc-cell" title="${room.displayDescription}">
                        <c:choose>
                            <c:when test="${not empty room.displayDescription}">
                                ${room.displayDescription}
                            </c:when>
                            <c:otherwise><span style="color:#999;">Chưa có mô tả</span></c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <div class="action-btns">
                            <a class="btn-sm btn-edit" href="${pageContext.request.contextPath}/admin/room/edit/${room.roomId}">Sửa</a>
                            <a class="btn-sm btn-delete" href="${pageContext.request.contextPath}/admin/room/delete/${room.roomId}"
                               onclick="return confirm('Xóa phòng này?')">Xóa</a>
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
