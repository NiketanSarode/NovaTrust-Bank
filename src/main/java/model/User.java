package model;

import java.time.LocalDate;
import java.time.LocalDateTime;

public class User {
	
	public enum Gender {
        MALE, FEMALE, OTHER
    }
	public enum Status {
	    ACTIVE,
	    BLOCKED,
	    DELETED
	}


	private Integer userId;

    private String fullName;
    private String email;
    private String phone;

    private String password;

    private LocalDate dob;
    private Gender gender;   // ✅ enum

    private String address;

    private Status status;
    private Boolean isVerified;

    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // ✅ No-argument constructor
    public User() {
    }

    // ✅ Parameterized constructor
    public User(Integer userId, String fullName, String email, String phone, String password,
                LocalDate dob, Gender gender, String address, Status status,
                Boolean isVerified, LocalDateTime createdAt, LocalDateTime updatedAt) {

        this.userId = userId;
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.password = password;
        this.dob = dob;
        this.gender = gender;
        this.address = address;
        this.status = status;
        this.isVerified = isVerified;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    // ✅ Getters & Setters

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public LocalDate getDob() {
        return dob;
    }

    public void setDob(LocalDate dob) {
        this.dob = dob;
    }

    public Gender getGender() {
        return gender;
    }

    public void setGender(Gender gender) {
        this.gender = gender;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public Status getStatus() {
        return status;
    }

    public void setStatus(Status status) {
        this.status = status;
    }

    public Boolean getIsVerified() {
        return isVerified;
    }

    public void setIsVerified(Boolean isVerified) {
        this.isVerified = isVerified;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    @Override
    public String toString() {
        return "User{" +
                "userId=" + userId +
                ", fullName='" + fullName + '\'' +
                ", email='" + email + '\'' +
                ", phone='" + phone + '\'' +
                ", gender=" + gender +
                ", status='" + status + '\'' +
                ", isVerified=" + isVerified +
                '}';
    }
}

