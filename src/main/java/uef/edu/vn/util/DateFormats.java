package uef.edu.vn.util;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;

public final class DateFormats {

    public static final DateTimeFormatter VN = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    private DateFormats() {
    }

    public static LocalDate parse(String text) {
        if (text == null) {
            return null;
        }
        String value = text.trim();
        if (value.isEmpty()) {
            return null;
        }
        try {
            if (value.matches("\\d{1,2}/\\d{1,2}/\\d{4}")) {
                String[] parts = value.split("/");
                int day = Integer.parseInt(parts[0]);
                int month = Integer.parseInt(parts[1]);
                int year = Integer.parseInt(parts[2]);
                return LocalDate.of(year, month, day);
            }
            return LocalDate.parse(value);
        } catch (DateTimeParseException | IllegalArgumentException ex) {
            return null;
        }
    }

    public static String iso(LocalDate date) {
        return date == null ? "" : date.toString();
    }

    public static String vn(LocalDate date) {
        return date == null ? "" : date.format(VN);
    }
}
