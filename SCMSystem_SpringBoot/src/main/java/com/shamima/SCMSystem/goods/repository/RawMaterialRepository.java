package com.shamima.SCMSystem.goods.repository;

import com.shamima.SCMSystem.goods.entity.RawMaterial;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;


@Repository
public interface RawMaterialRepository extends JpaRepository<RawMaterial, Long> {

    List<RawMaterial> findAllByCategoryId(Long categoryId);
}
