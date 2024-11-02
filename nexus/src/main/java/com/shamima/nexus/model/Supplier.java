package com.shamima.nexus.model;


import jakarta.persistence.*;
import lombok.Data;

@Data
@Entity
@Table(name = "supplier")
public class Supplier {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "supplier_id")
    private Long supplierID;

    @Column(name = "supplier_name")
    private String supplierName;

    @Column(name = "supplier_company_name")
    private String supplierCompanyName;

    @Column(name = "supplier_contact_info")
    private String supplierContactInfo;
}
