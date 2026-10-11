<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt phòng - LuxStay</title>
    <style>
        .room-layout { max-width: 1200px; margin: 30px auto; padding: 0 20px; display: grid; grid-template-columns: 280px 1fr; gap: 30px; }
        .filter-sidebar { background: #fff; padding: 20px; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); height: fit-content; }
        .filter-group { margin-bottom: 20px; border-bottom: 1px solid #eee; padding-bottom: 15px; }
        .filter-group:last-of-type { border-bottom: none; }
        .room-card-horizontal { display: flex; background: #fff; border-radius: 12px; overflow: hidden; margin-bottom: 20px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); cursor: pointer; }
        .room-card-horizontal:hover { box-shadow: 0 6px 16px rgba(0,0,0,0.1); }
        .room-card-horizontal img { width: 280px; height: 200px; object-fit: cover; }
        .room-card-content { padding: 20px; flex: 1; display: flex; flex-direction: column; justify-content: space-between; }
        .room-card-content h3 a { color: inherit; }
        .room-desc { font-size: 14px; color: #555; margin-top: 8px; display: -webkit-box; -webkit-line-clamp: 3; -webkit-box-orient: vertical; overflow: hidden; white-space: pre-wrap; }
        .status-Available { color: #155724; font-weight: 700; }
        .status-Occupied { color: #721c24; font-weight: 700; }
        @media (max-width: 768px) {
            .room-layout { grid-template-columns: 1fr; }
            .room-card-horizontal { flex-direction: column; }
            .room-card-horizontal img { width: 100%; }
        }
    </style>
</head>
<body>
<%@ include file="/WEB-INF/views/shared/header.jsp" %>

<div class="room-layout">
    <aside class="filter-sidebar">
        <form id="filterForm" action="${pageContext.request.contextPath}/room/list" method="get">
            <h3 style="margin-bottom: 15px;">Bộ lọc tìm kiếm</h3>

            <div class="filter-group">
                <label style="font-weight: bold; display: block; margin-bottom: 8px;">Nhận phòng</label>
                <input type="text" class="vn-date" name="checkInDate" value="${checkInDate}" data-autosubmit="true" autocomplete="off" style="width:100%; padding:8px; border:1px solid #ddd; border-radius:8px;">
            </div>
            <div class="filter-group">
                <label style="font-weight: bold; display: block; margin-bottom: 8px;">Trả phòng</label>
                <input type="text" class="vn-date" name="checkOutDate" value="${checkOutDate}" data-autosubmit="true" autocomplete="off" style="width:100%; padding:8px; border:1px solid #ddd; border-radius:8px;">
            </div>
            <div class="filter-group">
                <label style="font-weight: bold; display: block; margin-bottom: 8px;">Số khách</label>
                <select name="guests" onchange="this.form.submit()" style="width:100%; padding:8px; border:1px solid #ddd; border-radius:8px;">
                    <option value="">Tất cả</option>
                    <c:forEach var="i" begin="1" end="6">
                        <option value="${i}" ${guests == i ? 'selected' : ''}>${i} khách</option>
                    </c:forEach>
                </select>
            </div>
            <div class="filter-group">
                <span style="font-weight: bold; display: block; margin-bottom: 10px;">Loại phòng</span>
                <c:forEach var="type" items="${roomTypes}">
                    <label style="display: flex; align-items: center; gap: 8px; margin-bottom: 8px;">
                        <input type="checkbox" name="typeId" value="${type.typeId}" onchange="this.form.submit()"
                               <c:forEach var="selectedId" items="${selectedTypeIds}">
                                   <c:if test="${selectedId == type.typeId}">checked</c:if>
                               </c:forEach>>
                        ${type.typeName}
                    </label>
                </c:forEach>
                <c:if test="${empty roomTypes}">
                    <p style="color: #888; font-size: 14px;">Chưa có loại phòng.</p>
                </c:if>
            </div>
        </form>
    </aside>

    <main>
        <h2 style="margin-bottom: 12px;">Phòng còn trống (<c:out value="${empty rooms ? 0 : rooms.size()}"/>)</h2>
        <c:if test="${not empty checkInDate && not empty checkOutDate}">
            <p style="color:#666; margin-bottom: 16px;">Khoảng ngày: ${checkInDate.dayOfMonth}/${checkInDate.monthValue}/${checkInDate.year} → ${checkOutDate.dayOfMonth}/${checkOutDate.monthValue}/${checkOutDate.year}</p>
        </c:if>
        <c:if test="${not empty error}">
            <p class="error">${error}</p>
        </c:if>
        <c:choose>
            <c:when test="${not empty rooms}">
                <c:forEach var="room" items="${rooms}">
                    <div class="room-card-horizontal" onclick="if (!event.target.closest('.book-actions')) location.href='${pageContext.request.contextPath}/room/detail/${room.roomId}'">
                        <c:choose>
                            <c:when test="${not empty room.imageUrl}">
                                <img src="${pageContext.request.contextPath}${room.imageUrl}" alt="Phòng ${room.roomNumber}">
                            </c:when>
                            <c:otherwise>
                                <img src="${pageContext.request.contextPath}/assets/images/default-room.svg" alt="Phòng ${room.roomNumber}">
                            </c:otherwise>
                        </c:choose>
                        <div class="room-card-content">
                            <div>
                                <h3>Phòng ${room.roomNumber}<c:if test="${not empty room.roomType}"> - ${room.roomType.typeName}</c:if></h3>
                                <p class="status-${room.status}" style="margin: 6px 0;">Trạng thái: ${room.status}</p>
                                <c:if test="${not empty room.roomType}">
                                    <p style="color: #666; font-size: 14px;">
                                        <i class="fa-solid fa-users"></i> Sức chứa: ${room.roomType.capacity} người
                                    </p>
                                </c:if>
                                <c:if test="${not empty room.displayDescription}">
                                    <p class="room-desc">${room.displayDescription}</p>
                                </c:if>
                            </div>
                            <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 15px;">
                                <span style="font-weight: bold; color: #ff385c; font-size: 18px;">
                                    <c:if test="${not empty room.roomType}">
                                        <fmt:formatNumber value="${room.roomType.basePrice}" type="number" /> ₫
                                        <small style="font-size: 12px; color: #666;">/đêm</small>
                                    </c:if>
                                </span>
                                <div class="book-actions" style="display:flex; gap:8px;">
                                    <a href="${pageContext.request.contextPath}/room/detail/${room.roomId}" class="btn-outline">Chi tiết</a>
                                    <a href="${pageContext.request.contextPath}/cart/add?roomId=${room.roomId}<c:if test="${not empty checkInDate}">&amp;checkInDate=${checkInDate}</c:if><c:if test="${not empty checkOutDate}">&amp;checkOutDate=${checkOutDate}</c:if>" class="btn-accent">Đặt phòng</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="card-box" style="text-align: center;">Hiện không có phòng trống phù hợp.</div>
            </c:otherwise>
        </c:choose>
    </main>
</div>

<%@ include file="/WEB-INF/views/shared/footer.jsp" %>
</body>
</html>
