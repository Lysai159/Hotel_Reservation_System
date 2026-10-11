<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Khách Hàng - LuxStay</title>
</head>
<body>
<%@ include file="/WEB-INF/views/shared/admin-header.jsp" %>

<div class="page-wrap">
    <h2>Danh sách tài khoản khách hàng</h2>
    <table class="data">
        <thead>
            <tr>
                <th>ID</th>
                <th>Họ và tên</th>
                <th>Email</th>
                <th>Số điện thoại</th>
                <th>Địa chỉ</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="cust" items="${customers}">
                <tr>
                    <td>#${cust.userId}</td>
                    <td>${cust.fullName}</td>
                    <td>${cust.email}</td>
                    <td>${cust.phoneNumber}</td>
                    <td>${cust.address}</td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

<%@ include file="/WEB-INF/views/shared/footer.jsp" %>
</body>
</html>
