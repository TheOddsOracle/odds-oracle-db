#!/bin/bash

# MySQL credentials
MYSQL_USER=""
MYSQL_PASSWORD=""

# Database name
DB_NAME="odds"

# SQL statements
SQL_STATEMENTS="""
CREATE DATABASE IF NOT EXISTS $DB_NAME;

USE $DB_NAME;

CREATE TABLE IF NOT EXISTS sports (
    id INT AUTO_INCREMENT PRIMARY KEY,
    sport_key VARCHAR(255) NOT NULL,
    sport_group VARCHAR(255) NOT NULL,
    title VARCHAR(255) NOT NULL,
    description VARCHAR(255),
    active BOOLEAN,
    has_outrights BOOLEAN
);

CREATE TABLE IF NOT EXISTS line_movements (
    id INT AUTO_INCREMENT PRIMARY KEY,
    game_id VARCHAR(255),
    line FLOAT,
    timestamp DATETIME
);

CREATE TABLE IF NOT EXISTS events (
    id INT AUTO_INCREMENT PRIMARY KEY,
    event_id VARCHAR(255) NOT NULL,
    sport_key VARCHAR(255),
    sport_title VARCHAR(255),
    commence_time DATETIME,
    home_team VARCHAR(255) NOT NULL,
    away_team VARCHAR(255) NOT NULL,
    line FLOAT,
    last_updated DATETIME
);

CREATE TABLE IF NOT EXISTS bookmakers (
    bookmaker_id INT AUTO_INCREMENT PRIMARY KEY,
    bookmaker_key VARCHAR(255) NOT NULL,
    title VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS markets (
    market_id INT AUTO_INCREMENT PRIMARY KEY,
    event_id VARCHAR(255),
    bookmaker_id INT,
    market_key VARCHAR(255) NOT NULL,
    last_update DATETIME NOT NULL,
    FOREIGN KEY (event_id) REFERENCES events(event_id),
    FOREIGN KEY (bookmaker_id) REFERENCES bookmakers(bookmaker_id)
);

CREATE TABLE IF NOT EXISTS outcomes (
    outcome_id INT AUTO_INCREMENT PRIMARY KEY,
    market_id INT,
    name VARCHAR(255) NOT NULL,
    description VARCHAR(255),
    price DECIMAL(10,2),
    point DECIMAL(10,2),
    FOREIGN KEY (market_id) REFERENCES markets(market_id)
);


                """

# Execute SQL statements
if mysql -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -e "$SQL_STATEMENTS"; then
    echo "Database and tables created successfully."
else
    echo "Failed to create database and tables."
    exit 1  # Exit with a non-zero status to indicate failure
fi
