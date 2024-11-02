package com.shamima.nexus.repository.production;

import com.shamima.nexus.model.product.ProductionRecord;
import com.shamima.nexus.model.production.ProductionProduct;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ProductionProductRepository extends JpaRepository<ProductionProduct,Long> {

    ProductionProduct findByProductName(String productName);
}
