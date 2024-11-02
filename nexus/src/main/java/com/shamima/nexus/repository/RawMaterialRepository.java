package com.shamima.nexus.repository;

import com.shamima.nexus.model.RawMaterial;
import org.springframework.data.jpa.repository.JpaRepository;

public interface RawMaterialRepository extends JpaRepository<RawMaterial, Long> {

    RawMaterial findByMaterialName(String materialName);
}
