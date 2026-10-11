package uef.edu.vn.servlet;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

public class RoomImageServlet extends HttpServlet {

    private static final Path UPLOAD_DIR = Paths.get(
            "D:", "Hotel_Reservation_System", "src", "main", "webapp", "uploads", "rooms");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String fileName = extractFileName(request);
        if (fileName == null || fileName.isBlank()
                || fileName.contains("..") || fileName.contains("/") || fileName.contains("\\")) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        Path dir = UPLOAD_DIR.toAbsolutePath().normalize();
        Path file = dir.resolve(fileName).normalize();
        if (!file.startsWith(dir) || !Files.isRegularFile(file)) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String contentType = Files.probeContentType(file);
        response.setContentType(contentType != null ? contentType : "image/jpeg");
        response.setHeader("Cache-Control", "no-store");
        Files.copy(file, response.getOutputStream());
    }

    private String extractFileName(HttpServletRequest request) {
        String uri = request.getRequestURI();
        if (uri != null) {
            String marker = "/uploads/rooms/";
            int idx = uri.indexOf(marker);
            if (idx >= 0) {
                String name = uri.substring(idx + marker.length());
                int slash = name.indexOf('/');
                if (slash >= 0) {
                    name = name.substring(0, slash);
                }
                return name;
            }
        }
        String pathInfo = request.getPathInfo();
        if (pathInfo != null && pathInfo.length() > 1) {
            return pathInfo.startsWith("/") ? pathInfo.substring(1) : pathInfo;
        }
        return null;
    }
}
