# Hotel Reservation System (Java)

Web application for hotel room search, booking, cart, and payment — **Spring MVC**, **JSP**, **MySQL**.

## Requirements

- JDK 17+
- Apache Maven 3.8+
- MySQL 8+
- Apache Tomcat 10+

## Database

Import `Database.sql` into MySQL, then apply scripts under `src/main/resources/` if needed (`schema-update.sql`, seeds).

Configure JDBC in `src/main/resources/META-INF/persistence.xml` and `src/main/webapp/META-INF/context.xml`.

## Build & run

```bash
mvn clean package
```

Deploy `target/Hotel_Reservation_System-1.0-SNAPSHOT.war` to Tomcat, or run from your IDE (NetBeans / IntelliJ).

## Project layout

- `src/main/java/uef/edu/vn/` — controllers, services, repositories, models
- `src/main/webapp/WEB-INF/views/` — JSP views
- `pom.xml` — Maven dependencies (Spring 6, MySQL, JSTL, …)
