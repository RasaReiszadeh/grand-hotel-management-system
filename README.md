# 🏨 Grand Hotel Management & Kiosk Reservation System

> A desktop hotel enterprise application built with Java, JavaFX, FXML, and H2/JDBC, featuring a self-service guest kiosk, administrative operations dashboard, automated PDF/CSV reporting, and Gang of Four (GoF) design patterns.

[![Java](https://img.shields.io/badge/Java-17+-ED8B00?style=flat-square&logo=openjdk&logoColor=white)](https://www.oracle.com/java/)
[![JavaFX](https://img.shields.io/badge/JavaFX-17-007396?style=flat-square)](https://openjfx.io/)
[![Maven](https://img.shields.io/badge/Maven-Build-C71A36?style=flat-square&logo=apachemaven&logoColor=white)](https://maven.apache.org/)
[![Database](https://img.shields.io/badge/Database-H2%20%7C%20Embedded_SQL-4479A1?style=flat-square)](https://www.h2database.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](LICENSE)

[Overview](#overview) • [Architecture & Design Patterns](#architecture--design-patterns) • [System Capabilities](#system-capabilities) • [Tech Stack](#tech-stack) • [Project Structure](#project-structure) • [Quick Start](#quick-start)

---

## Overview

The **Grand Hotel Management System** is an end-to-end desktop hospitality solution engineered to handle both front-of-house guest interactions and back-of-house hotel operations.

The platform features two distinct sub-systems sharing a common domain layer:

1. **Self-Service Guest Kiosk:** A guided touch-friendly workflow allowing guests to browse rooms, configure add-ons (spa, high-speed Wi-Fi), enroll in and redeem loyalty points, verify booking summaries, and generate instant confirmation records.
2. **Operations & Admin Dashboard:** A role-secured management interface for front-desk staff and hotel managers to oversee reservations, process cancellations and waitlists, manage seasonal discounts, inspect guest feedback, and generate business analytics (occupancy rates, revenue breakdowns) exported to PDF and CSV formats.

---

## Architecture & Design Patterns

The codebase is built on strict Object-Oriented Design (OOD) principles, leveraging classic Gang of Four patterns to decouple business logic from UI controllers and database persistence:

```text
 ┌─────────────────────────────────────────────────────────┐
 │                    JavaFX / FXML View                   │
 │       [ Guest Kiosk Views ]    [ Admin Dashboard ]      │
 └────────────────────────────┬────────────────────────────┘
                              │
                              ▼
 ┌─────────────────────────────────────────────────────────┐
 │                     Controller Layer                    │
 │            (Event Binding & View Navigation)            │
 └────────────────────────────┬────────────────────────────┘
                              │
                              ▼
 ┌─────────────────────────────────────────────────────────┐
 │                      Service Layer                      │
 │                                                         │
 │  ┌─────────────────────┐       ┌─────────────────────┐  │
 │  │  Decorator Pattern  │       │   Strategy Pattern  │  │
 │  │  (Spa/Wifi Addons)  │       │ (Pricing & Loyalty) │  │
 │  └─────────────────────┘       └─────────────────────┘  │
 │  ┌─────────────────────┐       ┌─────────────────────┐  │
 │  │   Factory Pattern   │       │   Observer Pattern  │  │
 │  │   (Room Creation)   │       │(Availability Events)│  │
 │  └─────────────────────┘       └─────────────────────┘  │
 └─────────────┬─────────────────────────────┬─────────────┘
               │                             │
               ▼                             ▼
 ┌───────────────────────────┐ ┌───────────────────────────┐
 │      Repository Layer     │ │     Export & Utilities    │
 │ (CRUD, Data Access Layer) │ │ (iText PDF & CSV Builders)│
 └─────────────┬─────────────┘ └───────────────────────────┘
               │
               ▼
 ┌───────────────────────────┐
 │    H2 Embedded Database   │
 │ (Relational Schema / JDBC)│
 └───────────────────────────┘
```

### Applied Design Patterns

- **Decorator Pattern** (`AddonDecorator`, `SpaDecorator`, `WifiDecorator`): Dynamically layers discretionary service charges onto base room rates without altering core stay logic.
- **Strategy Pattern** (`PricingStrategy`, `StandardPricingStrategy`, `LoyaltyStrategy`): Encapsulates varying rate algorithms (standard rate, weekend pricing, seasonal promotional reductions, and loyalty reward discounts).
- **Factory Pattern** (`RoomFactory`): Centralizes the instantiation of diverse room categories (Standard, Deluxe, Suite, Executive) and validates capacity limits.
- **Observer Pattern** (`AdminObserver`, `RoomAvailabilityEvent`): Publishes real-time state changes across the system when rooms are booked or released, notifying active admin panels.
- **Repository Pattern** (`ReservationRepository`, `RoomRepository`, `GuestRepository`): Abstract data access layer shielding the application domain from SQL query mechanics.

---

## System Capabilities

- **Interactive Self-Service Kiosk:** End-to-end guest reservation wizard with room selection, occupancy specification, optional service upgrades, and immediate receipt generation.
- **Tiered Loyalty Engine:** Loyalty points accumulation system calculating earned points per stay and offering automated tier-based discounts upon checkout.
- **Comprehensive Back-Office Suite:** Front-desk tools for editing live bookings, reassigning rooms, managing waitlisted guests, and reviewing guest feedback.
- **Dynamic Pricing & Promotions:** Administrative controls to configure discount vouchers and seasonal percentage-off promotions.
- **Business Intelligence & Exports:** Generates executive occupancy and revenue reports exportable to PDF (via iText) and CSV for external bookkeeping.
- **Audit & Security:** Role-based access control (Admin/Staff), salted password hashing via BCrypt, and automated activity logging capturing operational audit trails.

---

## Tech Stack

- **Language / Platform:** Java 17+
- **UI Framework:** JavaFX, FXML, CSS styling
- **Build Tool:** Apache Maven
- **Database & Persistence:** H2 Database (embedded/JDBC), SQL schema
- **Reporting Libraries:** iText PDF library, OpenCSV
- **Security:** jBCrypt password hashing

---

## Project Structure

```text
├── docs/
│   ├── database/           # Relational schema DDL and ERD diagram
│   └── screenshots/        # Application captures across kiosk and admin flows
├── src/
│   └── main/
│       ├── java/ca/seneca/apd545/RXHgrandhotel/
│       │   ├── app/        # Main entry points, configurations, database seeder
│       │   ├── controller/ # Admin, kiosk, and feedback FXML controllers
│       │   ├── events/     # Observer pattern events and listener interfaces
│       │   ├── model/      # Domain entities, DTOs, and enumeration sets
│       │   ├── repository/ # SQL-backed database repositories
│       │   ├── security/   # BCrypt encryption and authentication service
│       │   ├── service/    # Business services, decorators, strategies, and factory
│       │   ├── session/    # Transient booking session state tracking
│       │   └── util/       # PDF and CSV exporter utilities, date handlers
│       └── resources/
│           ├── META-INF/   # Persistence configuration
│           └── view/       # FXML layout templates and modular component views
└── pom.xml                 # Maven project configuration and dependencies
```

---

## Quick Start

### Prerequisites

- Java Development Kit (JDK) version 17 or higher
- Apache Maven 3.8+

### 1. Clone the Repository

```bash
git clone https://github.com/RasaReiszadeh/grand-hotel-management-system.git
cd grand-hotel-management-system
```

### 2. Build the Project

Compile the application and download dependencies:

```bash
mvn clean compile
```

### 3. Run the Application

Launch the JavaFX interface via the Maven plugin:

```bash
mvn javafx:run
```

---

## License

Distributed under the MIT License. See [LICENSE](LICENSE) for details.
