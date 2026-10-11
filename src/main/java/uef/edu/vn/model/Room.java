package uef.edu.vn.model;

public class Room {

    private Integer roomId;
    private String roomNumber;
    private RoomType roomType;
    private String status;
    /** Đường dẫn ảnh hiện tại, lấy từ file uploads/rooms — không lưu trong DB. */
    private String imageUrl;
    private String description;

    public Room() {
    }

    public Room(Integer roomId, String roomNumber, RoomType roomType, String status, String imageUrl, String description) {
        this.roomId = roomId;
        this.roomNumber = roomNumber;
        this.roomType = roomType;
        this.status = status;
        this.imageUrl = imageUrl;
        this.description = description;
    }

    public Integer getRoomId() {
        return roomId;
    }

    public void setRoomId(Integer roomId) {
        this.roomId = roomId;
    }

    public String getRoomNumber() {
        return roomNumber;
    }

    public void setRoomNumber(String roomNumber) {
        this.roomNumber = roomNumber;
    }

    public RoomType getRoomType() {
        return roomType;
    }

    public void setRoomType(RoomType roomType) {
        this.roomType = roomType;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getDisplayDescription() {
        if (description != null && !description.isBlank()) {
            return description;
        }
        if (roomType != null && roomType.getDescription() != null && !roomType.getDescription().isBlank()) {
            return roomType.getDescription();
        }
        return null;
    }
}
