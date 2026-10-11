<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi Tiết Phòng ${room.roomNumber} - LuxStay</title>
    <style>
        .gallery { display: grid; grid-template-columns: 2fr 1fr; gap: 10px; border-radius: 12px; overflow: hidden; height: 350px; margin: 20px 0 30px; }
        .gallery img { width: 100%; height: 100%; object-fit: cover; }
        .content-grid { display: grid; grid-template-columns: 1fr 350px; gap: 28px; align-items: start; }
        .info-stack { display: flex; flex-direction: column; gap: 18px; }
        .info-card {
            background: #fff;
            border: 1px solid #eee;
            border-radius: 16px;
            padding: 18px 20px 16px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.06);
            height: fit-content;
            width: 100%;
        }
        .info-card h2 {
            font-size: 1.15rem;
            margin: 0 0 14px;
            padding-bottom: 12px;
            border-bottom: 1px solid #f0f0f0;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .info-card h2 i { color: #ff385c; font-size: 1rem; }
        .room-desc {
            margin: 0;
            width: 100%;
            color: #444;
            font-size: 15px;
            line-height: 1.75;
            text-align: justify;
            text-justify: inter-word;
            hyphens: auto;
        }
        .amenities { display: grid; grid-template-columns: repeat(2, 1fr); gap: 12px; }
        .amenity-item {
            display: flex;
            align-items: center;
            gap: 10px;
            background: #f8f9fa;
            border: 1px solid #eee;
            border-radius: 10px;
            padding: 12px 14px;
            font-size: 14px;
            color: #333;
        }
        .amenity-item i { color: #ff385c; width: 18px; text-align: center; }
        .booking-card { background: white; padding: 20px; border-radius: 16px; box-shadow: 0 4px 16px rgba(0,0,0,0.08); border: 1px solid #eee; height: fit-content; position: sticky; top: 90px; }
        .badge { display: inline-block; padding: 4px 8px; border-radius: 4px; font-size: 12px; font-weight: bold; }
        .status-Available { background-color: #d4edda; color: #155724; }
        .status-Occupied { background-color: #f8d7da; color: #721c24; }
        .back-link { display: inline-block; margin-top: 4px; color: #ff385c; font-weight: 600; }
        @media (max-width: 768px) {
            .content-grid, .gallery, .amenities { grid-template-columns: 1fr; }
            .gallery { height: auto; }
        }
    </style>
</head>
<body>
<%@ include file="/WEB-INF/views/shared/header.jsp" %>

<div class="page-wrap">
    <div style="display: flex; justify-content: space-between; align-items: center; gap: 12px;">
        <h1>Phòng ${room.roomNumber}<c:if test="${not empty room.roomType}"> - ${room.roomType.typeName}</c:if></h1>
        <span class="badge status-${room.status}">${room.status}</span>
    </div>

    <div class="gallery">
        <c:choose>
            <c:when test="${not empty room.imageUrl}">
                <img src="${pageContext.request.contextPath}${room.imageUrl}" alt="Phòng ${room.roomNumber}">
            </c:when>
            <c:otherwise>
                <img src="${pageContext.request.contextPath}/assets/images/default-room.svg" alt="Phòng ${room.roomNumber}">
            </c:otherwise>
        </c:choose>
        <div style="display: grid; grid-template-rows: 1fr 1fr; gap: 10px;">
            <img src="https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=400&q=80" alt="Phòng tắm">
            <img src="https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=400&q=80" alt="Ban công">
        </div>
    </div>

    <div class="content-grid">
        <div class="info-stack">
            <section class="info-card">
                <h2><i class="fa-solid fa-align-left"></i> Mô tả phòng</h2>
                <p class="room-desc"><c:choose><c:when test="${not empty room.displayDescription}">${room.displayDescription}</c:when><c:otherwise>Phòng nghỉ đầy đủ tiện nghi, mang lại trải nghiệm thoải mái cho kỳ nghỉ của bạn.</c:otherwise></c:choose></p>
            </section>
            <section class="info-card">
                <h2><i class="fa-solid fa-spa"></i> Tiện nghi nổi bật</h2>
                <div class="amenities">
                    <div class="amenity-item"><i class="fa-solid fa-wifi"></i> Wifi tốc độ cao</div>
                    <div class="amenity-item"><i class="fa-solid fa-snowflake"></i> Điều hòa</div>
                    <div class="amenity-item"><i class="fa-solid fa-tv"></i> TV thông minh</div>
                    <div class="amenity-item"><i class="fa-solid fa-utensils"></i> Bữa sáng</div>
                    <div class="amenity-item"><i class="fa-solid fa-shower"></i> Phòng tắm riêng</div>
                    <div class="amenity-item"><i class="fa-solid fa-mug-saucer"></i> Ấm đun / minibar</div>
                </div>
            </section>
            <p><a class="back-link" href="${pageContext.request.contextPath}/room/list">← Quay lại danh sách phòng</a></p>
        </div>

        <div class="booking-card">
            <h3 style="color: #ff385c; margin-bottom: 15px;">
                <c:if test="${not empty room.roomType}">
                    <fmt:formatNumber value="${room.roomType.basePrice}" type="number" /> ₫
                    <small style="color:#666; font-size:14px;">/đêm</small>
                </c:if>
            </h3>
            <c:if test="${not empty error}">
                <p class="error">${error}</p>
            </c:if>
            <form action="${pageContext.request.contextPath}/cart/add" method="get">
                <input type="hidden" name="roomId" value="${room.roomId}">
                <div class="form-group">
                    <label>Ngày nhận phòng</label>
                    <input type="text" class="vn-date" name="checkInDate" value="${checkInDate}" required autocomplete="off">
                </div>
                <div class="form-group">
                    <label>Ngày trả phòng</label>
                    <input type="text" class="vn-date" name="checkOutDate" value="${checkOutDate}" required autocomplete="off">
                </div>
                <p style="font-size: 13px; color: #666; margin-bottom: 12px;">
                    Tổng tiền = số đêm × giá loại phòng. Có thể thêm nhiều phòng vào giỏ rồi thanh toán một lần.
                </p>
                <c:choose>
                    <c:when test="${room.status == 'Maintenance'}">
                        <button type="button" class="btn-accent" style="width: 100%; opacity: 0.6;" disabled>Phòng đang bảo trì</button>
                    </c:when>
                    <c:otherwise>
                        <button type="submit" class="btn-accent" style="width: 100%;">Thêm vào giỏ</button>
                    </c:otherwise>
                </c:choose>
            </form>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/views/shared/footer.jsp" %>
</body>
</html>
