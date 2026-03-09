package com.intellirec.servlet;

import com.intellirec.model.Movie;
import com.intellirec.model.Song;
import com.intellirec.model.Gift;
import com.intellirec.util.DBConnection;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/getRecommendations")
public class RecommendationServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String type = request.getParameter("type"); // movie, song, gift
        String interest = request.getParameter("interest");

        try (Connection conn = DBConnection.getConnection()) {
            if ("movie".equalsIgnoreCase(type)) {
                List<Movie> movies = new ArrayList<>();
                String sql = "SELECT * FROM movies WHERE genre = ? ORDER BY rating DESC";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, interest);
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    movies.add(new Movie(rs.getInt("movie_id"), rs.getString("title"), rs.getString("genre"), rs.getDouble("rating")));
                }
                request.setAttribute("recommendations", movies);
            } else if ("song".equalsIgnoreCase(type)) {
                List<Song> songs = new ArrayList<>();
                String sql = "SELECT * FROM songs WHERE mood = ?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, interest);
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    songs.add(new Song(rs.getInt("song_id"), rs.getString("title"), rs.getString("artist"), rs.getString("mood")));
                }
                request.setAttribute("recommendations", songs);
            } else if ("gift".equalsIgnoreCase(type)) {
                List<Gift> gifts = new ArrayList<>();
                String sql = "SELECT * FROM gifts WHERE price_range = ?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, interest);
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    gifts.add(new Gift(rs.getInt("gift_id"), rs.getString("name"), rs.getString("category"), rs.getString("price_range"), rs.getString("age_group")));
                }
                request.setAttribute("recommendations", gifts);
            }
            request.setAttribute("type", type);
            request.getRequestDispatcher("recommendations.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}
