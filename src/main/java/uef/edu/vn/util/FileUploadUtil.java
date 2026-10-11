package uef.edu.vn.util;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;
import uef.edu.vn.exception.ValidationException;

@Component
public class FileUploadUtil {

    public static final String PUBLIC_PATH_PREFIX = "/room/image/";
    private static final Path UPLOAD_DIR = Paths.get(
            "D:", "Hotel_Reservation_System", "src", "main", "webapp", "uploads", "rooms");

    public Path getUploadDir() {
        try {
            Files.createDirectories(UPLOAD_DIR);
        } catch (IOException ex) {
            throw new ValidationException("Không tạo được thư mục uploads/rooms: " + UPLOAD_DIR);
        }
        return UPLOAD_DIR;
    }

    public Path resolveExistingFile(String fileName) {
        if (fileName == null || fileName.isBlank()
                || fileName.contains("..") || fileName.contains("/") || fileName.contains("\\")) {
            return null;
        }
        Path dir = getUploadDir().toAbsolutePath().normalize();
        Path file = dir.resolve(fileName).normalize();
        if (!file.startsWith(dir) || !Files.isRegularFile(file)) {
            return null;
        }
        return file;
    }

    public String findPublicUrl(Integer roomId) {
        Path file = findRoomFile(roomId);
        if (file == null) {
            return null;
        }
        try {
            return PUBLIC_PATH_PREFIX + roomId + "?v=" + Files.getLastModifiedTime(file).toMillis();
        } catch (IOException ex) {
            return PUBLIC_PATH_PREFIX + roomId;
        }
    }

    public void deleteRoomImages(Integer roomId) {
        if (roomId == null) {
            return;
        }
        String[] extensions = {".jpg", ".jpeg", ".png", ".webp"};
        for (String ext : extensions) {
            try {
                Files.deleteIfExists(getUploadDir().resolve("room_" + roomId + ext));
            } catch (IOException ignored) {
            }
        }
    }

    /** Lưu đúng 1 file vào uploads/rooms: room_{id}.jpg|png|webp. Không copy thêm nơi khác, không lưu DB. */
    public String saveRoomImage(MultipartFile file, Integer roomId) {
        if (file == null || file.isEmpty()) {
            return null;
        }
        if (roomId == null) {
            throw new ValidationException("Không thể lưu ảnh vì chưa có mã phòng.");
        }

        String originalName = file.getOriginalFilename() == null ? "" : file.getOriginalFilename();
        String extension = resolveExtension(originalName, file.getContentType());
        String fileName = "room_" + roomId + extension;

        try {
            byte[] bytes = file.getBytes();
            if (bytes.length == 0) {
                throw new ValidationException("File ảnh trống. Vui lòng chọn ảnh khác.");
            }
            Path dir = getUploadDir();
            deleteRoomImages(roomId);
            Path saved = dir.resolve(fileName);
            Files.write(saved, bytes);
            return findPublicUrl(roomId);
        } catch (ValidationException ex) {
            throw ex;
        } catch (IOException ex) {
            throw new ValidationException("Không thể lưu ảnh vào uploads/rooms: " + ex.getMessage());
        }
    }

    public Path findRoomFile(Integer roomId) {
        if (roomId == null) {
            return null;
        }
        String[] extensions = {".jpg", ".jpeg", ".png", ".webp"};
        for (String ext : extensions) {
            Path file = getUploadDir().resolve("room_" + roomId + ext);
            if (Files.isRegularFile(file)) {
                return file;
            }
        }
        return null;
    }

    private String resolveExtension(String originalName, String contentType) {
        String lower = originalName.toLowerCase();
        if (lower.endsWith(".png") || "image/png".equalsIgnoreCase(contentType)) {
            return ".png";
        }
        if (lower.endsWith(".jpeg")) {
            return ".jpeg";
        }
        if (lower.endsWith(".webp") || "image/webp".equalsIgnoreCase(contentType)) {
            return ".webp";
        }
        return ".jpg";
    }
}
