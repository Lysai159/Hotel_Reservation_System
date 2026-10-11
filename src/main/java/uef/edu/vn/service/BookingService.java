package uef.edu.vn.service;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import uef.edu.vn.constant.BookingStatus;
import uef.edu.vn.constant.RoomStatus;
import uef.edu.vn.exception.ValidationException;
import uef.edu.vn.model.Booking;
import uef.edu.vn.model.Room;
import uef.edu.vn.model.RoomType;
import uef.edu.vn.repository.BookingRepository;
import uef.edu.vn.repository.RoomRepository;

@Service
public class BookingService {

    @Autowired
    private BookingRepository bookingRepository;

    @Autowired
    private RoomRepository roomRepository;

    public List<Booking> findAll() {
        return bookingRepository.findAll();
    }

    public Booking findById(int bookingId) {
        return bookingRepository.findById(bookingId);
    }

    public List<Booking> findByCustomerId(int customerId) {
        return bookingRepository.findByCustomerId(customerId);
    }

    public List<Booking> findByStatus(String status) {
        return bookingRepository.findByStatus(status);
    }

    public boolean isRoomAvailable(Integer roomId, LocalDate checkIn, LocalDate checkOut) {
        return bookingRepository.isRoomAvailable(roomId, checkIn, checkOut);
    }

    public long calculateTotalNights(LocalDate checkIn, LocalDate checkOut) {
        return ChronoUnit.DAYS.between(checkIn, checkOut);
    }

    public BigDecimal calculateTotalAmount(long totalNights, BigDecimal basePrice) {
        return basePrice.multiply(BigDecimal.valueOf(totalNights));
    }

    public boolean createBooking(Booking booking) {
        try {
            validateBookingDates(booking.getCheckInDate(), booking.getCheckOutDate());

            if (booking.getRoom() == null || booking.getRoom().getRoomId() == null) {
                throw new ValidationException("Vui lòng chọn phòng.");
            }

            Room room = roomRepository.findById(booking.getRoom().getRoomId());
            if (room == null) {
                throw new ValidationException("Phòng không tồn tại.");
            }
            if (RoomStatus.MAINTENANCE.equalsIgnoreCase(room.getStatus())) {
                throw new ValidationException("Phòng đang bảo trì, không thể đặt.");
            }

            // Trùng lịch: ExistingCheckIn < NewCheckOut AND ExistingCheckOut > NewCheckIn
            if (!isRoomAvailable(room.getRoomId(), booking.getCheckInDate(), booking.getCheckOutDate())) {
                throw new ValidationException("Phòng đã được đặt trong khoảng thời gian này.");
            }

            RoomType roomType = room.getRoomType();
            if (roomType == null || roomType.getBasePrice() == null) {
                throw new ValidationException("Phòng chưa có loại/giá cơ bản.");
            }

            long totalNights = calculateTotalNights(booking.getCheckInDate(), booking.getCheckOutDate());
            booking.setRoom(room);
            booking.setTotalAmount(calculateTotalAmount(totalNights, roomType.getBasePrice()));
            booking.setStatus(BookingStatus.PENDING);

            int saved = bookingRepository.save(booking);
            if (saved <= 0 || booking.getBookingId() == null) {
                throw new ValidationException("Không thể tạo đơn đặt phòng. Vui lòng thử lại.");
            }
            return true;
        } catch (ValidationException ex) {
            throw ex;
        } catch (Exception ex) {
            throw new ValidationException("Không thể tạo đơn đặt phòng. Vui lòng thử lại.");
        }
    }

    public boolean confirmBooking(int bookingId) {
        Booking booking = requireBooking(bookingId);
        if (!BookingStatus.PENDING.equalsIgnoreCase(booking.getStatus())) {
            throw new ValidationException("Chỉ xác nhận được đơn đang chờ xử lý.");
        }
        return bookingRepository.updateStatus(bookingId, BookingStatus.CONFIRMED) > 0;
    }

    public boolean checkIn(int bookingId) {
        Booking booking = requireBooking(bookingId);
        if (!BookingStatus.CONFIRMED.equalsIgnoreCase(booking.getStatus())) {
            throw new ValidationException("Chỉ nhận phòng với đơn đã xác nhận.");
        }
        boolean updated = bookingRepository.updateStatus(bookingId, BookingStatus.CHECKED_IN) > 0;
        if (updated && booking.getRoom() != null) {
            roomRepository.updateStatus(booking.getRoom().getRoomId(), RoomStatus.OCCUPIED);
        }
        return updated;
    }

    public boolean checkOut(int bookingId) {
        Booking booking = requireBooking(bookingId);
        if (!BookingStatus.CHECKED_IN.equalsIgnoreCase(booking.getStatus())) {
            throw new ValidationException("Chỉ trả phòng với đơn đang check-in.");
        }
        boolean updated = bookingRepository.updateStatus(bookingId, BookingStatus.CHECKED_OUT) > 0;
        if (updated && booking.getRoom() != null) {
            roomRepository.updateStatus(booking.getRoom().getRoomId(), RoomStatus.AVAILABLE);
        }
        return updated;
    }

    public boolean cancelBooking(int bookingId) {
        Booking booking = requireBooking(bookingId);
        String current = booking.getStatus();
        if (BookingStatus.CHECKED_OUT.equalsIgnoreCase(current)
                || BookingStatus.CANCELLED.equalsIgnoreCase(current)) {
            throw new ValidationException("Không thể hủy đơn này.");
        }

        boolean updated = bookingRepository.updateStatus(bookingId, BookingStatus.CANCELLED) > 0;
        if (updated && booking.getRoom() != null
                && (BookingStatus.CHECKED_IN.equalsIgnoreCase(current)
                || RoomStatus.OCCUPIED.equalsIgnoreCase(booking.getRoom().getStatus()))) {
            roomRepository.updateStatus(booking.getRoom().getRoomId(), RoomStatus.AVAILABLE);
        }
        return updated;
    }

    public boolean update(Booking booking) {
        return bookingRepository.update(booking) > 0;
    }

    public boolean delete(int bookingId) {
        return bookingRepository.delete(bookingId) > 0;
    }

    private Booking requireBooking(int bookingId) {
        Booking booking = bookingRepository.findById(bookingId);
        if (booking == null) {
            throw new ValidationException("Đơn đặt phòng không tồn tại.");
        }
        return booking;
    }

    public void validateBookingDates(LocalDate checkIn, LocalDate checkOut) {
        if (checkIn == null || checkOut == null) {
            throw new ValidationException("Vui lòng chọn ngày nhận và trả phòng.");
        }
        if (checkIn.isBefore(LocalDate.now())) {
            throw new ValidationException("Ngày nhận phòng phải từ hôm nay trở đi.");
        }
        if (!checkOut.isAfter(checkIn)) {
            throw new ValidationException("Ngày trả phòng phải sau ngày nhận phòng.");
        }
    }
}
