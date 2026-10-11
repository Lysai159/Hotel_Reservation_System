DROP DATABASE IF EXISTS hotel_reservation_system;
CREATE DATABASE hotel_reservation_system
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;
USE hotel_reservation_system;

CREATE TABLE Roles (
    RoleID INT PRIMARY KEY AUTO_INCREMENT,
    RoleName VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Users (
    UserID INT PRIMARY KEY AUTO_INCREMENT,
    RoleID INT NOT NULL,
    FullName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    PasswordHash VARCHAR(255) NOT NULL,
    PhoneNumber VARCHAR(20),
    Address VARCHAR(255),
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (RoleID) REFERENCES Roles(RoleID)
);

CREATE TABLE RoomTypes (
    TypeID INT PRIMARY KEY AUTO_INCREMENT,
    TypeName VARCHAR(50) NOT NULL,
    Description TEXT,
    BasePrice DECIMAL(10, 2) NOT NULL,
    Capacity INT NOT NULL
);

-- Ảnh phòng lưu file uploads/rooms/room_{RoomID}.ext, không lưu đường dẫn trong bảng Rooms.
CREATE TABLE Rooms (
    RoomID INT PRIMARY KEY AUTO_INCREMENT,
    RoomNumber VARCHAR(10) NOT NULL UNIQUE,
    TypeID INT NOT NULL,
    Status VARCHAR(20) DEFAULT 'Available',
    Description TEXT NULL,
    FOREIGN KEY (TypeID) REFERENCES RoomTypes(TypeID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE Amenities (
    AmenityID INT PRIMARY KEY AUTO_INCREMENT,
    AmenityName VARCHAR(100) NOT NULL,
    Description TEXT
);

CREATE TABLE RoomTypeAmenities (
    TypeID INT NOT NULL,
    AmenityID INT NOT NULL,
    PRIMARY KEY (TypeID, AmenityID),
    FOREIGN KEY (TypeID) REFERENCES RoomTypes(TypeID) ON DELETE CASCADE,
    FOREIGN KEY (AmenityID) REFERENCES Amenities(AmenityID) ON DELETE CASCADE
);

CREATE TABLE Bookings (
    BookingID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT NOT NULL,
    RoomID INT NOT NULL,
    CheckInDate DATE NOT NULL,
    CheckOutDate DATE NOT NULL,
    TotalPrice DECIMAL(10, 2) NOT NULL,
    Status VARCHAR(20) DEFAULT 'Pending',
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (CustomerID) REFERENCES Users(UserID),
    FOREIGN KEY (RoomID) REFERENCES Rooms(RoomID)
);

CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY AUTO_INCREMENT,
    BookingID INT NOT NULL UNIQUE,
    PaymentDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    Amount DECIMAL(10, 2) NOT NULL,
    PaymentMethod VARCHAR(50) NOT NULL,
    Status VARCHAR(20) DEFAULT 'Success',
    ProcessedBy INT NULL,
    FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID),
    FOREIGN KEY (ProcessedBy) REFERENCES Users(UserID)
);

INSERT INTO Roles (RoleName) VALUES ('Admin'), ('Receptionist'), ('Customer');


-- 1. Dữ liệu mẫu cho bảng Users (1 Admin, 2 Lễ tân, 10 Khách hàng)
INSERT INTO Users (RoleID, FullName, Email, PasswordHash, PhoneNumber, Address) VALUES
(1, 'Nguyen Van Admin', 'admin@hotel.com', 'hash_admin123amenities', '0901000000', 'Ha Noi'),
(2, 'Tran Thi Le Tan 1', 'letan1@hotel.com', 'hash_letan123', '0902000001', 'Da Nang'),
(2, 'Le Van Le Tan 2', 'letan2@hotel.com', 'hash_letan123', '0902000002', 'TP HCM'),
(3, 'Nguyen Van A', 'nguyenvana@gmail.com', 'hash_pass1', '0911000001', 'Ha Noi'),
(3, 'Tran Thi B', 'tranthib@gmail.com', 'hash_pass2', '0911000002', 'TP HCM'),
(3, 'Le Van C', 'levanc@gmail.com', 'hash_pass3', '0911000003', 'Da Nang'),
(3, 'Pham Minh D', 'phamminhd@gmail.com', 'hash_pass4', '0911000004', 'Hai Phong'),
(3, 'Hoang Anh E', 'hoanganhe@gmail.com', 'hash_pass5', '0911000005', 'Can Tho'),
(3, 'Vu Thi F', 'vuthif@gmail.com', 'hash_pass6', '0911000006', 'Nha Trang'),
(3, 'Dang Van G', 'dangvang@gmail.com', 'hash_pass7', '0911000007', 'Hue'),
(3, 'Bui Thi H', 'buithih@gmail.com', 'hash_pass8', '0911000008', 'Quang Ninh'),
(3, 'Do Quang I', 'doquangi@gmail.com', 'hash_pass9', '0911000009', 'Binh Duong'),
(3, 'Ngo Mai K', 'ngomaik@gmail.com', 'hash_pass10', '0911000010', 'Vung Tau');

-- 2. Dữ liệu mẫu cho bảng RoomTypes
INSERT INTO RoomTypes (TypeName, Description, BasePrice, Capacity) VALUES
('Standard Single', 'Phong don tieu chuan', 500000.00, 1),
('Standard Double', 'Phong doi tieu chuan', 800000.00, 2),
('Deluxe Suite', 'Phong cao cap sang trọng', 1500000.00, 3),
('VIP Ocean View', 'Phong VIP huong bien', 2500000.00, 4);

-- 3. Dữ liệu mẫu cho bảng Amenities
INSERT INTO Amenities (AmenityName, Description) VALUES
('Wifi High-Speed', 'Internet toc do cao mien phi'),
('Air Conditioner', 'Dieu hoa 2 chieu'),
('Smart TV', 'Truyen hinh cap va Netflix'),
('Mini Bar', 'Tu lanh nho chua do uong'),
('Jacuzzi', 'Bon tam massage cao cap');

-- 4. Dữ liệu mẫu cho bảng RoomTypeAmenities
INSERT INTO RoomTypeAmenities (TypeID, AmenityID) VALUES
(1, 1), (1, 2),
(2, 1), (2, 2), (2, 3),
(3, 1), (3, 2), (3, 3), (3, 4),
(4, 1), (4, 2), (4, 3), (4, 4), (4, 5);

-- 5. Dữ liệu mẫu cho bảng Rooms (10 phòng)
INSERT INTO Rooms (RoomNumber, TypeID, Status, Description) VALUES
('101', 1, 'Available', 'Phòng 101 là phòng đơn tiêu chuẩn tại tầng 1, diện tích khoảng 22m², thiết kế gọn gàng và tận dụng ánh sáng tự nhiên từ cửa sổ nhìn ra sân vườn. Không gian gồm một giường đơn nệm cao su êm ái, tủ quần áo, bàn làm việc nhỏ và ghế xoay, phù hợp khách công tác cần yên tĩnh để làm việc buổi tối. Phòng tắm riêng có vòi sen, máy sấy tóc, gương trang điểm và bộ đồ vệ sinh cá nhân. Tiện nghi gồm wifi tốc độ cao, điều hòa hai chiều, TV 32 inch, nước uống đóng chai và ấm đun siêu tốc. Hành lang tầng 1 gần sảnh lễ tân nên nhận phòng, trả phòng và gọi hỗ trợ đều thuận tiện. Đây là lựa chọn tiết kiệm, sạch sẽ cho khách đi một mình hoặc lưu trú ngắn ngày.'),
('102', 1, 'Available', 'Phòng 102 nằm cuối hành lang tầng 1, ít người qua lại nên rất yên tĩnh vào ban đêm. Diện tích khoảng 22m² với giường đơn, rèm cản sáng, tủ quần áo rộng và kệ để vali. Cửa sổ hướng Đông đón nắng buổi sáng, giúp căn phòng thoáng và dễ chịu. Phòng tắm kính có vòi sen áp lực tốt, khăn tắm thay hằng ngày và đồ dùng cá nhân đầy đủ. Khách được dùng wifi miễn phí, điều hòa, ổ cắm USB sạc nhanh và bàn làm việc. Vị trí gần thang máy và sảnh chính nên thuận tiện cho khách check-in muộn hoặc đi sớm. Phù hợp nhân viên công tác, khách vãng lai hoặc người cần không gian riêng tư với mức giá hợp lý.'),
('103', 2, 'Booked', 'Phòng 103 là phòng đôi tiêu chuẩn khoảng 28m², bố trí một giường đôi lớn, phù hợp cặp đôi hoặc hai bạn đồng hành. Nội thất tông màu ấm, có smart TV, bàn trà nhỏ, tủ quần áo và gương soi toàn thân. Phòng tắm riêng với bồn rửa, vòi sen, máy sấy và bộ amenities tiêu chuẩn. Cửa sổ nhìn ra lối đi nội bộ, rèm dày giúp ngủ ngon dù khách ra vào sảnh khá nhiều. Tầng 1 gần nhà hàng buổi sáng nên dùng buffet nhanh, không phải chờ thang máy. Wifi, điều hòa, minibar nước suối và ấm pha trà/cà phê đều được trang bị sẵn. Đây là lựa chọn cân bằng giữa giá và sự tiện nghi cho kỳ nghỉ cuối tuần 2 người.'),
('104', 2, 'Available', 'Phòng 104 hướng sân trong yên tĩnh, diện tích khoảng 28m², giường đôi nệm êm, lý tưởng cho cặp đôi muốn nghỉ ngơi sau ngày dài. Ban ngày ánh sáng dịu, ban đêm ít tiếng ồn từ đường phố. Trong phòng có bàn trà, hai ghế, smart TV, két an toàn nhỏ và tủ lạnh minibar. Phòng tắm sạch sẽ, có vòi sen, khăn lớn, dép đi trong phòng và đồ vệ sinh. Điều hòa hai chiều, wifi ổn định và ổ cắm hai bên giường giúp sạc điện thoại tiện lợi. Nhân viên dọn phòng hằng ngày, thay khăn theo yêu cầu. Phù hợp nghỉ dưỡng ngắn ngày, khách đi công tác theo cặp hoặc gia đình 2 người không cần view biển.'),
('201', 2, 'Booked', 'Phòng 201 ở tầng 2, yên tĩnh hơn tầng trệt, có ban công nhỏ nhìn ra hàng cây xanh. Diện tích khoảng 30m² với giường đôi lớn, ga trải chất liệu cotton, hai gối ôm và đèn đọc sách hai bên. Không gian có khu vực ngồi uống trà, smart TV, wifi tốc độ cao và điều hòa. Phòng tắm riêng cửa kính, vòi sen mưa, máy sấy tóc và đồ dùng cá nhân. Ban công đủ chỗ đứng hít thở không khí buổi sáng hoặc uống cà phê. Tầng 2 gần khu thang máy nên di chuyển xuống nhà hàng, hồ bơi và sảnh đều nhanh. Phù hợp cặp đôi muốn phòng yên, có chút không gian ngoài trời mà chưa cần nâng hạng suite.'),
('202', 3, 'Available', 'Phòng 202 là Deluxe Suite khoảng 40m², tách biệt khu ngủ và khu tiếp khách. Giường king size, sofa 2 chỗ, bàn trà, tivi 43 inch và minibar. Cửa kính lớn giúp căn phòng sáng, view hướng khuôn viên khách sạn. Phòng tắm rộng có bồn tắm nằm, vòi sen riêng, gương đèn LED và bộ amenities cao cấp. Tủ quần áo walk-in nhỏ, bàn làm việc, két sắt và máy pha cà phê viên nén. Wifi mạnh, điều hòa từng khu, rèm blackout giúp ngủ sâu. Sức chứa tối đa 3 khách, có thể thêm giường phụ cho trẻ em theo yêu cầu. Phù hợp gia đình nhỏ, cặp đôi kỷ niệm hoặc khách muốn không gian rộng hơn phòng tiêu chuẩn.'),
('203', 3, 'Booked', 'Phòng 203 Deluxe tầng 2, diện tích khoảng 42m², cách ly tiếng ồn tốt nhờ hành lang ít phòng. Khu ngủ giường king, khu khách sofa dài, bàn trà và kệ trang trí. Phòng tắm có bồn ngâm, vòi sen, khăn lớn, áo choàng tắm và dép bông. Tiện nghi gồm smart TV, wifi, điều hòa, minibar, ấm đun, máy sấy và bàn ủi hơi nước. View nhìn ra khoảng xanh, ban ngày thoáng, tối dịu ánh đèn vườn. Nhân viên có thể dọn phòng 2 lần/ngày nếu khách đăng ký. Phù hợp cặp đôi muốn thư giãn, khách lưu trú 3-4 đêm hoặc gia đình 2 người lớn kèm 1 trẻ. Trải nghiệm cao cấp hơn phòng đôi thường, gần mức VIP nhưng giá dễ chịu hơn.'),
('301', 4, 'Booked', 'Phòng 301 là hạng VIP Ocean View tại tầng 3, diện tích khoảng 55m², cửa kính lớn từ sàn tới trần nhìn ra biển. Ban công rộng kê bàn ghế, thích hợp ngắm bình minh, uống trà chiều hoặc chụp ảnh. Bên trong gồm giường king, sofa bed cho 2 người thêm, sức chứa tối đa 4 khách. Phòng tắm kính trong có bồn jacuzzi, vòi sen mưa, máy sấy, áo choàng và đồ dùng cao cấp. Minibar đầy đủ, máy pha cà phê, smart TV 55 inch, loa bluetooth, két sắt và wifi tốc độ cao. Nội thất gỗ sáng, ánh sáng ấm, rèm tự động hai lớp. Phù hợp gia đình, nhóm bạn hoặc kỳ nghỉ đặc biệt khi muốn view biển và không gian sang trọng.'),
('302', 4, 'Available', 'Phòng 302 VIP tầng 3, view biển thoáng đãng cả ngày, diện tích khoảng 52m². Bố trí giường king, khu sinh hoạt với sofa góc, bàn ăn nhỏ 4 chỗ và minibar. Ban công riêng hướng biển, có ghế nằm thư giãn. Phòng tắm lớn với bồn massage, vòi sen riêng, gương trang điểm đèn vàng và bộ amenities nhập. Tiện nghi gồm smart TV, wifi mesh, điều hòa êm, máy pha cà phê, ấm đun, bàn ủi và két an toàn. Ánh sáng tự nhiên rất tốt nhờ kính lớn, đêm có đèn vàng tạo không khí nghỉ dưỡng. Phù hợp cặp đôi kỷ niệm, gia đình 3-4 người hoặc khách muốn kỳ nghỉ cao cấp mà vẫn gần thang máy và quầy lễ tân tầng trệt.'),
('303', 4, 'Maintenance', 'Phòng 303 VIP Ocean View là một trong những phòng rộng nhất, khoảng 58m², thiết kế khu ngủ - khu khách - ban công biển tách bạch. Giường lớn, sofa bed, bàn làm việc và hệ thống loa giải trí. Phòng tắm cao cấp có jacuzzi nhìn ra một phần view, vòi sen, máy sấy và đồ dùng xịn. Minibar, máy pha cà phê, smart TV, wifi tốc độ cao, điều hòa và rèm cản sáng đầy đủ. Hiện phòng đang được bảo trì nội thất, thay ga drap, kiểm tra bồn massage và sơn lại tường để đảm bảo tiêu chuẩn VIP khi mở cửa trở lại. Khi sẵn sàng, đây sẽ là lựa chọn hàng đầu cho gia đình hoặc nhóm 4 người muốn view biển, không gian rộng và tiện nghi đầy đủ nhất tại khách sạn.');

-- 6. Dữ liệu mẫu cho bảng Bookings (10 đơn đặt phòng)
INSERT INTO Bookings (CustomerID, RoomID, CheckInDate, CheckOutDate, TotalPrice, Status) VALUES
(4, 1, '2026-10-01', '2026-10-03', 1000000.00, 'Completed'),
(5, 3, '2026-10-05', '2026-10-07', 1600000.00, 'Confirmed'),
(6, 5, '2026-10-10', '2026-10-12', 1600000.00, 'Confirmed'),
(7, 7, '2026-10-15', '2026-10-18', 4500000.00, 'Confirmed'),
(8, 8, '2026-10-20', '2026-10-22', 5000000.00, 'Pending'),
(9, 2, '2026-11-01', '2026-11-02', 500000.00, 'Cancelled'),
(10, 4, '2026-11-03', '2026-11-05', 1600000.00, 'Completed'),
(11, 6, '2026-11-10', '2026-11-13', 4500000.00, 'Confirmed'),
(12, 9, '2026-11-15', '2026-11-17', 5000000.00, 'Pending'),
(13, 10, '2026-11-20', '2026-11-22', 5000000.00, 'Cancelled');

-- 7. Dữ liệu mẫu cho bảng Payments (10 giao dịch tương ứng)
INSERT INTO Payments (BookingID, Amount, PaymentMethod, Status, ProcessedBy) VALUES
(1, 1000000.00, 'Credit Card', 'Success', NULL),
(2, 1600000.00, 'Cash', 'Success', 2),
(3, 1600000.00, 'Momo', 'Success', NULL),
(4, 4500000.00, 'Bank Transfer', 'Success', 3),
(5, 5000000.00, 'Credit Card', 'Pending', NULL),
(6, 5000000.00, 'Bank Transfer', 'Failed', NULL),
(7, 1600000.00, 'Cash', 'Success', 2),
(8, 4500000.00, 'Credit Card', 'Success', NULL),
(9, 5000000.00, 'Momo', 'Pending', NULL),
(10, 5000000.00, 'Cash', 'Failed', 3);
