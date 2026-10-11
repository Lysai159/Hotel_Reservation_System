-- Thêm cột mô tả cho từng phòng (chạy an toàn nhiều lần)
SET @col_exists := (
    SELECT COUNT(*)
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'Rooms'
      AND COLUMN_NAME = 'Description'
);

SET @sql := IF(
    @col_exists = 0,
    'ALTER TABLE Rooms ADD COLUMN Description TEXT NULL',
    'SELECT ''Rooms.Description already exists'' AS info'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
