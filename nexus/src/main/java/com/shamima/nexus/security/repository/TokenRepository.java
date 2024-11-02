package com.shamima.nexus.security.repository;

import com.shamima.nexus.security.entity.Token;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface TokenRepository extends JpaRepository<Token, Long> {

    Optional<Token> findByToken(String token);
    @Query("""
    select t from Token t inner join User u on t.user.id = u.id
    where t.user.id = :userId and t.isLoggedOut = false
    """)
    List<Token> findAllTokensByUser(Long userId);

}
