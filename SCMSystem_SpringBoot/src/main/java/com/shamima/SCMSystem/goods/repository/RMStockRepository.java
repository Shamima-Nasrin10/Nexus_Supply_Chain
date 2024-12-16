package com.shamima.SCMSystem.goods.repository;

import com.shamima.SCMSystem.goods.entity.RawMaterial;
import com.shamima.SCMSystem.goods.entity.RawMaterialStock;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface RMStockRepository extends JpaRepository<RawMaterialStock, Long> {
    RawMaterialStock findByRawMaterial(RawMaterial rawMaterial);
}
