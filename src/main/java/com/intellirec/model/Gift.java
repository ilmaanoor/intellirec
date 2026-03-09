package com.intellirec.model;

public class Gift {
    private int id;
    private String name;
    private String category;
    private String priceRange;
    private String ageGroup;

    public Gift() {}

    public Gift(int id, String name, String category, String priceRange, String ageGroup) {
        this.id = id;
        this.name = name;
        this.category = category;
        this.priceRange = priceRange;
        this.ageGroup = ageGroup;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    public String getPriceRange() { return priceRange; }
    public void setPriceRange(String priceRange) { this.priceRange = priceRange; }
    public String getAgeGroup() { return ageGroup; }
    public void setAgeGroup(String ageGroup) { this.ageGroup = ageGroup; }
}
