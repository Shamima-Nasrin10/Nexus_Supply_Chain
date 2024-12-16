package com.shamima.SCMSystem.accounting.repository;

import com.shamima.SCMSystem.accounting.entity.Procurement;
import com.shamima.SCMSystem.goods.entity.RawMaterialSupplier;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ProcurementRepository extends JpaRepository<Procurement, Long> {

    Optional<List<Procurement>> findAllByRawMaterialSupplier(RawMaterialSupplier rawMaterialSupplier);

}
