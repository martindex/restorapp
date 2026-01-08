package com.vares.pos.repository;

import com.vares.pos.model.entity.OrderItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface OrderItemRepository extends JpaRepository<OrderItem, String> {
    List<OrderItem> findByOrderId(String orderId);

    List<OrderItem> findByStatus(OrderItem.OrderItemStatus status);

    @Query("SELECT oi FROM OrderItem oi WHERE oi.type = 'FOOD' AND oi.status IN ('PENDING', 'IN_KITCHEN') ORDER BY oi.orderedAt ASC")
    List<OrderItem> findKitchenQueue();
}
