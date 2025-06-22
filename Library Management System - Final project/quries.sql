
-- Insert sample data for testing
INSERT INTO authors (first_name, last_name, birth_year, nationality) VALUES
('George', 'Orwell', 1903, 'British'),
('Jane', 'Austen', 1775, 'British'),
('Mark', 'Twain', 1835, 'American');

INSERT INTO categories (category_name, description) VALUES
('Fiction', 'Novels and short stories'),
('Classic Literature', 'Timeless literary works'),
('Science Fiction', 'Futuristic and speculative fiction');

-- Query 1: Find all available books by a specific author
-- Performance: Uses index on author_id and status
SELECT
    b.title,
    b.isbn,
    c.category_name,
    b.location_code
FROM books b
JOIN authors a ON b.author_id = a.author_id
JOIN categories c ON b.category_id = c.category_id
WHERE a.last_name = 'Orwell'
  AND b.status = 'available'
ORDER BY b.title;

-- Query 2: List all overdue loans with member contact information
-- Performance: Uses indexes on status and due_date
SELECT
    m.membership_number,
    m.first_name || ' ' || m.last_name AS member_name,
    m.email,
    m.phone,
    b.title,
    l.due_date,
    julianday('now') - julianday(l.due_date) AS days_overdue
FROM loans l
JOIN members m ON l.member_id = m.member_id
JOIN books b ON l.book_id = b.book_id
WHERE l.status = 'active'
  AND l.due_date < date('now')
ORDER BY days_overdue DESC;

-- Query 3: Check book availability and reservation queue
-- Shows current status and who's waiting
SELECT
    b.title,
    b.status,
    CASE
        WHEN b.status = 'borrowed' THEN
            (SELECT m.first_name || ' ' || m.last_name
             FROM loans l JOIN members m ON l.member_id = m.member_id
             WHERE l.book_id = b.book_id AND l.status = 'active')
        ELSE NULL
    END AS current_borrower,
    (SELECT COUNT(*) FROM reservations r WHERE r.book_id = b.book_id AND r.status = 'active') AS queue_length
FROM books b
WHERE b.isbn = '9780451524935'
ORDER BY b.book_id;

-- Query 4: Monthly circulation statistics
-- Aggregates loan data for reporting
SELECT
    strftime('%Y-%m', l.loan_date) AS month,
    COUNT(*) AS total_loans,
    COUNT(DISTINCT l.member_id) AS unique_borrowers,
    COUNT(DISTINCT l.book_id) AS unique_books
FROM loans l
WHERE l.loan_date >= date('now', '-12 months')
GROUP BY strftime('%Y-%m', l.loan_date)
ORDER BY month DESC;

-- Query 5: Popular books report (most borrowed)
-- Performance: Uses aggregation with proper indexing
SELECT
    b.title,
    a.first_name || ' ' || a.last_name AS author_name,
    c.category_name,
    COUNT(l.loan_id) AS loan_count,
    COUNT(r.reservation_id) AS current_reservations
FROM books b
JOIN authors a ON b.author_id = a.author_id
JOIN categories c ON b.category_id = c.category_id
LEFT JOIN loans l ON b.book_id = l.book_id
LEFT JOIN reservations r ON b.book_id = r.book_id AND r.status = 'active'
GROUP BY b.book_id, b.title, author_name, c.category_name
HAVING loan_count > 0
ORDER BY loan_count DESC, current_reservations DESC
LIMIT 10;

-- Query 6: Member activity summary
-- Shows borrowing patterns and current status
SELECT
    m.membership_number,
    m.first_name || ' ' || m.last_name AS member_name,
    m.membership_type,
    COUNT(l.loan_id) AS total_loans,
    COUNT(CASE WHEN l.status = 'active' THEN 1 END) AS current_loans,
    COUNT(CASE WHEN l.return_date > l.due_date THEN 1 END) AS late_returns,
    COUNT(r.reservation_id) AS active_reservations
FROM members m
LEFT JOIN loans l ON m.member_id = l.member_id
LEFT JOIN reservations r ON m.member_id = r.member_id AND r.status = 'active'
WHERE m.status = 'active'
GROUP BY m.member_id, m.membership_number, member_name, m.membership_type
ORDER BY total_loans DESC;

-- Query 7: Transaction for borrowing a book
-- Demonstrates proper transaction handling
BEGIN TRANSACTION;

-- Check if book is available
SELECT book_id, status FROM books WHERE book_id = ? AND status = 'available';

-- If available, create loan record
INSERT INTO loans (book_id, member_id, due_date)
VALUES (?, ?, date('now', '+14 days'));

-- Book status will be updated automatically by trigger

COMMIT;

-- Query 8: Handle book return with validation
-- Updates loan record and restores book availability
UPDATE loans
SET return_date = CURRENT_DATE,
    status = 'returned'
WHERE loan_id = ?
  AND status = 'active'
  AND return_date IS NULL;

-- Check if there are pending reservations for this book
SELECT r.reservation_id, r.member_id, m.email
FROM reservations r
JOIN members m ON r.member_id = m.member_id
WHERE r.book_id = (SELECT book_id FROM loans WHERE loan_id = ?)
  AND r.status = 'active'
ORDER BY r.reservation_date
LIMIT 1;
