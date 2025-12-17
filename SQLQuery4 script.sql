create database library1;
use library1;

create table library (
    library_id int identity(1,1) primary key,
    name varchar(100) not null unique,         -- Library name must be unique
    location varchar(100) not null,            -- Location is required
    contactnumber varchar(20) not null,        -- Contact number is required
    establishedyear int                        -- Optional year of establishment
);

-- Book table: stores books in the library

create table book (
    book_id int identity(1,1) primary key,
    isbn varchar(20) not null unique,               -- ISBN must be unique
    title varchar(100) not null,                   -- Title is required
    price decimal(8,2) not null check (price > 0),     -- Price must be greater than 0
    isavailable bit not null default 1,            -- Default availability = TRUE
    genre varchar(50) not null check (genre in ('Fiction','Non-fiction','Reference','Children')), -- Genre restricted
    shelflocation varchar(50) not null,        -- Shelf location required
    library_id int not null,
    foreign key (library_id) references library(library_id)
        on delete cascade on update cascade
);

-- Staff table: stores employees of the library
create table staff (
    staff_id int identity(1,1) primary key,
    fullname varchar(100) not null,            -- Staff full name required
    position varchar(50),                      -- Position optional
    contactnumber varchar(20),                 -- Contact number optional
    library_id int not null,
    foreign key (library_id) references library(library_id)
        on delete cascade on update cascade
);

-- Member table: stores library members
create table member (
    member_id int identity(1,1) primary key,
    fullname varchar(100) not null,            -- Member full name required
    email varchar(100) not null unique,        -- Email must be unique
    membershipstartdate date not null,         -- Membership start date required
    phonenumber varchar(20)                    -- Phone number optional
);

-- Loan table: records book loans (staff_id removed, no invalid CHECK)

create table loan (
    loan_id int identity(1,1) primary key,     -- Auto-increment loan ID
    loandate date not null,                    -- Loan date required
    duedate date not null,                     -- Due date required
    returndate date,                           -- Return date (cannot enforce >= loandate with CHECK in SQL Server)
    status varchar(20) not null default 'Issued'
        check (status in ('Issued','Returned','Overdue')), -- Status restricted
    member_id int not null,                    -- FK to member
    book_id int not null,                      -- FK to book

    foreign key (member_id) references member(member_id)
        on delete cascade on update cascade,
    foreign key (book_id) references book(book_id)
        on delete cascade on update cascade
);

-- Review table: stores reviews of books by members
create table review (
    review_id int identity(1,1) primary key,
    rating int not null check (rating between 1 and 5), -- Rating must be 1–5
    comments text default 'No comments',                -- Default if not provided
    reviewdate date not null,                           -- Review date required
    book_id int not null,
    member_id int not null,
    foreign key (book_id) references book(book_id)
        on delete cascade on update cascade,
    foreign key (member_id) references member(member_id)
        on delete cascade on update cascade
);

-- Payment table: records payments related to loans
create table payment (
    payment_id int identity(1,1) primary key,
    paymentdate date not null,               -- Payment date required
    amount decimal(8,2) not null check (amount > 0), -- Amount must be > 0
    method varchar(50),                      -- Payment method optional
    loan_id int not null,
    foreign key (loan_id) references loan(loan_id)
        on delete cascade on update cascade
);


-----insert


-- Insert into Library
insert into library (name, location, contactnumber, establishedyear)
values 
('Central Library', 'Muscat', '91234567', 1990),
('North Branch', 'Sohar', '92345678', 2000),
('East Branch', 'Sur', '93456789', 2010),
('West Branch', 'Nizwa', '94567890', 2015);

select*from library

-- Insert into Book
insert into book (isbn, title, price, genre, shelflocation, library_id)
values
('978-1111111111', 'Database Systems', 25.50, 'Reference', 'A1', 1),
('978-2222222222', 'Children Stories', 10.00, 'Children', 'B2', 1),
('978-3333333333', 'Fiction Novel', 15.75, 'Fiction', 'C3', 2),
('978-4444444444', 'Science Facts', 20.00, 'Non-fiction', 'D4', 2),
('978-5555555555', 'Programming Basics', 30.00, 'Reference', 'E5', 3);

select*from book

-- Insert into Staff
insert into staff (fullname, position, contactnumber, library_id)
values
('Ali Hassan', 'Manager', '95123456', 1),
('Fatima Said', 'Assistant', '95234567', 1),
('Omar Khalid', 'Librarian', '95345678', 2),
('Sara Ahmed', 'Technician', '95456789', 3);

select*from staff

-- Insert into Member
insert into member (fullname, email, membershipstartdate, phonenumber)
values
('Mohammed Ali', 'mohammed@example.com', '2023-01-10', '96123456'),
('Aisha Noor', 'aisha@example.com', '2023-02-15', '96234567'),
('Khalid Yousuf', 'khalid@example.com', '2023-03-20', '96345678'),
('Layla Hassan', 'layla@example.com', '2023-04-25', '96456789');

select*from member 

-- Insert into Loan
insert into loan (loandate, duedate, returndate, status, member_id, book_id)
values
('2023-05-01', '2023-05-15', '2023-05-10', 'Returned', 1, 1),
('2023-06-01', '2023-06-15', null, 'Issued', 2, 2),
('2023-07-01', '2023-07-15', '2023-07-20', 'Overdue', 3, 3),
('2023-08-01', '2023-08-15', null, 'Issued', 4, 4);

select*from loan

-- Insert into Review
insert into review (rating, comments, reviewdate, book_id, member_id)
values
(5, 'Excellent book!', '2023-05-12', 1, 1),
(4, 'Very useful reference.', '2023-06-18', 2, 2),
(3, 'Good but a bit long.', '2023-07-22', 3, 3),
(2, 'Not very interesting.', '2023-08-05', 4, 4);

select*from review

-- Insert into Payment
insert into payment (paymentdate, amount, method, loan_id)
values
('2023-05-12', 5.00, 'Cash', 1),
('2023-07-22', 10.00, 'Card', 3),
('2023-08-10', 7.50, 'Cash', 4),
('2023-09-01', 12.00, 'Online', 2)

select*from payment



-- DQL 

-- 1. Display all book record

select * from book;

-- 2. Display each book’s title, genre, and availability

select title, genre, isavailable from book;

-- 3. Display all member names, email, and membership start date

select fullname, email, membershipstartdate from member;

-- 4. Display each book’s title and price as BookPrice

select title, price as BookPrice from book;

-- 5. List books priced above 250 LE

select * from book where price > 250;

-- 6. List members who joined before 2023

select * from member where membershipstartdate < '2023-01-01';

-- 7. Display books published after 2018
-- (Requires publishedyear column in book table)

--Alter the Book table to add publishedyear
alter table book
add publishedyear int;   -- Year the book was published

----Insert or update sample data with published years

update book set publishedyear = 2015 where book_id = 1;
update book set publishedyear = 2019 where book_id = 2;
update book set publishedyear = 2020 where book_id = 3;
update book set publishedyear = 2021 where book_id = 4;
update book set publishedyear = 2022 where book_id = 5;
---Run-----

select * from book where publishedyear > 2018;


-- 8. Display books ordered by price descending

select * from book order by price desc;

-- 9. Display the maximum, minimum, and average book price

select max(price) as MaxPrice, min(price) as MinPrice, avg(price) as AvgPrice from book;

-- 10. Display total number of books

select count(*) as TotalBooks from book;

-- 11. Display members with NULL email

select * from member where email is null;

-- 12. Display books whose title contains 'Data'

select * from book where title like '%Data%'

-- DML 

-- 13. Insert yourself as a member (Member ID = 405)

set identity_insert member on;
insert into member (member_id, fullname, email, membershipstartdate, phonenumber)
values (405, 'MKM', 'mkmalaufi@gmail.com', getdate(), '97123456');
set identity_insert member off;
select*from member;

-- 14. Register yourself to borrow book ID = 1011
-- Step A: Insert book 1011 (only if it doesn’t exist yet)
set identity_insert book on;
insert into book (book_id, isbn, title, price, genre, shelflocation, library_id)
values (1011, '978-1011000000', 'Special Book', 150.00, 'Reference', 'ShelfX', 1);
set identity_insert book off;

-- Step B: Register the loan
insert into loan (loandate, duedate, returndate, status, member_id, book_id)
values (getdate(), dateadd(day, 14, getdate()), null, 'Issued', 405, 1011);

-- Step C: Verify
select loan_id, member_id, book_id, loandate, duedate, status
from loan
where member_id = 405 and book_id = 1011;


-- 15. Insert another member with NULL email and phone

---Provide a value for email
insert into member (fullname, email, membershipstartdate, phonenumber)
values ('Test Member', 'munaa@gmail.com', getdate(), null);

----Allow NULL in email
alter table member
alter column email varchar(100) null;

----insert with NULL

insert into member (fullname, email, membershipstartdate, phonenumber)
values ('Test Member', null, getdate(), null);

select*from member;

-- 16. Update the return date of your loan to today
delete from loan
where member_id = 1 and book_id = 1011;

update loan
set member_id = 405
where member_id = 1 and book_id = 1011;

select loan_id, member_id, book_id, loandate, duedate, returndate, status
from loan
where book_id = 1011;
select*from loan;

-- 17. Increase book prices by 5% for books priced under 200
update book
set price = price * 1.05
where price < 200;
select*from book;

-- 18. Update member status to 'Active' for recently joined members
-- (Requires status column in member table)
alter table member
add status varchar(20);

update member
set status = 'Active'
where membershipstartdate >= '2023-01-01';

select*from member;




-- 19. Delete members who never borrowed a book
delete from member
where member_id not in (select distinct member_id from loan);
 
 select*from member;