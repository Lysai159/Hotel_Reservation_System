package uef.edu.vn.controller;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import uef.edu.vn.util.FileUploadUtil;

@Controller
public class RoomImageController {

    @Autowired
    private FileUploadUtil fileUploadUtil;

    @GetMapping("/uploads/rooms/{fileName}")
    public ResponseEntity<byte[]> serveByFileName(@PathVariable("fileName") String fileName) throws IOException {
        Path file = fileUploadUtil.resolveExistingFile(fileName);
        if (file == null) {
            return ResponseEntity.notFound().build();
        }
        String contentType = Files.probeContentType(file);
        return ResponseEntity.ok()
                .header("Cache-Control", "no-store")
                .contentType(MediaType.parseMediaType(contentType != null ? contentType : "image/jpeg"))
                .body(Files.readAllBytes(file));
    }
}
