
# Library Management System (LMS)
**Author:** Raviteja Panga

---

## 1. Scope

At its heart, this system is the digital brain for a physical library. Its purpose is to bring order and efficiency to the core activities that make a library work: managing the book collection, keeping track of members, and handling the constant flow of books being borrowed and returned. We want a reliable, fast, and intuitive system that librarians can depend on every day.

The scope of this database is focused on the core operational entities:

*   **Book Collection:** Managing every individual physical book, its metadata (title, author), and its status within the library.
*   **Library Members:** Maintaining a comprehensive record of library patrons, their membership details, and status.
*   **Circulation:** Tracking the complete lifecycle of a book loan, from checkout to return, as well as managing reservations for high-demand books.

Out of scope for this iteration are the library's finances (including fine calculation), digital media management (e-books), and staff scheduling.

## 2. Functional Requirements

This database will support:

*   **Book Management:** Adding new books to the catalog, updating details, and changing a book's status (e.g., to 'maintenance').
*   **Member Management:** Registering new members, updating their information, and managing their membership status (e.g., 'active', 'suspended').
*   **Loan Processing:** Creating a `Loan` when a member checks out a book and updating its status upon return.
*   **Reservation Handling:** Placing a member in a queue for a book that is currently unavailable.
*   **Searching:** Allowing the application to efficiently search for books (by title, ISBN), members (by name, email, membership number), and authors.

## 3. Representation (Database Schema)

The data is structured into the following SQL tables.

### 3.1 Entities

#### `authors`
Stores a unique record for each author.

| Column | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `author_id` | INTEGER | PRIMARY KEY AUTOINCREMENT | Unique identifier for the author. |
| `first_name`| TEXT | NOT NULL | Author's first name. |
| `last_name` | TEXT | NOT NULL | Author's last name. |
| `birth_year`| INTEGER | | Author's year of birth. |
| `nationality`| TEXT | | Author's nationality. |
| `created_at`| DATETIME | DEFAULT CURRENT_TIMESTAMP | Timestamp of record creation. |

#### `categories`
Stores the list of genres or classifications for books.

| Column | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `category_id` | INTEGER | PRIMARY KEY AUTOINCREMENT | Unique identifier for the category. |
| `category_name`| TEXT | NOT NULL | Name of the category (e.g., "Sci-Fi"). |
| `description` | TEXT | | A brief description of the category. |
| `created_at`| DATETIME | DEFAULT CURRENT_TIMESTAMP | Timestamp of record creation. |

#### `books`
Tracks each physical copy of a book, including its metadata.

| Column | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `book_id` | INTEGER | PRIMARY KEY AUTOINCREMENT | Unique identifier for the physical book. |
| `isbn` | TEXT | NOT NULL | ISBN, unique for a book edition. |
| `title` | TEXT | NOT NULL | Title of the book. |
| `author_id` | INTEGER | NOT NULL, FOREIGN KEY | Links to the `authors` table. |
| `category_id`| INTEGER | NOT NULL, FOREIGN KEY | Links to the `categories` table. |
| `status` | TEXT | NOT NULL, CHECK | Current status: 'available', 'borrowed', 'reserved', 'maintenance'. |
| `location_code`| TEXT | NOT NULL | Physical shelf location in the library. |
| `...` | `...` | | *Other metadata like publisher, pages, etc.* |

#### `members`
Holds information for all library patrons.

| Column | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `member_id` | INTEGER | PRIMARY KEY AUTOINCREMENT | Unique identifier for the member. |
| `membership_number`| TEXT | NOT NULL, UNIQUE | Library-issued unique ID for the member. |
| `first_name`| TEXT | NOT NULL | Member's first name. |
| `last_name` | TEXT | NOT NULL | Member's last name. |
| `email` | TEXT | UNIQUE | Member's email address. |
| `membership_type`| TEXT | NOT NULL, CHECK | 'standard', 'student', 'senior', 'premium'. |
| `status` | TEXT | NOT NULL, CHECK | 'active', 'suspended', 'expired'. |
| `...` | `...` | | *Other contact info and join date.* |

#### `loans`
Records every borrowing transaction.

| Column | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `loan_id` | INTEGER | PRIMARY KEY AUTOINCREMENT | Unique identifier for the loan. |
| `book_id` | INTEGER | NOT NULL, FOREIGN KEY | Links to the specific `book` being loaned. |
| `member_id` | INTEGER | NOT NULL, FOREIGN KEY | Links to the `member` borrowing the book. |
| `due_date` | DATE | NOT NULL | Date the book is due for return. |
| `return_date`| DATE | NULL | Date the book was returned (`NULL` if active). |
| `status` | TEXT | NOT NULL, CHECK | 'active', 'returned', 'overdue'. |
| `...` | `...` | | *Other info like loan date, renewals.* |

#### `reservations`
Manages the waiting list for unavailable books.

| Column | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `reservation_id` | INTEGER | PRIMARY KEY AUTOINCREMENT | Unique identifier for the reservation. |
| `book_id` | INTEGER | NOT NULL, FOREIGN KEY | Links to the desired `book`. |
| `member_id` | INTEGER | NOT NULL, FOREIGN KEY | Links to the `member` making the reservation. |
| `status` | TEXT | NOT NULL, CHECK | 'active', 'fulfilled', 'cancelled', 'expired'. |
| `...` | `...` | | *Other info like dates and queue position.* |

### 3.2 Relationships
*   A **Book** has exactly one **Author** and one **Category**.
*   An **Author** can be associated with many **Books**.
*   A **Category** can contain many **Books**.
*   A **Member** can have many **Loans** and many **Reservations**.
*   A **Loan** or **Reservation** is tied to exactly one **Book** and one **Member**.

![schmea](schema.svg)

## 4. Optimizations

To ensure high performance and data integrity, the following optimizations are built into the schema.

### 4.1 Indexes
Indexes are created on frequently searched or joined columns to accelerate query performance.
*   **Book Lookups:** `idx_books_isbn`, `idx_books_author`, `idx_books_category`, `idx_books_status`.
*   **Member Lookups:** `idx_members_membership`, `idx_members_email`.
*   **Loan/Reservation Lookups:** `idx_loans_book`, `idx_loans_member`, `idx_loans_status`, `idx_loans_due_date`, `idx_reservations_book`, `idx_reservations_member`, `idx_reservations_status`.

### 4.2 Views
Views provide simplified, pre-joined access to common data sets.
*   `available_books`: A view that lists all books with a status of 'available', joining book, author, and category information for a user-friendly display.
*   `overdue_loans`: A dynamic view that lists all loans currently past their `due_date`, calculating the number of days overdue.

### 4.3 Triggers
Triggers automate key business logic at the database level, ensuring data consistency.
*   `update_book_status_on_loan`: When a new loan is created, this trigger automatically updates the corresponding book's status to 'borrowed'.
*   `update_book_status_on_return`: When a loan's `return_date` is set, this trigger automatically updates the book's status back to 'available', making it ready for the next patron.

## 5. Limitations

This design makes specific trade-offs for simplicity and focus.

*   **Single Author per Book:** The schema links each book to a single author (`author_id`). It does not natively support co-authored books. A workaround would be to create a primary author entry, but a future enhancement could involve a junction table for many-to-many author relationships.
*   **Data Redundancy in `books` Table:** By storing title, ISBN, and other metadata directly in the `books` table for each physical copy, some data is duplicated. This simplifies queries but can be less efficient for storage and updates compared to a normalized design with separate "title" and "copy" tables.
*   **Application-Layer Business Logic:** While triggers handle some automation, more complex business rules are not enforced by the database. For example, the rule "a member can only borrow 5 books at a time" must be handled by the application software before it attempts to insert a new loan record.
