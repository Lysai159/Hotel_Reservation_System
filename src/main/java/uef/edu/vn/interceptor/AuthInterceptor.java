package uef.edu.vn.interceptor;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.web.servlet.HandlerInterceptor;
import uef.edu.vn.model.Customer;

public class AuthInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {
        String contextPath = request.getContextPath();
        String path = request.getRequestURI().substring(contextPath.length());

        if (isPublic(path)) {
            return true;
        }

        HttpSession session = request.getSession(false);
        Customer user = session == null ? null : (Customer) session.getAttribute("currentUser");

        if (user == null) {
            HttpSession loginSession = request.getSession(true);
            if ("GET".equalsIgnoreCase(request.getMethod())) {
                String query = request.getQueryString();
                String target = path + (query == null || query.isBlank() ? "" : "?" + query);
                loginSession.setAttribute("redirectAfterLogin", target);
            }
            response.sendRedirect(contextPath + "/customer/login");
            return false;
        }

        if ((path.startsWith("/admin"))
                && (user.getRoleId() == null || user.getRoleId() != 1)) {
            response.sendRedirect(contextPath + "/room/list");
            return false;
        }

        if (path.startsWith("/booking/admin")
                && (user.getRoleId() == null || (user.getRoleId() != 1 && user.getRoleId() != 2))) {
            response.sendRedirect(contextPath + "/room/list");
            return false;
        }

        return true;
    }

    private boolean isPublic(String path) {
        return path.equals("/")
                || path.equals("/home")
                || path.startsWith("/customer/login")
                || path.startsWith("/customer/register")
                || path.startsWith("/room/")
                || path.startsWith("/resources/")
                || path.startsWith("/uploads/")
                || path.startsWith("/assets/");
    }
}
