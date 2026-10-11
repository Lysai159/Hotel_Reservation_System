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
import uef.edu.vn.model.RoomAmenity;

@Repository
public class RoomAmenityRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public List<RoomAmenity> findAll() {
        String sql = "SELECT TypeID as typeId, AmenityID as amenityId FROM RoomTypeAmenities";
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(RoomAmenity.class));
    }

    public int save(int typeId, int amenityId) {
        String sql = "INSERT INTO RoomTypeAmenities (TypeID, AmenityID) VALUES (?, ?)";
        return jdbcTemplate.update(sql, typeId, amenityId);
    }

    public int delete(int typeId, int amenityId) {
        String sql = "DELETE FROM RoomTypeAmenities WHERE TypeID = ? AND AmenityID = ?";
        return jdbcTemplate.update(sql, typeId, amenityId);
    }
}