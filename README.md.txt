#  Employee Performance Database - SQL Project

[![MySQL](https://img.shields.io/badge/MySQL-8.0+-blue.svg)](https://www.mysql.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

> A comprehensive SQL database project for managing and analyzing employee performance data at ScienceQtech.

##  Table of Contents

- [About](#about)
- [Features](#features)
- [Database Schema](#database-schema)
- [Installation](#installation)
- [Usage](#usage)
- [Queries Overview](#queries-overview)
- [ER Diagram](#er-diagram)
- [Technologies](#technologies)
- [Author](#author)
- [License](#license)

---

##  About

This project implements a complete employee performance management database system. It includes 17 comprehensive SQL queries covering database design, data manipulation, advanced functions, and performance optimization.

*Project Context:* Academic assignment for Data Acquisition and Manipulation using SQL

*Organization:* ScienceQtech Employee Performance Mapping

---

## ✨ Features

-  *Database Design* - Normalized table structures with proper relationships
-  *Complex Queries* - JOINs, subqueries, window functions, and aggregations
-  *Stored Function* - Dynamic job profile classification based on experience
-  *Stored Procedure* - Retrieval of employees with specific criteria
-  *Index Optimization* - Performance improvement for large datasets
-  *VIEW Creation* - Filtered views for specific data segments
-  *ER Diagram* - Complete entity-relationship documentation

---

##  Database Schema

### Tables

1. *emp_record_table* (Master Table)
   - Employee ID, Name, Gender, Role, Department
   - Experience, Country, Continent, Salary, Rating
   - Manager ID (self-referencing)

2. *data_science_team* (Specialized Team)
   - Employee details specific to Data Science department
   - References: emp_record_table

3. *proj_table* (Project Assignments)
   - Project details and employee assignments
   - References: emp_record_table

---

##  Installation

### Prerequisites

- MySQL Server 8.0+
- MySQL Workbench (recommended)
- Git

### Setup Steps

1. *Clone the repository*