package com.smartcity.service;

import com.smartcity.dto.JwtResponse;
import com.smartcity.dto.LoginRequest;
import com.smartcity.dto.SignupRequest;
import com.smartcity.entity.User;
import com.smartcity.repository.UserRepository;
import com.smartcity.security.JwtUtils;
import com.smartcity.security.UserDetailsImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class AuthService {

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private JwtUtils jwtUtils;

    public JwtResponse authenticateUser(LoginRequest loginRequest) {
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(loginRequest.getEmail(), loginRequest.getPassword())
        );

        SecurityContextHolder.getContext().setAuthentication(authentication);
        String jwt = jwtUtils.generateJwtToken(authentication);

        UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();
        String role = userDetails.getAuthorities().iterator().next().getAuthority().replace("ROLE_", "");

        return new JwtResponse(jwt, userDetails.getId(), userDetails.getName(),
                userDetails.getEmail(), role);
    }

    public String registerUser(SignupRequest signupRequest) {
        if (userRepository.existsByEmail(signupRequest.getEmail())) {
            throw new RuntimeException("Error: Email is already in use!");
        }

        User user = new User();
        user.setName(signupRequest.getName());
        user.setEmail(signupRequest.getEmail());
        user.setPassword(passwordEncoder.encode(signupRequest.getPassword()));
        user.setPhone(signupRequest.getPhone());
        user.setAddress(signupRequest.getAddress());

        try {
            user.setRole(User.Role.valueOf(signupRequest.getRole().toUpperCase()));
        } catch (IllegalArgumentException e) {
            throw new RuntimeException("Error: Invalid role provided!");
        }

        userRepository.save(user);
        return "User registered successfully!";
    }
}
