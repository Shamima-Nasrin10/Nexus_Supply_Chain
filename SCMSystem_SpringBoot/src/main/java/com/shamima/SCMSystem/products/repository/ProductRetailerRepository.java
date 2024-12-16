package com.shamima.SCMSystem.products.repository;

import com.shamima.SCMSystem.products.entity.ProductRetailer;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ProductRetailerRepository extends JpaRepository<ProductRetailer, Long> {
}
