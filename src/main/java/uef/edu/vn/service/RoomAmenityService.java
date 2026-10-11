/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package uef.edu.vn.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import uef.edu.vn.model.RoomAmenity;
import uef.edu.vn.repository.RoomAmenityRepository;

@Service
public class RoomAmenityService {

    @Autowired
    private RoomAmenityRepository roomAmenityRepository;

    public List<RoomAmenity> findAll() {
        return roomAmenityRepository.findAll();
    }

    public boolean addAmenityToRoomType(int typeId, int amenityId) {
        return roomAmenityRepository.save(typeId, amenityId) > 0;
    }

    public boolean removeAmenityFromRoomType(int typeId, int amenityId) {
        return roomAmenityRepository.delete(typeId, amenityId) > 0;
    }
}