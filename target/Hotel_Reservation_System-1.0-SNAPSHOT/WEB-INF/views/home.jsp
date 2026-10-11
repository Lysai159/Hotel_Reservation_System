<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LuxStay - Đặt Phòng Khách Sạn & Resort Giá Tốt Nhất</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body {
            color: #333;
            background-color: #f8f9fa;
            line-height: 1.6;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        a { text-decoration: none; color: inherit; }

        header { background-color: #fff; box-shadow: 0 2px 10px rgba(0,0,0,0.1); position: sticky; top: 0; z-index: 1000; }

        .btn-primary { background-color: #ff385c; color: white; border: none; border-radius: 20px; cursor: pointer; font-weight: 600; }

        .hero {
            background: linear-gradient(rgba(0,0,0,0.4), rgba(0,0,0,0.4)), url('https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1350&q=80') center/cover no-repeat;
            height: 500px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            color: white;
            text-align: center;
            padding: 0 20px;
        }
        .hero h1 { font-size: 2.5rem; margin-bottom: 10px; }

        .search-box {
            background: white;
            padding: 15px 25px;
            border-radius: 50px;
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
            margin-top: 30px;
            color: #333;
            align-items: center;
        }
        .search-item { display: flex; flex-direction: column; text-align: left; }
        .search-item label { font-size: 12px; font-weight: bold; color: #666; }
        .search-item input, .search-item select { border: none; outline: none; font-size: 14px; padding: 5px 0; background: transparent; }
        .search-item .vn-date-wrap { min-width: 150px; }
        .search-item .vn-date { min-width: 118px; }

        .container { max-width: 1200px; margin: 50px auto; padding: 0 20px; }
        .section-title { text-align: center; margin-bottom: 40px; }
        .section-title h2 { font-size: 2rem; color: #222; }

        .room-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 30px; }
        .room-card { display: block; background: white; border-radius: 12px; overflow: hidden; box-shadow: 0 4px 10px rgba(0,0,0,0.05); transition: transform 0.3s; color: inherit; cursor: pointer; }
        .room-card:hover { transform: translateY(-5px); }
        .room-img { height: 200px; width: 100%; object-fit: cover; }
        .room-info { padding: 20px; }
        .room-title { font-size: 1.2rem; font-weight: bold; margin-bottom: 8px; }
        .room-details { font-size: 0.9rem; color: #666; margin-bottom: 10px; }
        .room-desc { font-size: 0.9rem; color: #555; margin-bottom: 15px; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }
        .room-price { font-size: 1.1rem; font-weight: bold; color: #ff385c; display: flex; justify-content: space-between; align-items: center; gap: 10px; }

        footer { background-color: #222; color: white; padding: 40px 20px 20px; margin-top: auto; width: 100%; flex-shrink: 0; }
        .footer-content { max-width: 1200px; margin: 0 auto; display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 30px; }
        .footer-section h3 { margin-bottom: 15px; color: #ff385c; }
        .footer-section p, .footer-section a { color: #bbb; font-size: 0.9rem; margin-bottom: 8px; display: block; }
        .footer-bottom { text-align: center; border-top: 1px solid #444; padding-top: 20px; margin-top: 30px; font-size: 0.85rem; color: #888; }

        @media (max-width: 768px) {
            .search-box { border-radius: 15px; flex-direction: column; align-items: stretch; }
        }
    </style>
</head>
<body>
<%@ include file="/WEB-INF/views/shared/header.jsp" %>

<section class="hero">
    <h1>Tìm & Đặt Phòng Khách Sạn Tốt Nhất</h1>
    <p>Trải nghiệm kỳ nghỉ tuyệt vời với mức giá ưu đãi hàng đầu</p>

    <form class="search-box" action="${pageContext.request.contextPath}/room/list" method="get">
        <div class="search-item">
            <label><i class="fa-solid fa-calendar-days"></i> Nhận phòng</label>
            <input type="text" class="vn-date" name="checkInDate" required autocomplete="off">
        </div>
        <div class="search-item">
            <label><i class="fa-solid fa-calendar-days"></i> Trả phòng</label>
            <input type="text" class="vn-date" name="checkOutDate" required autocomplete="off">
        </div>
        <div class="search-item">
            <label><i class="fa-solid fa-user"></i> Số khách</label>
            <select name="guests">
                <option value="1">1 khách</option>
                <option value="2" selected>2 khách</option>
                <option value="3">3 khách</option>
                <option value="4">4 khách</option>
                <option value="5">5 khách</option>
                <option value="6">6 khách</option>
            </select>
        </div>
        <button class="btn btn-primary" type="submit" style="padding: 12px 25px;">
            <i class="fa-solid fa-magnifying-glass"></i> Tìm kiếm
        </button>
    </form>
</section>

<section class="container" id="noi-bat">
    <div class="section-title">
        <h2>Phòng Nổi Bật Dành Cho Bạn</h2>
        <p>Khám phá các lựa chọn chỗ ở được đánh giá cao nhất</p>
    </div>

    <div class="room-grid">
        <c:choose>
            <c:when test="${not empty rooms}">
                <c:forEach var="room" items="${rooms}">
                    <a class="room-card" href="${pageContext.request.contextPath}/room/detail/${room.roomId}">
                        <c:choose>
                            <c:when test="${not empty room.imageUrl}">
                                <img src="${pageContext.request.contextPath}${room.imageUrl}" alt="Phòng ${room.roomNumber}" class="room-img">
                            </c:when>
                            <c:otherwise>
                                <img src="${pageContext.request.contextPath}/assets/images/default-room.svg" alt="Phòng ${room.roomNumber}" class="room-img">
                            </c:otherwise>
                        </c:choose>
                        <div class="room-info">
                            <div class="room-title">Phòng ${room.roomNumber}<c:if test="${not empty room.roomType}"> - ${room.roomType.typeName}</c:if></div>
                            <div class="room-details">
                                <i class="fa-solid fa-bed"></i> ${room.status}
                                <c:if test="${not empty room.roomType}">
                                    &bull; <i class="fa-solid fa-users"></i> ${room.roomType.capacity} khách
                                </c:if>
                            </div>
                            <c:if test="${not empty room.displayDescription}">
                                <p class="room-desc">${room.displayDescription}</p>
                            </c:if>
                            <div class="room-price">
                                <span>
                                    <c:choose>
                                        <c:when test="${not empty room.roomType}">
                                            <fmt:formatNumber value="${room.roomType.basePrice}" type="number"/>₫
                                        </c:when>
                                        <c:otherwise>--</c:otherwise>
                                    </c:choose>
                                    <small style="font-size:12px; color:#666;">/đêm</small>
                                </span>
                                <span class="btn btn-outline" style="padding: 5px 12px;">Xem chi tiết</span>
                            </div>
                        </div>
                    </a>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="room-card">
                    <img src="https://images.unsplash.com/photo-1611892440504-42a792e24d32?auto=format&fit=crop&w=500&q=80" alt="Phòng Deluxe Beachfront" class="room-img">
                    <div class="room-info">
                        <div class="room-title">Deluxe Hướng Biển</div>
                        <div class="room-details">
                            <i class="fa-solid fa-bed"></i> 1 Giường đôi lớn &bull; <i class="fa-solid fa-maximize"></i> 35 m²
                        </div>
                        <div class="room-price">
                            <span>1.200.000₫ <small style="font-size:12px; color:#666;">/đêm</small></span>
                            <a href="${pageContext.request.contextPath}/room/list" class="btn btn-outline" style="padding: 5px 12px;">Xem chi tiết</a>
                        </div>
                    </div>
                </div>
                <div class="room-card">
                    <img src="https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=500&q=80" alt="Phòng Executive Suite" class="room-img">
                    <div class="room-info">
                        <div class="room-title">Executive Suite Cao Cấp</div>
                        <div class="room-details">
                            <i class="fa-solid fa-bed"></i> 1 Giường King &bull; <i class="fa-solid fa-maximize"></i> 55 m²
                        </div>
                        <div class="room-price">
                            <span>2.500.000₫ <small style="font-size:12px; color:#666;">/đêm</small></span>
                            <a href="${pageContext.request.contextPath}/room/list" class="btn btn-outline" style="padding: 5px 12px;">Xem chi tiết</a>
                        </div>
                    </div>
                </div>
                <div class="room-card">
                    <img src="https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=500&q=80" alt="Phòng Family Standard" class="room-img">
                    <div class="room-info">
                        <div class="room-title">Phòng Gia Đình Tiêu Chuẩn</div>
                        <div class="room-details">
                            <i class="fa-solid fa-bed"></i> 2 Giường đôi &bull; <i class="fa-solid fa-maximize"></i> 45 m²
                        </div>
                        <div class="room-price">
                            <span>1.800.000₫ <small style="font-size:12px; color:#666;">/đêm</small></span>
                            <a href="${pageContext.request.contextPath}/room/list" class="btn btn-outline" style="padding: 5px 12px;">Xem chi tiết</a>
                        </div>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</section>

<footer id="lien-he">
    <div class="footer-content">
        <div class="footer-section">
            <h3>LuxStay</h3>
            <p>Nền tảng đặt phòng khách sạn, biệt thự, homestay hàng đầu. Cam kết mang lại trải nghiệm tốt nhất với mức giá hợp lý.</p>
        </div>
        <div class="footer-section">
            <h3>Về chúng tôi</h3>
            <a href="${pageContext.request.contextPath}/">Giới thiệu</a>
            <a href="${pageContext.request.contextPath}/room/list">Cơ hội việc làm</a>
            <a href="${pageContext.request.contextPath}/room/list">Tin tức & Blog</a>
        </div>
        <div class="footer-section">
            <h3>Hỗ trợ khách hàng</h3>
            <a href="${pageContext.request.contextPath}/booking/history">Trung tâm trợ giúp</a>
            <a href="${pageContext.request.contextPath}/room/list">Chính sách hủy phòng</a>
            <a href="${pageContext.request.contextPath}/customer/profile">Quy định bảo mật</a>
        </div>
        <div class="footer-section">
            <h3>Liên hệ</h3>
            <p><i class="fa-solid fa-phone"></i> 1900 123 456</p>
            <p><i class="fa-solid fa-envelope"></i> support@luxstay.com</p>
        </div>
    </div>
    <div class="footer-bottom">
        &copy; 2026 LuxStay. Tất cả các quyền được bảo lưu.
    </div>
</footer>

</body>
</html>
