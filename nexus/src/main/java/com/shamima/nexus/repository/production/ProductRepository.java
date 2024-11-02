package com.shamima.nexus.repository.production;

import com.shamima.nexus.model.product.Product;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ProductRepository extends JpaRepository<Product,Long> {
}
