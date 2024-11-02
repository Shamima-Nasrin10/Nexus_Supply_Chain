package com.shamima.nexus.service.production;


import com.shamima.nexus.model.RawMaterial;
import com.shamima.nexus.model.production.Ingredient;
import com.shamima.nexus.model.production.ProductionProduct;
import com.shamima.nexus.model.production.Recipe;
import com.shamima.nexus.repository.RawMaterialRepository;
import com.shamima.nexus.repository.production.ProductionProductRepository;
import com.shamima.nexus.repository.production.RecipeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class RecipeService {
    @Autowired
    private RecipeRepository recipeRepository;

    @Autowired
    private RawMaterialRepository rawMaterialRepository;

    @Autowired
    private ProductionProductRepository productionProductRepository;

    public List<Recipe> getAllRecipes() {
        return recipeRepository.findAll();
    }



    public Recipe createRecipe(Recipe recipe) {
        // Fetch productId based on productName
        String productName = recipe.getProduct().getProductName();
        ProductionProduct product = productionProductRepository.findByProductName(productName);
        if (product == null) {
            // Handle the case when product is not found
            throw new IllegalArgumentException("Product with name " + productName + " not found");
        }
        // Set the fetched productId in the recipe
        recipe.getProduct().setProductId(product.getProductId());

        // Iterate through the ingredients
        for (Ingredient ingredient : recipe.getIngredients()) {
            // Fetch the RawMaterial object based on the material name
            String materialName = ingredient.getName();
            RawMaterial rawMaterial = rawMaterialRepository.findByMaterialName(materialName);
            if (rawMaterial == null) {
                // Handle the case when material is not found
                throw new IllegalArgumentException("RawMaterial with name " + materialName + " not found");
            }
            // Set the fetched RawMaterial object in the Ingredient
            ingredient.setRawMaterial(rawMaterial);
            ingredient.setRecipe(recipe);
        }
        return recipeRepository.save(recipe);
    }

//    public Recipe createRecipe(Recipe recipe) {
//        // Iterate through the ingredients
//
//
//        for (Ingredient ingredient : recipe.getIngredients()) {
//            // Fetch the RawMaterial object based on the material name
//            String materialName = ingredient.getName();
//            RawMaterial rawMaterial = rawMaterialRepository.findByMaterialName(materialName);
//            if (rawMaterial == null) {
//                // Handle the case when material is not found
//                throw new IllegalArgumentException("RawMaterial with name " + materialName + " not found");
//            }
//            // Set the fetched RawMaterial object in the Ingredient
//            ingredient.setRawMaterial(rawMaterial);
//            ingredient.setRecipe(recipe);
//        }
//        return recipeRepository.save(recipe);
//
//    }

    public Recipe getRecipeById(Long id) {
        return recipeRepository.findById(id).orElse(null);
    }

    public void deleteRecipe(Long id) {
        recipeRepository.deleteById(id);
    }


    public List<Ingredient> getIngredientsByProductName(String productName){
        Recipe recipe=recipeRepository.findByProductProductName(productName);//change in repository

        if (recipe == null) {
            throw new RuntimeException("Recipe not found for product: " + productName);
        }

        // Return the list of ingredients
        return recipe.getIngredients();
    }



    public List<RawMaterial> getRawMaterialNames() {
        return rawMaterialRepository.findAll();
//        List<RawMaterial> rawMaterials = rawMaterialRepository.findAll();
//        List<RawMaterial> materialNames = new ArrayList<>();
//
//        for (RawMaterial rawMaterial : rawMaterials) {
//            RawMaterial materialName=new RawMaterial();
//            materialName.setMaterialName(rawMaterial.getMaterialName());
//            materialNames.add(materialName);
//        }
//        return materialNames;
    }

//    public List<ProductionProduct> getAllProductName(){
//        return productionProductRepository.findAll();
//    }

    public List<ProductionProduct> getProductionProductName(){
        return productionProductRepository.findAll();
//        List<ProductionProduct> products = productionProductRepository.findAll();
//        List<ProductionProduct> productNames = new ArrayList<>();
//        for (ProductionProduct product : products) {
//            ProductionProduct productName = new ProductionProduct();
//            productName.setProductName(product.getProductName());
//            productNames.add(productName);
//        }
//        return productNames;
    }


}