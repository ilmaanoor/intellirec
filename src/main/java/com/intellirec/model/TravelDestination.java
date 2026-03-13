package com.intellirec.model;

public class TravelDestination {
    private String id;
    private String name;
    private String description;
    private String type;
    private String rating;
    private String img;
    private String tripadvisorUrl;

    public TravelDestination() {}

    public TravelDestination(String id, String name, String description, String type, String rating, String img, String tripadvisorUrl) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.type = type;
        this.rating = rating;
        this.img = img;
        this.tripadvisorUrl = tripadvisorUrl;
    }

    // Getters and Setters
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public String getRating() { return rating; }
    public void setRating(String rating) { this.rating = rating; }

    public String getImg() { return img; }
    public void setImg(String img) { this.img = img; }

    public String getTripadvisorUrl() { return tripadvisorUrl; }
    public void setTripadvisorUrl(String tripadvisorUrl) { this.tripadvisorUrl = tripadvisorUrl; }
}
