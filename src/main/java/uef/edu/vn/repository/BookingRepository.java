package uef.edu.vn.repository;

import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDate;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;
import uef.edu.vn.constant.BookingStatus;
import uef.edu.vn.model.Booking;
import uef.edu.vn.model.Customer;
import uef.edu.vn.model.Room;
import uef.edu.vn.model.RoomType;

@Repository
public class BookingRepository {

    private static final String BASE_SELECT = """
            SELECT b.BookingID, b.CustomerID, b.RoomID, b.CheckInDate, b.CheckOutDate,
                   b.TotalPrice, b.Status, b.CreatedAt,
                   r.RoomNumber, r.Status AS RoomStatus, r.Description AS RoomDescription,
                   t.TypeName, t.BasePrice,
                   u.FullName, u.Email, u.PhoneNumber
            FROM Bookings b
            LEFT JOIN Rooms r ON b.RoomID = r.RoomID
            LEFT JOIN RoomTypes t ON r.TypeID = t.TypeID
            LEFT JOIN Users u ON b.CustomerID = u.UserID
            """;

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public List<Booking> findAll() {
        return jdbcTemplate.query(BASE_SELECT + " ORDER BY b.BookingID", new BookingRowMapper());
    }

    public Booking findById(int bookingId) {
        List<Booking> list = jdbcTemplate.query(
                BASE_SELECT + " WHERE b.BookingID = ?",
                new BookingRowMapper(),
                bookingId);
        return list.isEmpty() ? null : list.get(0);
    }

    public Integer findRoomIdByBookingId(int bookingId) {
        List<Integer> ids = jdbcTemplate.query(
                "SELECT RoomID FROM Bookings WHERE BookingID = ?",
                (rs, rowNum) -> rs.getInt("RoomID"),
                bookingId);
        return ids.isEmpty() ? null : ids.get(0);
    }

    public List<Booking> findByCustomerId(int customerId) {
        return jdbcTemplate.query(
                BASE_SELECT + " WHERE b.CustomerID = ? ORDER BY b.BookingID DESC",
                new BookingRowMapper(),
                customerId);
    }

    public List<Booking> findByStatus(String status) {
        return jdbcTemplate.query(
                BASE_SELECT + " WHERE b.Status = ? ORDER BY b.BookingID",
                new BookingRowMapper(),
                status);
    }

    /**
     * Phòng trống khi KHÔNG tồn tại đơn CONFIRMED/CHECKED_IN bị chồng ngày.
     * Công thức: ExistingCheckIn < NewCheckOut AND ExistingCheckOut > NewCheckIn
     */
    public boolean isRoomAvailable(Integer roomId, LocalDate checkIn, LocalDate checkOut) {
        String sql = """
                SELECT COUNT(*) FROM Bookings
                WHERE RoomID = ?
                  AND UPPER(Status) IN (?, ?)
                  AND CheckInDate < ?
                  AND CheckOutDate > ?
                """;
        Integer count = jdbcTemplate.queryForObject(
                sql,
                Integer.class,
                roomId,
                BookingStatus.CONFIRMED,
                BookingStatus.CHECKED_IN,
                Date.valueOf(checkOut),
                Date.valueOf(checkIn));
        return count == null || count == 0;
    }

    public int save(Booking booking) {
        String sql = "INSERT INTO Bookings (CustomerID, RoomID, CheckInDate, CheckOutDate, TotalPrice, Status) VALUES (?, ?, ?, ?, ?, ?)";
        KeyHolder keyHolder = new GeneratedKeyHolder();
        int rows = jdbcTemplate.update(connection -> {
            PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, booking.getCustomer().getUserId());
            ps.setInt(2, booking.getRoom().getRoomId());
            ps.setDate(3, Date.valueOf(booking.getCheckInDate()));
            ps.setDate(4, Date.valueOf(booking.getCheckOutDate()));
            ps.setBigDecimal(5, booking.getTotalPrice());
            ps.setString(6, booking.getStatus());
            return ps;
        }, keyHolder);
        Number key = keyHolder.getKey();
        if (key != null) {
            booking.setBookingId(key.intValue());
        }
        return rows;
    }

    public int update(Booking booking) {
        String sql = "UPDATE Bookings SET CustomerID = ?, RoomID = ?, CheckInDate = ?, CheckOutDate = ?, TotalPrice = ?, Status = ? WHERE BookingID = ?";
        return jdbcTemplate.update(
                sql,
                booking.getCustomer().getUserId(),
                booking.getRoom().getRoomId(),
                Date.valueOf(booking.getCheckInDate()),
                Date.valueOf(booking.getCheckOutDate()),
                booking.getTotalPrice(),
                booking.getStatus(),
                booking.getBookingId());
    }

    public int updateStatus(int bookingId, String status) {
        return jdbcTemplate.update("UPDATE Bookings SET Status = ? WHERE BookingID = ?", status, bookingId);
    }

    public int delete(int bookingId) {
        return jdbcTemplate.update("DELETE FROM Bookings WHERE BookingID = ?", bookingId);
    }

    private static class BookingRowMapper implements RowMapper<Booking> {
        @Override
        public Booking mapRow(ResultSet rs, int rowNum) throws SQLException {
            Booking booking = new Booking();
            booking.setBookingId(rs.getInt("BookingID"));
            Date checkIn = rs.getDate("CheckInDate");
            Date checkOut = rs.getDate("CheckOutDate");
            booking.setCheckInDate(checkIn == null ? null : checkIn.toLocalDate());
            booking.setCheckOutDate(checkOut == null ? null : checkOut.toLocalDate());
            booking.setTotalPrice(rs.getBigDecimal("TotalPrice"));
            booking.setStatus(rs.getString("Status"));
            if (rs.getTimestamp("CreatedAt") != null) {
                booking.setCreatedAt(rs.getTimestamp("CreatedAt").toLocalDateTime());
            }

            Customer customer = new Customer();
            customer.setUserId(rs.getInt("CustomerID"));
            customer.setFullName(rs.getString("FullName"));
            customer.setEmail(rs.getString("Email"));
            customer.setPhoneNumber(rs.getString("PhoneNumber"));
            booking.setCustomer(customer);

            Room room = new Room();
            room.setRoomId(rs.getInt("RoomID"));
            room.setRoomNumber(rs.getString("RoomNumber"));
            room.setStatus(rs.getString("RoomStatus"));
            room.setDescription(rs.getString("RoomDescription"));
            String typeName = rs.getString("TypeName");
            if (typeName != null) {
                RoomType type = new RoomType();
                type.setTypeName(typeName);
                type.setBasePrice(rs.getBigDecimal("BasePrice"));
                room.setRoomType(type);
            }
            booking.setRoom(room);
            return booking;
        }
    }
}
