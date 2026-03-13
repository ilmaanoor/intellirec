package com.intellirec.scraper;

import com.intellirec.model.ScrapedProduct;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.json.JSONArray;
import org.json.JSONObject;

import java.io.IOException;
import java.net.URLEncoder;
import java.util.*;

public class ScraperEngine {

    private static final String USER_AGENT =
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36";
    private static final String FK_API_UA =
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36 FKUA/website/42/website/Desktop";
    private static final int MAX_RESULTS = 6;

    public Map<String, List<ScrapedProduct>> scrapeMarketByPlatform(String query) {
        Map<String, List<ScrapedProduct>> map = new LinkedHashMap<>();

        List<ScrapedProduct> amazonList = new ArrayList<>();
        try {
            amazonList = scrapeAmazonMultiple(query);
        } catch (Exception e) {
            System.err.println("Amazon Error: " + e.getMessage());
            // Fallback result
        }
        map.put("amazon", amazonList);

        List<ScrapedProduct> flipkartList = new ArrayList<>();
        try {
            flipkartList = scrapeFlipkartMultiple(query);
        } catch (Exception e) {
            System.err.println("Flipkart Error: " + e.getMessage());
            // Fallback result
        }
        map.put("flipkart", flipkartList);

        return map;
    }

    private List<ScrapedProduct> scrapeAmazonMultiple(String query) throws IOException {
        String url = "https://www.amazon.in/s?k=" + URLEncoder.encode(query, "UTF-8");
        Document doc = Jsoup.connect(url)
                .userAgent(USER_AGENT)
                .header("Accept-Language", "en-US,en;q=0.9")
                .timeout(15000)
                .get();

        List<ScrapedProduct> results = new ArrayList<>();
        Elements items = doc.select("div[data-component-type='s-search-result']");
        String[] queryWords = query.toLowerCase().split("\\s+");

        for (Element item : items) {
            if (results.size() >= MAX_RESULTS) break;

            Element dpLink = item.selectFirst("a[href*=/dp/]");
            if (dpLink == null) continue;

            String href = dpLink.attr("href");
            String productUrl = href.startsWith("http") ? href : "https://www.amazon.in" + href;

            Element img = item.selectFirst("img.s-image");
            String title = "";
            String thumb = "";
            if (img != null) {
                title = img.attr("alt").trim();
                thumb = img.attr("src");
            }
            if (title.isEmpty()) {
                Element h2 = item.selectFirst("h2");
                title = h2 != null ? h2.text().trim() : "";
            }
            if (title.isEmpty()) continue;

            Element priceEl = item.selectFirst(".a-price-whole");
            if (priceEl == null) continue;
            String priceText = priceEl.text().replaceAll("[^0-9]", "").trim();
            if (priceText.isEmpty()) continue;
            double price = Double.parseDouble(priceText);

            results.add(new ScrapedProduct(title, price, "Amazon", productUrl, thumb));
        }

        return results;
    }

    private List<ScrapedProduct> scrapeFlipkartMultiple(String query) throws IOException {
        String url = "https://2.rome.api.flipkart.com/api/4/page/fetch";
        String payload = String.format(
            "{\"pageUri\":\"/search?q=%s\",\"pageContext\":{\"fetchSeoData\":true},\"requestContext\":{\"type\":\"BROWSE_PAGE\"}}",
            URLEncoder.encode(query, "UTF-8"));

        String jsonResponse = Jsoup.connect(url)
                .userAgent(FK_API_UA)
                .header("Content-Type", "application/json")
                .header("Accept", "application/json")
                .header("Referer", "https://www.flipkart.com/")
                .requestBody(payload)
                .ignoreContentType(true)
                .method(org.jsoup.Connection.Method.POST)
                .timeout(15000)
                .execute()
                .body();

        JSONObject root = new JSONObject(jsonResponse);
        JSONObject responseObj = root.optJSONObject("RESPONSE");
        if (responseObj == null) return new ArrayList<>();
        JSONArray slots = responseObj.optJSONArray("slots");
        if (slots == null) return new ArrayList<>();

        List<ScrapedProduct> results = new ArrayList<>();
        for (int i = 0; i < slots.length() && results.size() < MAX_RESULTS; i++) {
            JSONObject slot = slots.getJSONObject(i);
            JSONObject widget = slot.optJSONObject("widget");
            if (widget == null) continue;
            JSONObject widgetData = widget.optJSONObject("data");
            if (widgetData == null || !widgetData.has("products")) continue;

            JSONArray fkProducts = widgetData.getJSONArray("products");
            for (int j = 0; j < fkProducts.length() && results.size() < MAX_RESULTS; j++) {
                try {
                    JSONObject productItem = fkProducts.getJSONObject(j);
                    JSONObject value = productItem.getJSONObject("productInfo").getJSONObject("value");

                    String title = value.getJSONObject("titles").getString("title");
                    JSONObject pricing = value.getJSONObject("pricing");
                    double price = Double.parseDouble(pricing.getJSONObject("finalPrice").get("decimalValue").toString());

                    String thumb = "";
                    if (value.has("images") && value.getJSONArray("images").length() > 0) {
                        thumb = value.getJSONArray("images").getJSONObject(0).optString("url", "");
                        thumb = thumb.replace("{@width}", "400").replace("{@height}", "400").replace("{@quality}", "80");
                    }

                    String productUrl = value.optString("smartUrl", "");
                    if (productUrl.isEmpty()) {
                        String pid = value.optString("id", "");
                        productUrl = "https://www.flipkart.com/p/p/" + pid;
                    }

                    results.add(new ScrapedProduct(title, price, "Flipkart", productUrl, thumb));
                } catch (Exception e) {}
            }
        }
        return results;
    }
}
