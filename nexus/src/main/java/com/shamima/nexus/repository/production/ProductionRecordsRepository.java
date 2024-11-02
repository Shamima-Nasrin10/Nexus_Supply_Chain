package com.shamima.nexus.repository.production;

import com.shamima.nexus.model.production.ProductionRecords;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;


@Repository
public interface ProductionRecordsRepository extends JpaRepository<ProductionRecords,Long> {

    @Query("SELECT pr, prp.productName " +
            "FROM ProductionRecords pr " +
            "JOIN pr.product prp")
    List<Object[]> getProductionRecordsWithProductName();
}
