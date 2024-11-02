package com.shamima.nexus.restcontroller;


import com.shamima.nexus.model.product.Products;
import com.shamima.nexus.repository.allproducts.ProductsRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

@RestController
@RequestMapping("/api/products")
public class ProductRestController {

    @Autowired
    private ProductsRepository productsRepository;

    @PostMapping("/add")
    public ResponseEntity<Products> addProduct(@RequestParam("name") String name,
                                               @RequestParam("description") String description,
                                               @RequestParam("batchNumber") String batchNumber,
                                               @RequestParam("price") double price,
                                               @RequestParam("image") MultipartFile image) {

        Products product = new Products();
        product.setName(name);
        product.setDescription(description);
        product.setBatchNumber(batchNumber);
        product.setPrice(price);

        if (!image.isEmpty()) {
            try {
                String imageUrl = saveImageToStaticFolder(image, "images");
                product.setImageUrl(imageUrl);
            } catch (IOException e) {
                e.printStackTrace();
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
            }
        }

        Products saveProduct = productsRepository.save(product);
        return ResponseEntity.ok(saveProduct);
    }




    @GetMapping("/list")
    public ResponseEntity<List<Products>> listProducts(){
        List<Products> products=productsRepository.findAll();
        return ResponseEntity.ok(products);
    }

    private String saveImageToStaticFolder(MultipartFile image, String subFolder) throws IOException{

        byte[] bytes = image.getBytes();
        String imageName= System.currentTimeMillis() + "_"+image.getOriginalFilename();
        Path path = Paths.get("src/main/resources/static/" + subFolder + "/" + imageName);
        Files.write(path, bytes);
        return "/" + subFolder + "/" + imageName;
    }
}
