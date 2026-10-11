-- Bỏ cột đường dẫn ảnh: ảnh lấy từ thư mục uploads/rooms theo mã phòng.
-- Giữ cột mô tả từng phòng.

SET @img_exists := (
    SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'Rooms' AND COLUMN_NAME = 'ImageUrl'
);
SET @sql := IF(@img_exists > 0, 'ALTER TABLE Rooms DROP COLUMN ImageUrl', 'SELECT ''Rooms.ImageUrl already removed'' AS info');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @desc_exists := (
    SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'Rooms' AND COLUMN_NAME = 'Description'
);
SET @sql := IF(@desc_exists = 0, 'ALTER TABLE Rooms ADD COLUMN Description TEXT NULL', 'SELECT ''Rooms.Description already exists'' AS info');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
