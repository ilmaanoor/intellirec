-- IntelliRec Database Schema

CREATE DATABASE IF NOT EXISTS intellirec;
USE intellirec;

-- Users Table
CREATE TABLE IF NOT EXISTS users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    interest VARCHAR(50) -- e.g., 'Action', 'Sci-Fi', 'Pop', 'Rock', 'Technology'
);

-- Movies Table
CREATE TABLE IF NOT EXISTS movies (
    movie_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    genre VARCHAR(50) NOT NULL,
    rating DOUBLE DEFAULT 0.0,
    image_url VARCHAR(255) -- Optional for UI
);

-- Songs Table
CREATE TABLE IF NOT EXISTS songs (
    song_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    artist VARCHAR(100) NOT NULL,
    mood VARCHAR(50) NOT NULL,
    cover_url VARCHAR(255) -- Optional for UI
);

-- Gifts Table
CREATE TABLE IF NOT EXISTS gifts (
    gift_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price_range VARCHAR(50) NOT NULL, -- e.g., '500-1000', '1000-2000'
    age_group VARCHAR(50) NOT NULL
);

-- Initial Seed Data

-- Movies
INSERT INTO movies (title, genre, rating) VALUES 
('Inception', 'Sci-Fi', 8.8),
('The Dark Knight', 'Action', 9.0),
('Interstellar', 'Sci-Fi', 8.6),
('Parasite', 'Drama', 8.5),
('Avengers: Endgame', 'Action', 8.4);

-- Songs
INSERT INTO songs (title, artist, mood) VALUES 
('Shake It Off', 'Taylor Swift', 'Happy'),
('Blinding Lights', 'The Weeknd', 'Energetic'),
('Someone Like You', 'Adele', 'Sad'),
('Heat Waves', 'Glass Animals', 'Chill'),
('Dynamite', 'BTS', 'Happy');

-- Gifts
INSERT INTO gifts (name, category, price_range, age_group) VALUES 
('Wireless Earbuds', 'Electronics', '2000-5000', 'Teenager'),
('Gourmet Coffee Set', 'Food', '1000-2000', 'Adult'),
('LEGO Star Wars', 'Toys', '2000-5000', 'Child'),
('Aromatherapy Diffuser', 'Wellness', '500-1000', 'Adult'),
('Gaming Mouse', 'Electronics', '1000-2000', 'Teenager');
