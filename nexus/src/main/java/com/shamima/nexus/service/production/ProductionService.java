package com.shamima.nexus.service.production;


import com.shamima.nexus.model.Stock;
import com.shamima.nexus.model.production.Ingredient;
import com.shamima.nexus.model.production.ProductionProduct;
import com.shamima.nexus.model.production.ProductionRecords;
import com.shamima.nexus.model.production.Recipe;
import com.shamima.nexus.repository.StockRepository;
import com.shamima.nexus.repository.production.IngredientRepository;
import com.shamima.nexus.repository.production.ProductionProductRepository;
import com.shamima.nexus.repository.production.ProductionRecordsRepository;
import com.shamima.nexus.repository.production.RecipeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.sql.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ProductionService {


    @Autowired
    private IngredientRepository ingredientRepository;


    @Autowired
    private StockRepository stockRepository;


    @Autowired
    private RecipeRepository recipeRepository;

    @Autowired
    private ProductionRecordsRepository productionRecordsRepository;

    @Autowired
    private ProductionProductRepository productionProductRepository;






    public void produceProduct(ProductionRecords request) {

        String productName=request.getProduct().getProductName();
        int productionQuantity=request.getProductionQuantity();

        // Step 1: Retrieve the recipe for apple juice
        Recipe recipe = recipeRepository.findByProductProductName(productName);


        if (recipe == null) {
            throw new IllegalArgumentException("Recipe not found for product: " + productName);
        }



        // Step 2: Deduct ingredient quantities from stock
        List<Ingredient> ingredients = recipe.getIngredients();
        Map<String, Boolean> ingredientStatus = new HashMap<>(); // Map to track ingredient status

        for (Ingredient ingredient : ingredients) {
            String ingredientName = ingredient.getName(); // Assuming name corresponds to material_id
            Stock stock = stockRepository.findByRawMaterial_MaterialName(ingredientName); // Fetch stock by raw material name
            if (stock != null) {
                int quantityNeeded = ingredient.getQuantity() * productionQuantity;
                int currentQuantity = stock.getQuantity();
                if (currentQuantity >= quantityNeeded) {
                    stock.setQuantity(currentQuantity - quantityNeeded);
                    stockRepository.save(stock);
                    // Log ingredient as found in stock
                    System.out.println("Found ingredient in stock: " + ingredientName);
                    ingredientStatus.put(ingredientName, true); // Mark ingredient as found
                } else {
                    // Log ingredient as not found in sufficient quantity
                    System.out.println("Ingredient not found in sufficient quantity: " + ingredientName);
                    ingredientStatus.put(ingredientName, false); // Mark ingredient as not found
                }
            } else {
                // Handle case where stock is not found for the ingredient
                System.out.println("Stock not found for Ingredient: " + ingredientName);
                ingredientStatus.put(ingredientName, false); // Mark ingredient as not found
            }
        }



        // Retrieve the ProductionProduct object from the database using the product name
        ProductionProduct product = productionProductRepository.findByProductName(productName);

// Save production records
        ProductionRecords productionRecords = new ProductionRecords();
//        ProductionProduct product = new ProductionProduct();
        productionRecords.setProduct(product);
        productionRecords.setProduct(product);
        productionRecords.setProductionQuantity(productionQuantity);
        productionRecords.setProductionDate(new Date(System.currentTimeMillis()));
        productionRecords.setQualityControlInfo(request.getQualityControlInfo());
        productionRecords.setBatchNumber(request.getBatchNumber());
        productionRecordsRepository.save(productionRecords);

        // Print summary of ingredient status
        System.out.println("Ingredient Status:");
        for (Map.Entry<String, Boolean> entry : ingredientStatus.entrySet()) {
            System.out.println(entry.getKey() + ": " + (entry.getValue() ? "Found" : "Not Found"));
        }
    }


}
