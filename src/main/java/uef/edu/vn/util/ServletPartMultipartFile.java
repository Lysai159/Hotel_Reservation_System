package uef.edu.vn.util;

import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import org.springframework.web.multipart.MultipartFile;

public class ServletPartMultipartFile implements MultipartFile {

    private final Part part;

    public ServletPartMultipartFile(Part part) {
        this.part = part;
    }

    @Override
    public String getName() {
        return part.getName();
    }

    @Override
    public String getOriginalFilename() {
        String submitted = part.getSubmittedFileName();
        if (submitted == null || submitted.isBlank()) {
            return "";
        }
        int slash = Math.max(submitted.lastIndexOf('/'), submitted.lastIndexOf('\\'));
        return slash >= 0 ? submitted.substring(slash + 1) : submitted;
    }

    @Override
    public String getContentType() {
        return part.getContentType();
    }

    @Override
    public boolean isEmpty() {
        return part.getSize() <= 0;
    }

    @Override
    public long getSize() {
        return part.getSize();
    }

    @Override
    public byte[] getBytes() throws IOException {
        try (InputStream in = part.getInputStream()) {
            return in.readAllBytes();
        }
    }

    @Override
    public InputStream getInputStream() throws IOException {
        return part.getInputStream();
    }

    @Override
    public void transferTo(File dest) throws IOException {
        Files.createDirectories(dest.toPath().getParent());
        try (InputStream in = part.getInputStream()) {
            Files.copy(in, dest.toPath(), StandardCopyOption.REPLACE_EXISTING);
        }
    }
}
