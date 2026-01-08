package com.vares.pos.repository;

import com.vares.pos.model.entity.Category;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CategoryRepository extends JpaRepository<Category, String> {
    List<Category> findByType(Category.ProductType type);

    List<Category> findByActiveTrue();
}
