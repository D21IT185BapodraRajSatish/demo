package com.example.demo.controllers;

import com.example.demo.models.Users;
import com.example.demo.services.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;

@RestController
public class UserController {

    @Autowired
    UserService userService;

    @PostMapping("/adduser")
    public ResponseEntity<Users> addUser(@RequestBody Users users){
       return ResponseEntity.ok(userService.addUser(users));
    }

    @PutMapping("creditbalance/{id}")
    public ResponseEntity<Users> creditBalance(@PathVariable Integer id, @RequestBody HashMap<String,Integer> amount){
        return ResponseEntity.ok(userService.creditBalance(id,amount));
    }

}
