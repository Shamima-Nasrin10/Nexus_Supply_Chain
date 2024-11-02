package com.shamima.nexus.repository;

import com.shamima.nexus.model.Inventory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;

public interface InventoryRepository extends JpaRepository<Inventory, Long> {

    Optional<Inventory> findByProcurement_Id(Long procurementId);


    Inventory findByRawMaterial_MaterialName(String materialName);



    @Query("SELECT " +
            "rm.materialID, " +
            "rm.materialName, " +
            "rm.materialType, " +
            "COALESCE(SUM(inv.quantityInStock), 0) AS TotalQuantityInInventory " +
            "FROM " +
            "RawMaterial rm " +
            "LEFT JOIN " +
            "Inventory inv ON rm.materialID = inv.rawMaterial.materialID " +  // Fix the case here
            "GROUP BY " +
            "rm.materialID, rm.materialName, rm.materialType")
    List<Object[]> getInventorySummary();
}
