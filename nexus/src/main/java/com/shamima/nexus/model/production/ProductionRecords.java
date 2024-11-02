package com.shamima.nexus.model.production;


        import com.shamima.nexus.model.product.Product;
        import jakarta.persistence.*;
        import lombok.Data;

        import java.sql.Date;

@Data
@Entity
@Table(name = "productionrecords")
public class ProductionRecords {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long productionId;

    @ManyToOne(cascade = CascadeType.PERSIST)
    @JoinColumn(name = "product_id")
    private ProductionProduct product;

    private int productionQuantity;

    private Date productionDate;

    private String qualityControlInfo;

    private String batchNumber;
}
