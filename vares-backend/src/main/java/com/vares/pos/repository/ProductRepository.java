package com.vares.pos.repository;

import com.vares.pos.model.entity.Product;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ProductRepository extends JpaRepository<Product, String> {
    List<Product> findByCategoryId(String categoryId);

    List<Product> findByType(com.vares.pos.model.entity.Category.ProductType type);

    List<Product> findByAvailableTrue();

    List<Product> findByTypeAndAvailableTrue(com.vares.pos.model.entity.Category.ProductType type);
}
