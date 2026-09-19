PRAGMA foreign_keys = ON;

-- ===========================
-- GUEST
-- ===========================
CREATE TABLE guest (
    guest_id        INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name      TEXT NOT NULL,
    last_name       TEXT NOT NULL,
    phone           TEXT,
    email           TEXT,
    loyalty_number  TEXT UNIQUE,
    created_at      TEXT DEFAULT CURRENT_TIMESTAMP
);

-- ===========================
-- ADMIN
-- ===========================
CREATE TABLE admin (
    admin_id        INTEGER PRIMARY KEY AUTOINCREMENT,
    username        TEXT UNIQUE NOT NULL,
    password_hash   TEXT NOT NULL,
    role            TEXT NOT NULL CHECK (role IN ('ADMIN','MANAGER'))
);

-- ===========================
-- ROOM TYPE
-- ===========================
CREATE TABLE room_type (
    room_type_id    INTEGER PRIMARY KEY AUTOINCREMENT,
    name            TEXT NOT NULL UNIQUE,
    base_price      REAL NOT NULL,
    max_occupancy   INTEGER NOT NULL
);

-- ===========================
-- ROOM
-- ===========================
CREATE TABLE room (
    room_id         INTEGER PRIMARY KEY AUTOINCREMENT,
    room_number     TEXT UNIQUE NOT NULL,
    room_type_id    INTEGER NOT NULL,
    FOREIGN KEY (room_type_id) REFERENCES room_type(room_type_id)
);

-- ===========================
-- RESERVATION
-- ===========================
CREATE TABLE reservation (
    reservation_id  INTEGER PRIMARY KEY AUTOINCREMENT,
    guest_id        INTEGER NOT NULL,
    check_in_date   TEXT NOT NULL,
    check_out_date  TEXT NOT NULL,
    status          TEXT NOT NULL,
    created_at      TEXT DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (guest_id) REFERENCES guest(guest_id)
);

-- ===========================
-- RESERVATION ROOM (group bookings)
-- ===========================
CREATE TABLE reservation_room (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    reservation_id  INTEGER NOT NULL,
    room_id         INTEGER NOT NULL,
    FOREIGN KEY (reservation_id) REFERENCES reservation(reservation_id) ON DELETE CASCADE,
    FOREIGN KEY (room_id) REFERENCES room(room_id)
);

-- ===========================
-- ADD-ON SERVICES
-- ===========================
CREATE TABLE addon_service (
    addon_id        INTEGER PRIMARY KEY AUTOINCREMENT,
    name            TEXT NOT NULL UNIQUE,
    price           REAL NOT NULL,
    pricing_model   TEXT NOT NULL CHECK (pricing_model IN ('PER_NIGHT','PER_RESERVATION'))
);

-- ===========================
-- RESERVATION ADD-ONS
-- ===========================
CREATE TABLE reservation_addon (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    reservation_id  INTEGER NOT NULL,
    addon_id        INTEGER NOT NULL,
    FOREIGN KEY (reservation_id) REFERENCES reservation(reservation_id) ON DELETE CASCADE,
    FOREIGN KEY (addon_id) REFERENCES addon_service(addon_id)
);

-- ===========================
-- PAYMENTS
-- ===========================
CREATE TABLE payment (
    payment_id      INTEGER PRIMARY KEY AUTOINCREMENT,
    reservation_id  INTEGER NOT NULL,
    amount          REAL NOT NULL,
    method          TEXT NOT NULL CHECK (method IN ('CASH','CARD','LOYALTY')),
    timestamp       TEXT DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (reservation_id) REFERENCES reservation(reservation_id) ON DELETE CASCADE
);

-- ===========================
-- DISCOUNTS
-- ===========================
CREATE TABLE discount (
    discount_id     INTEGER PRIMARY KEY AUTOINCREMENT,
    reservation_id  INTEGER NOT NULL,
    admin_id        INTEGER NOT NULL,
    percent         REAL NOT NULL,
    timestamp       TEXT DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (reservation_id) REFERENCES reservation(reservation_id),
    FOREIGN KEY (admin_id) REFERENCES admin(admin_id)
);

-- ===========================
-- LOYALTY ACCOUNT
-- ===========================
CREATE TABLE loyalty_account (
    loyalty_id      INTEGER PRIMARY KEY AUTOINCREMENT,
    guest_id        INTEGER NOT NULL UNIQUE,
    points_balance  INTEGER NOT NULL DEFAULT 0,
    FOREIGN KEY (guest_id) REFERENCES guest(guest_id)
);

-- ===========================
-- LOYALTY TRANSACTIONS
-- ===========================
CREATE TABLE loyalty_transaction (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    loyalty_id      INTEGER NOT NULL,
    points          INTEGER NOT NULL,
    type            TEXT NOT NULL CHECK (type IN ('EARN','REDEEM')),
    timestamp       TEXT DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (loyalty_id) REFERENCES loyalty_account(loyalty_id)
);

-- ===========================
-- WAITLIST
-- ===========================
CREATE TABLE waitlist (
    waitlist_id     INTEGER PRIMARY KEY AUTOINCREMENT,
    guest_id        INTEGER NOT NULL,
    room_type_id    INTEGER NOT NULL,
    start_date      TEXT NOT NULL,
    end_date        TEXT NOT NULL,
    created_at      TEXT DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (guest_id) REFERENCES guest(guest_id),
    FOREIGN KEY (room_type_id) REFERENCES room_type(room_type_id)
);

-- ===========================
-- FEEDBACK
-- ===========================
CREATE TABLE feedback (
    feedback_id     INTEGER PRIMARY KEY AUTOINCREMENT,
    reservation_id  INTEGER NOT NULL,
    guest_id        INTEGER NOT NULL,
    rating          INTEGER NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comments        TEXT,
    submitted_at    TEXT DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (reservation_id) REFERENCES reservation(reservation_id),
    FOREIGN KEY (guest_id) REFERENCES guest(guest_id)
);

-- ===========================
-- ACTIVITY LOG
-- ===========================
CREATE TABLE activity_log (
    log_id          INTEGER PRIMARY KEY AUTOINCREMENT,
    admin_id        INTEGER,
    action          TEXT NOT NULL,
    entity_type     TEXT,
    entity_id       INTEGER,
    message         TEXT,
    timestamp       TEXT DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (admin_id) REFERENCES admin(admin_id)
);
