package com.vares.pos.repository;

import com.vares.pos.model.entity.Zone;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ZoneRepository extends JpaRepository<Zone, String> {
    Optional<Zone> findByName(String name);

    List<Zone> findByActive(Boolean active);
}
