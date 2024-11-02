package com.shamima.nexus.repository.allproducts;

import com.shamima.nexus.model.product.Products;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ProductsRepository extends JpaRepository<com.shamima.nexus.model.product.Products, Long> {


}
