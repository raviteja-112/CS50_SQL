
PRAGMA foreign_keys = ON;

-- Authors table: Store book authors
CREATE TABLE authors (
    author_id INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    birth_year INTEGER,
    nationality TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Categories table: Book classification system
CREATE TABLE categories (
    category_id INTEGER PRIMARY KEY AUTOINCREMENT,
    category_name TEXT NOT NULL,
    description TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Books table: Individual book copies in library
CREATE TABLE books (
    book_id INTEGER PRIMARY KEY AUTOINCREMENT,
    isbn TEXT NOT NULL,
    title TEXT NOT NULL,
    author_id INTEGER NOT NULL,
    category_id INTEGER NOT NULL,
    publication_year INTEGER,
    publisher TEXT,
    pages INTEGER,
    location_code TEXT NOT NULL, -- Shelf location
    status TEXT NOT NULL DEFAULT 'available' CHECK (status IN ('available', 'borrowed', 'reserved', 'maintenance')),
    acquisition_date DATE DEFAULT CURRENT_DATE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (author_id) REFERENCES authors(author_id) ON DELETE RESTRICT,
    FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE RESTRICT
);

-- Members table: Library patrons
CREATE TABLE members (
    member_id INTEGER PRIMARY KEY AUTOINCREMENT,
    membership_number TEXT NOT NULL UNIQUE,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email TEXT UNIQUE,
    phone TEXT,
    address TEXT,
    join_date DATE DEFAULT CURRENT_DATE,
    membership_type TEXT NOT NULL DEFAULT 'standard' CHECK (membership_type IN ('standard', 'student', 'senior', 'premium')),
    status TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'suspended', 'expired')),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Loans table: Active borrowing records
CREATE TABLE loans (
    loan_id INTEGER PRIMARY KEY AUTOINCREMENT,
    book_id INTEGER NOT NULL,
    member_id INTEGER NOT NULL,
    loan_date DATE NOT NULL DEFAULT CURRENT_DATE,
    due_date DATE NOT NULL,
    return_date DATE NULL,
    renewal_count INTEGER DEFAULT 0,
    status TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'returned', 'overdue')),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE RESTRICT,
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE RESTRICT
);

-- Reservations table: Queue for unavailable books
CREATE TABLE reservations (
    reservation_id INTEGER PRIMARY KEY AUTOINCREMENT,
    book_id INTEGER NOT NULL,
    member_id INTEGER NOT NULL,
    reservation_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    expiry_date DATE NOT NULL,
    status TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'fulfilled', 'cancelled', 'expired')),
    queue_position INTEGER,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE RESTRICT,
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE RESTRICT
);

-- Performance optimization indexes
CREATE INDEX idx_books_isbn ON books(isbn);
CREATE INDEX idx_books_author ON books(author_id);
CREATE INDEX idx_books_category ON books(category_id);
CREATE INDEX idx_books_status ON books(status);
CREATE INDEX idx_members_membership ON members(membership_number);
CREATE INDEX idx_members_email ON members(email);
CREATE INDEX idx_loans_book ON loans(book_id);
CREATE INDEX idx_loans_member ON loans(member_id);
CREATE INDEX idx_loans_status ON loans(status);
CREATE INDEX idx_loans_due_date ON loans(due_date);
CREATE INDEX idx_reservations_book ON reservations(book_id);
CREATE INDEX idx_reservations_member ON reservations(member_id);
CREATE INDEX idx_reservations_status ON reservations(status);

-- Views for common queries
CREATE VIEW available_books AS
SELECT
    b.book_id,
    b.isbn,
    b.title,
    a.first_name || ' ' || a.last_name AS author_name,
    c.category_name,
    b.location_code,
    b.publication_year
FROM books b
JOIN authors a ON b.author_id = a.author_id
JOIN categories c ON b.category_id = c.category_id
WHERE b.status = 'available';

CREATE VIEW overdue_loans AS
SELECT
    l.loan_id,
    b.title,
    m.first_name || ' ' || m.last_name AS member_name,
    m.email,
    l.due_date,
    julianday('now') - julianday(l.due_date) AS days_overdue
FROM loans l
JOIN books b ON l.book_id = b.book_id
JOIN members m ON l.member_id = m.member_id
WHERE l.status = 'active' AND l.due_date < date('now');

-- Trigger to update book status when loan is created
CREATE TRIGGER update_book_status_on_loan
    AFTER INSERT ON loans
    WHEN NEW.status = 'active'
BEGIN
    UPDATE books SET status = 'borrowed' WHERE book_id = NEW.book_id;
END;

-- Trigger to update book status when loan is returned
CREATE TRIGGER update_book_status_on_return
    AFTER UPDATE ON loans
    WHEN NEW.return_date IS NOT NULL AND OLD.return_date IS NULL
BEGIN
    UPDATE books SET status = 'available' WHERE book_id = NEW.book_id;
END;
