package uef.edu.vn.service;

import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.time.LocalDate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import uef.edu.vn.constant.RoomStatus;
import uef.edu.vn.exception.ValidationException;
import uef.edu.vn.model.Booking;
import uef.edu.vn.model.Cart;
import uef.edu.vn.model.CartItem;
import uef.edu.vn.model.Customer;
import uef.edu.vn.model.Payment;
import uef.edu.vn.model.Room;
import uef.edu.vn.model.RoomType;

@Service
public class CartService {

    public static final String SESSION_KEY = "cart";

    @Autowired
    private RoomService roomService;

    @Autowired
    private BookingService bookingService;

    @Autowired
    private PaymentService paymentService;

    public Cart getOrCreate(HttpSession session) {
        Cart cart = (Cart) session.getAttribute(SESSION_KEY);
        if (cart == null) {
            cart = new Cart();
            session.setAttribute(SESSION_KEY, cart);
        }
        return cart;
    }

    public CartItem addRoom(HttpSession session, int roomId, LocalDate checkIn, LocalDate checkOut) {
        bookingService.validateBookingDates(checkIn, checkOut);

        Room room = roomService.findById(roomId);
        if (room == null) {
            throw new ValidationException("Phòng không tồn tại.");
        }
        if (RoomStatus.MAINTENANCE.equalsIgnoreCase(room.getStatus())) {
            throw new ValidationException("Phòng đang bảo trì, không thể đặt.");
        }
        if (!bookingService.isRoomAvailable(roomId, checkIn, checkOut)) {
            throw new ValidationException("Phòng đã được đặt trong khoảng thời gian này.");
        }

        RoomType roomType = room.getRoomType();
        if (roomType == null || roomType.getBasePrice() == null) {
            throw new ValidationException("Phòng chưa có loại/giá cơ bản.");
        }

        Cart cart = getOrCreate(session);
        for (CartItem existing : cart.getItems()) {
            if (roomId == existing.getRoomId()
                    && existing.getCheckInDate().isBefore(checkOut)
                    && existing.getCheckOutDate().isAfter(checkIn)) {
                throw new ValidationException("Phòng này đã có trong giỏ với lịch trùng.");
            }
        }

        long nights = bookingService.calculateTotalNights(checkIn, checkOut);
        BigDecimal total = bookingService.calculateTotalAmount(nights, roomType.getBasePrice());

        CartItem item = new CartItem();
        item.setRoomId(room.getRoomId());
        item.setRoomNumber(room.getRoomNumber());
        item.setTypeName(roomType.getTypeName());
        item.setImageUrl(room.getImageUrl());
        item.setCheckInDate(checkIn);
        item.setCheckOutDate(checkOut);
        item.setNights(nights);
        item.setPricePerNight(roomType.getBasePrice());
        item.setTotalAmount(total);
        cart.addItem(item);
        return item;
    }

    public void removeItem(HttpSession session, String itemId) {
        getOrCreate(session).removeItem(itemId);
    }

    public void checkout(HttpSession session, Customer customer, String paymentMethod) {
        Cart cart = getOrCreate(session);
        if (cart.isEmpty()) {
            throw new ValidationException("Giỏ hàng đang trống.");
        }
        if (paymentMethod == null || paymentMethod.isBlank()) {
            throw new ValidationException("Vui lòng chọn phương thức thanh toán.");
        }

        for (CartItem item : cart.getItems()) {
            if (!bookingService.isRoomAvailable(item.getRoomId(), item.getCheckInDate(), item.getCheckOutDate())) {
                throw new ValidationException("Phòng " + item.getRoomNumber() + " không còn trống cho ngày đã chọn.");
            }
        }

        for (CartItem item : cart.getItems()) {
            Booking booking = new Booking();
            booking.setCustomer(customer);
            Room room = new Room();
            room.setRoomId(item.getRoomId());
            booking.setRoom(room);
            booking.setCheckInDate(item.getCheckInDate());
            booking.setCheckOutDate(item.getCheckOutDate());
            bookingService.createBooking(booking);

            Payment payment = new Payment();
            payment.setBooking(booking);
            payment.setAmount(booking.getTotalPrice());
            payment.setPaymentMethod(paymentMethod);
            payment.setProcessedBy(customer);
            paymentService.processPayment(payment);
        }
        cart.clear();
    }
}
