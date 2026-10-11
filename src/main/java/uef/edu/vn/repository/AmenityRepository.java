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
import uef.edu.vn.model.Amenity;

@Repository
public class AmenityRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public List<Amenity> findAll() {
        String sql = "SELECT AmenityID as amenityId, AmenityName as amenityName, Description as description FROM Amenities ORDER BY AmenityID";
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(Amenity.class));
    }

    public Amenity findById(int amenityId) {
        String sql = "SELECT AmenityID as amenityId, AmenityName as amenityName, Description as description FROM Amenities WHERE AmenityID = ?";
        List<Amenity> list = jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(Amenity.class), amenityId);
        return list.isEmpty() ? null : list.get(0);
    }

    public int save(Amenity amenity) {
        String sql = "INSERT INTO Amenities (AmenityName, Description) VALUES (?, ?)";
        return jdbcTemplate.update(sql, amenity.getAmenityName(), amenity.getDescription());
    }

    public int update(Amenity amenity) {
        String sql = "UPDATE Amenities SET AmenityName = ?, Description = ? WHERE AmenityID = ?";
        return jdbcTemplate.update(sql, amenity.getAmenityName(), amenity.getDescription(), amenity.getAmenityId());
    }

    public int delete(int amenityId) {
        String sql = "DELETE FROM Amenities WHERE AmenityID = ?";
        return jdbcTemplate.update(sql, amenityId);
    }
}