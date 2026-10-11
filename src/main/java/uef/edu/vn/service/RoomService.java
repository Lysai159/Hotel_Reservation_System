package uef.edu.vn.service;

import java.time.LocalDate;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import uef.edu.vn.constant.RoomStatus;
import uef.edu.vn.exception.ValidationException;
import uef.edu.vn.model.Room;
import uef.edu.vn.repository.BookingRepository;
import uef.edu.vn.repository.RoomRepository;
import uef.edu.vn.util.FileUploadUtil;

@Service
public class RoomService {

    @Autowired
    private RoomRepository roomRepository;

    @Autowired
    private BookingRepository bookingRepository;

    @Autowired
    private FileUploadUtil fileUploadUtil;

    public List<Room> findAll() {
        return attachImages(roomRepository.findAll());
    }

    public Room findById(int roomId) {
        return attachImage(roomRepository.findById(roomId));
    }

    public List<Room> searchAvailable(LocalDate checkIn, LocalDate checkOut,
                                      List<Integer> typeIds, Integer guests) {
        return findAll().stream()
                .filter(room -> RoomStatus.AVAILABLE.equalsIgnoreCase(room.getStatus()))
                .filter(room -> typeIds == null || typeIds.isEmpty()
                        || (room.getRoomType() != null && typeIds.contains(room.getRoomType().getTypeId())))
                .filter(room -> guests == null || guests <= 0
                        || (room.getRoomType() != null && room.getRoomType().getCapacity() != null
                        && room.getRoomType().getCapacity() >= guests))
                .filter(room -> {
                    if (checkIn == null || checkOut == null) {
                        return true;
                    }
                    return bookingRepository.isRoomAvailable(room.getRoomId(), checkIn, checkOut);
                })
                .toList();
    }

    public boolean saveRoom(Room room, MultipartFile imageFile) {
        try {
            if (room.getRoomNumber() == null || room.getRoomNumber().isBlank()) {
                throw new ValidationException("Số phòng không được để trống.");
            }
            if (room.getRoomType() == null || room.getRoomType().getTypeId() == null) {
                throw new ValidationException("Vui lòng chọn loại phòng.");
            }
            if (room.getStatus() == null || room.getStatus().isBlank()) {
                room.setStatus(RoomStatus.AVAILABLE);
            }

            boolean isNew = room.getRoomId() == null;
            if (isNew) {
                roomRepository.save(room);
                if (room.getRoomId() == null) {
                    throw new ValidationException("Không lấy được mã phòng sau khi lưu.");
                }
            } else {
                Room existing = roomRepository.findById(room.getRoomId());
                if (existing == null) {
                    throw new ValidationException("Phòng không tồn tại.");
                }
                if (room.getDescription() == null) {
                    room.setDescription(existing.getDescription());
                }
                roomRepository.update(room);
            }

            if (imageFile != null && hasOriginalName(imageFile) && imageFile.isEmpty()) {
                throw new ValidationException("Không đọc được file ảnh. Ảnh có thể vượt quá dung lượng cho phép (20MB).");
            }
            if (imageFile != null && !imageFile.isEmpty()) {
                String imageUrl = fileUploadUtil.saveRoomImage(imageFile, room.getRoomId());
                if (imageUrl == null || imageUrl.isBlank()) {
                    throw new ValidationException("Không thể lưu file ảnh phòng.");
                }
                room.setImageUrl(imageUrl);
            } else {
                attachImage(room);
            }
            return true;
        } catch (ValidationException ex) {
            throw ex;
        } catch (org.springframework.dao.DuplicateKeyException ex) {
            throw new ValidationException("Số phòng đã tồn tại. Vui lòng chọn số phòng khác.");
        } catch (Exception ex) {
            String message = ex.getMessage() == null ? "" : ex.getMessage();
            if (message.contains("Duplicate") || message.contains("UNIQUE")) {
                throw new ValidationException("Số phòng đã tồn tại. Vui lòng chọn số phòng khác.");
            }
            throw new ValidationException("Không thể lưu thông tin phòng: " + ex.getMessage());
        }
    }

    private boolean hasOriginalName(MultipartFile imageFile) {
        String name = imageFile.getOriginalFilename();
        return name != null && !name.isBlank();
    }

    public boolean createRoom(Room room) {
        return saveRoom(room, null);
    }

    public boolean updateStatus(int roomId, String status) {
        return roomRepository.updateStatus(roomId, status) > 0;
    }

    public boolean update(Room room) {
        return roomRepository.update(room) > 0;
    }

    public boolean delete(int roomId) {
        fileUploadUtil.deleteRoomImages(roomId);
        return roomRepository.delete(roomId) > 0;
    }

    private List<Room> attachImages(List<Room> rooms) {
        rooms.forEach(this::attachImage);
        return rooms;
    }

    private Room attachImage(Room room) {
        if (room != null) {
            room.setImageUrl(fileUploadUtil.findPublicUrl(room.getRoomId()));
        }
        return room;
    }
}
