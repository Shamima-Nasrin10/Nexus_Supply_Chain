package com.shamima.SCMSystem.goods.repository;

import com.shamima.SCMSystem.goods.entity.RawMaterialSupplier;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface RawMaterialSupplierRepository extends JpaRepository<RawMaterialSupplier, Long> {
}
