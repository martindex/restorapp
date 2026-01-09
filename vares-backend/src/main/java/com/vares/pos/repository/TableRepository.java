package com.vares.pos.repository;

import com.vares.pos.model.entity.TableEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TableRepository extends JpaRepository<TableEntity, String> {
    List<TableEntity> findByZoneId(String zoneId);

    java.util.Optional<TableEntity> findByZoneIdAndNumber(String zoneId, Integer number);

    List<TableEntity> findByStatus(TableEntity.TableStatus status);

    List<TableEntity> findByZoneIdAndStatus(String zoneId, TableEntity.TableStatus status);

    List<TableEntity> findByMainTableId(String mainTableId);

    List<TableEntity> findByActiveTrue();

    @Query("SELECT t FROM TableEntity t WHERE t.zone.id = :zoneId AND t.active = true AND t.status = 'AVAILABLE'")
    List<TableEntity> findAvailableTablesByZone(@Param("zoneId") String zoneId);

    @Query("SELECT t FROM TableEntity t WHERE t.active = true AND t.status = 'AVAILABLE'")
    List<TableEntity> findAllAvailableTables();
}
