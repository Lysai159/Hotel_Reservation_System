/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package uef.edu.vn.repository;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;
import uef.edu.vn.model.RoomType;

@Repository
public class RoomTypeRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public List<RoomType> findAll() {
        String sql = "SELECT TypeID as typeId, TypeName as typeName, Description as description, BasePrice as basePrice, Capacity as capacity FROM RoomTypes ORDER BY TypeID";
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(RoomType.class));
    }

    public RoomType findById(int typeId) {
        String sql = "SELECT TypeID as typeId, TypeName as typeName, Description as description, BasePrice as basePrice, Capacity as capacity FROM RoomTypes WHERE TypeID = ?";
        List<RoomType> list = jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(RoomType.class), typeId);
        return list.isEmpty() ? null : list.get(0);
    }

    public int save(RoomType roomType) {
        String sql = "INSERT INTO RoomTypes (TypeName, Description, BasePrice, Capacity) VALUES (?, ?, ?, ?)";
        return jdbcTemplate.update(sql, roomType.getTypeName(), roomType.getDescription(), roomType.getBasePrice(), roomType.getCapacity());
    }

    public int update(RoomType roomType) {
        String sql = "UPDATE RoomTypes SET TypeName = ?, Description = ?, BasePrice = ?, Capacity = ? WHERE TypeID = ?";
        return jdbcTemplate.update(sql, roomType.getTypeName(), roomType.getDescription(), roomType.getBasePrice(), roomType.getCapacity(), roomType.getTypeId());
    }

    public int delete(int typeId) {
        String sql = "DELETE FROM RoomTypes WHERE TypeID = ?";
        return jdbcTemplate.update(sql, typeId);
    }
}