package model;


import java.time.LocalDateTime;

public class Feedback {

    private Integer feedbackId;

    private Integer userId;

    private Integer rating;     // 1 to 5
    private String comments;

    private LocalDateTime createdAt;

    // ✅ No-argument constructor
    public Feedback() {
    }

    // ✅ Parameterized constructor
    public Feedback(Integer feedbackId, Integer userId,
                    Integer rating, String comments,
                    LocalDateTime createdAt) {

        this.feedbackId = feedbackId;
        this.userId = userId;
        this.rating = rating;
        this.comments = comments;
        this.createdAt = createdAt;
    }

    // ✅ Getters & Setters

    public Integer getFeedbackId() {
        return feedbackId;
    }

    public void setFeedbackId(Integer feedbackId) {
        this.feedbackId = feedbackId;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public Integer getRating() {
        return rating;
    }

    public void setRating(Integer rating) {
        this.rating = rating;
    }

    public String getComments() {
        return comments;
    }

    public void setComments(String comments) {
        this.comments = comments;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    // ✅ Helpful for logs / debugging
    @Override
    public String toString() {
        return "Feedback{" +
                "feedbackId=" + feedbackId +
                ", userId=" + userId +
                ", rating=" + rating +
                '}';
    }
}


