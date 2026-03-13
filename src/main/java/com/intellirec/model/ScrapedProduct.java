package com.intellirec.model;

public class ScrapedProduct {
    private String title;
    private double price;
    private double mrp;
    private double shipping;
    private String source;
    private String productUrl;
    private String img;

    public ScrapedProduct(String title, double price, String source, String productUrl, String img) {
        this.title = title;
        this.price = price;
        this.mrp = price;
        this.shipping = 0.0;
        this.source = source;
        this.productUrl = productUrl;
        this.img = img;
    }

    public ScrapedProduct(String title, double price, double mrp, double shipping, String source, String productUrl, String img) {
        this.title = title;
        this.price = price;
        this.mrp = mrp;
        this.shipping = shipping;
        this.source = source;
        this.productUrl = productUrl;
        this.img = img;
    }

    // Getters
    public String getTitle() { return title; }
    public double getPrice() { return price; }
    public double getMrp() { return mrp; }
    public double getShipping() { return shipping; }
    public String getSource() { return source; }
    public String getProductUrl() { return productUrl; }
    public String getImg() { return img; }
}
