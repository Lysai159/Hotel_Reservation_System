package uef.edu.vn.config;

import java.time.LocalDate;
import org.springframework.core.convert.converter.Converter;
import uef.edu.vn.util.DateFormats;

public class StringToLocalDateConverter implements Converter<String, LocalDate> {

    @Override
    public LocalDate convert(String source) {
        return DateFormats.parse(source);
    }
}
