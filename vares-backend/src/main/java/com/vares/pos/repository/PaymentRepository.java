package com.vares.pos.repository;

import com.vares.pos.model.entity.Payment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PaymentRepository extends JpaRepository<Payment, String> {
    List<Payment> findByOrderId(String orderId);

    List<Payment> findByCashierId(String cashierId);

    List<Payment> findByPaymentMethod(Payment.PaymentMethod paymentMethod);
}
