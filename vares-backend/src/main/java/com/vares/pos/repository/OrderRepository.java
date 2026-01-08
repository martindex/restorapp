package com.vares.pos.repository;

import com.vares.pos.model.entity.Order;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface OrderRepository extends JpaRepository<Order, String> {
    List<Order> findByTableId(String tableId);

    List<Order> findByWaiterId(String waiterId);

    List<Order> findByStatus(Order.OrderStatus status);

    @Query("SELECT o FROM Order o WHERE o.table.id = :tableId AND o.status != 'CLOSED'")
    Optional<Order> findActiveOrderByTableId(@Param("tableId") String tableId);

    @Query("SELECT o FROM Order o WHERE o.status != 'CLOSED'")
    List<Order> findAllActiveOrders();

    @Query("SELECT o FROM Order o WHERE o.openedAt >= :startDate AND o.closedAt <= :endDate AND o.status = 'CLOSED'")
    List<Order> findClosedOrdersBetweenDates(@Param("startDate") LocalDateTime startDate,
            @Param("endDate") LocalDateTime endDate);
}
