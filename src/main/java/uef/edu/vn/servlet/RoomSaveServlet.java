package uef.edu.vn.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.IOException;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;
import org.springframework.web.multipart.MultipartFile;
import uef.edu.vn.exception.ValidationException;
import uef.edu.vn.model.Customer;
import uef.edu.vn.model.Room;
import uef.edu.vn.model.RoomType;
import uef.edu.vn.service.RoomService;
import uef.edu.vn.service.RoomTypeService;
import uef.edu.vn.util.ServletPartMultipartFile;

public class RoomSaveServlet extends HttpServlet {

    private WebApplicationContext springContext() {
        WebApplicationContext root = WebApplicationContextUtils.getWebApplicationContext(getServletContext());
        if (root != null) {
            return root;
        }
        return WebApplicationContextUtils.getWebApplicationContext(
                getServletContext(),
                "org.springframework.web.servlet.FrameworkServlet.CONTEXT.dispatcher");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        Customer user = session == null ? null : (Customer) session.getAttribute("currentUser");
        if (user == null || user.getRoleId() == null || user.getRoleId() != 1) {
            response.sendRedirect(request.getContextPath() + "/customer/login");
            return;
        }

        WebApplicationContext ctx = springContext();
        RoomService roomService = ctx.getBean(RoomService.class);
        RoomTypeService roomTypeService = ctx.getBean(RoomTypeService.class);

        Room room = new Room();
        String roomIdRaw = request.getParameter("roomId");
        if (roomIdRaw != null && !roomIdRaw.isBlank()) {
            room.setRoomId(Integer.valueOf(roomIdRaw.trim()));
        }
        room.setRoomNumber(request.getParameter("roomNumber"));
        room.setStatus(request.getParameter("status"));
        room.setDescription(request.getParameter("description"));

        String typeIdRaw = request.getParameter("typeId");
        if (typeIdRaw != null && !typeIdRaw.isBlank()) {
            RoomType type = new RoomType();
            type.setTypeId(Integer.valueOf(typeIdRaw.trim()));
            room.setRoomType(type);
        }

        MultipartFile imageFile = null;
        try {
            Part part = request.getPart("imageFile");
            if (part != null && part.getSize() > 0) {
                imageFile = new ServletPartMultipartFile(part);
            }
        } catch (Exception ignored) {
            // Không có file ảnh thì vẫn lưu thông tin phòng.
        }

        try {
            roomService.saveRoom(room, imageFile);
            response.sendRedirect(request.getContextPath() + "/admin/room/edit/" + room.getRoomId());
        } catch (ValidationException ex) {
            request.setAttribute("error", ex.getMessage());
            request.setAttribute("room", room);
            request.setAttribute("roomTypes", roomTypeService.findAll());
            request.getRequestDispatcher("/WEB-INF/views/rooms/form.jsp").forward(request, response);
        }
    }
}
