package com.shamima.nexus.repository;


import com.shamima.nexus.model.RawMaterial;
import com.shamima.nexus.model.Stock;
import com.shamima.nexus.model.production.Ingredient;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface StockRepository extends JpaRepository<Stock ,Long> {
    Stock findByRawMaterial(RawMaterial rawMaterial);

    Stock findByRawMaterial_MaterialName(String name);


}
