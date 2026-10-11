/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package uef.edu.vn.model;

public class RoomAmenity {

    private RoomType roomType;
    private Amenity amenity;

    public RoomAmenity() {
    }

    public RoomAmenity(RoomType roomType, Amenity amenity) {
        this.roomType = roomType;
        this.amenity = amenity;
    }

    public RoomType getRoomType() {
        return roomType;
    }

    public void setRoomType(RoomType roomType) {
        this.roomType = roomType;
    }

    public Amenity getAmenity() {
        return amenity;
    }

    public void setAmenity(Amenity amenity) {
        this.amenity = amenity;
    }
}