package com.example.demo.services;

import com.example.demo.models.Transaction;
import com.example.demo.models.Users;
import com.example.demo.repositories.TransactionRepo;
import com.example.demo.repositories.UserRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.Objects;

@Service
public class UserService {
    private final UserRepo userRepo;
    private final TransactionRepo transactionRepo;

    public UserService(UserRepo userRepo, TransactionRepo transactionRepo) {
        this.userRepo = userRepo;
        this.transactionRepo = transactionRepo;
    }



    @Transactional
    public Users creditBalance(Integer id, HashMap<String, Integer> amount) {
        int creditAmount = amount.getOrDefault("amount", 0);

        // Fetch user, throw if not found
        Users user = userRepo.findById(id).orElseThrow(() ->
                new IllegalArgumentException("User not found with ID: " + id)
        );

        // Update balance safely
        int currentBalance = user.getBalance() == null ? 0 : user.getBalance();
        user.setBalance(currentBalance + creditAmount);

        // Create and save transaction
        Transaction transaction = new Transaction();
        transaction.setUsers(user);

        transactionRepo.save(transaction);

        // Save updated user
        return userRepo.save(user);
    }

    public Users addUser(Users users) {
        return userRepo.save(users);
    }
}
