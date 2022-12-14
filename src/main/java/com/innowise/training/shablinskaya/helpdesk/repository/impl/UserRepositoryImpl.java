package com.innowise.training.shablinskaya.helpdesk.repository.impl;

import com.innowise.training.shablinskaya.helpdesk.entity.User;
import com.innowise.training.shablinskaya.helpdesk.enums.Role;
import com.innowise.training.shablinskaya.helpdesk.repository.UserRepository;
import org.springframework.stereotype.Repository;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import java.util.List;
import java.util.Optional;

@Repository
public class UserRepositoryImpl implements UserRepository {

    @PersistenceContext
    private EntityManager entityManager;

    @Override
    public Optional<User> getById(Long id) {
        return Optional.of(entityManager.find(User.class, id));
    }

    @Override
    public List<User> findByRole(Role role) {
        return entityManager.createQuery(
                "SELECT u FROM User u WHERE u.roleId = : role", User.class)
                .setParameter("role", role).getResultList();
    }


    @Override
    public Optional<User> findByEmail(String email) {
        return Optional.of(entityManager.createQuery("select u from User u WHERE u.email = : email", User.class)
                .setParameter("email", email)
                .getSingleResult());
    }

}
