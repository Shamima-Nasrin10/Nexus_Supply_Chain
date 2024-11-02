package com.shamima.nexus.repository.production;


import com.shamima.nexus.model.Stock;
import com.shamima.nexus.model.production.Ingredient;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface IngredientRepository extends JpaRepository<Ingredient,Long> {
    Ingredient findByStock(Stock stock);
}
