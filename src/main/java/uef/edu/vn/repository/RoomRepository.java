package uef.edu.vn.repository;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;
import uef.edu.vn.model.Room;
import uef.edu.vn.model.RoomType;

@Repository
public class RoomRepository {

    private static final String BASE_SELECT = """
            SELECT r.RoomID, r.RoomNumber, r.Status, r.TypeID, r.Description AS RoomDescription,
                   t.TypeName, t.Description, t.BasePrice, t.Capacity
            FROM Rooms r
            LEFT JOIN RoomTypes t ON r.TypeID = t.TypeID
            """;

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public List<Room> findAll() {
        return jdbcTemplate.query(BASE_SELECT + " ORDER BY r.RoomID", new RoomRowMapper());
    }

    public Room findById(int roomId) {
        List<Room> list = jdbcTemplate.query(BASE_SELECT + " WHERE r.RoomID = ?", new RoomRowMapper(), roomId);
        return list.isEmpty() ? null : list.get(0);
    }

    public List<Room> findByStatus(String status) {
        return jdbcTemplate.query(BASE_SELECT + " WHERE r.Status = ? ORDER BY r.RoomID", new RoomRowMapper(), status);
    }

    public int save(Room room) {
        String sql = "INSERT INTO Rooms (RoomNumber, TypeID, Status, Description) VALUES (?, ?, ?, ?)";
        KeyHolder keyHolder = new GeneratedKeyHolder();
        jdbcTemplate.update(connection -> {
            PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, room.getRoomNumber());
            ps.setInt(2, room.getRoomType().getTypeId());
            ps.setString(3, room.getStatus());
            ps.setString(4, room.getDescription());
            return ps;
        }, keyHolder);
        Number key = keyHolder.getKey();
        if (key == null && keyHolder.getKeys() != null && !keyHolder.getKeys().isEmpty()) {
            Object generated = keyHolder.getKeys().values().iterator().next();
            if (generated instanceof Number number) {
                key = number;
            }
        }
        if (key != null) {
            room.setRoomId(key.intValue());
        }
        return 1;
    }

    public int update(Room room) {
        String sql = "UPDATE Rooms SET RoomNumber = ?, TypeID = ?, Status = ?, Description = ? WHERE RoomID = ?";
        return jdbcTemplate.update(
                sql,
                room.getRoomNumber(),
                room.getRoomType().getTypeId(),
                room.getStatus(),
                room.getDescription(),
                room.getRoomId());
    }

    public int updateStatus(int roomId, String status) {
        return jdbcTemplate.update("UPDATE Rooms SET Status = ? WHERE RoomID = ?", status, roomId);
    }

    public int delete(int roomId) {
        return jdbcTemplate.update("DELETE FROM Rooms WHERE RoomID = ?", roomId);
    }

    private static class RoomRowMapper implements RowMapper<Room> {
        @Override
        public Room mapRow(ResultSet rs, int rowNum) throws SQLException {
            Room room = new Room();
            room.setRoomId(rs.getInt("RoomID"));
            room.setRoomNumber(rs.getString("RoomNumber"));
            room.setStatus(rs.getString("Status"));
            room.setDescription(rs.getString("RoomDescription"));

            int typeId = rs.getInt("TypeID");
            if (!rs.wasNull()) {
                RoomType type = new RoomType();
                type.setTypeId(typeId);
                type.setTypeName(rs.getString("TypeName"));
                type.setDescription(rs.getString("Description"));
                type.setBasePrice(rs.getBigDecimal("BasePrice"));
                type.setCapacity(rs.getInt("Capacity"));
                room.setRoomType(type);
            }
            return room;
        }
    }
}
