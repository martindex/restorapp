package com.vares.pos.repository;

import com.vares.pos.model.entity.LayoutCell;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface LayoutCellRepository extends JpaRepository<LayoutCell, String> {
    List<LayoutCell> findByZoneId(String zoneId);

    Optional<LayoutCell> findByZoneIdAndRowAndCol(String zoneId, Integer row, Integer col);

    void deleteByZoneId(String zoneId);
}
