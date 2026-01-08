package com.vares.pos.repository;

import com.vares.pos.model.entity.Reservation;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface ReservationRepository extends JpaRepository<Reservation, String> {
    List<Reservation> findByCustomerId(String customerId);

    List<Reservation> findByDate(LocalDate date);

    List<Reservation> findByStatus(Reservation.ReservationStatus status);

    List<Reservation> findByDateAndStatus(LocalDate date, Reservation.ReservationStatus status);

    @Query("SELECT r FROM Reservation r WHERE r.date = :date AND r.status IN ('PENDING', 'CONFIRMED')")
    List<Reservation> findActiveReservationsByDate(@Param("date") LocalDate date);
}
