// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Perpustakaan {
    struct Book {
        string title;
        string author;
        uint year;
        bytes32 isbn;
    }
    
   Book[] public books;
mapping(bytes32 => uint) public indexBook;
    function getisbn(string calldata _title) public pure returns (bytes32){
            bytes32 randomisbn = keccak256(abi.encodePacked(_title));

        return randomisbn;
    }

    function getAllBooks() public view returns (Book[] memory) {
        return books;
    }

    function addBook( string calldata _title, string calldata author, uint year) public {
        Book memory newBooks = Book({
            isbn: getisbn(_title),
            title: _title,
            year: year,
            author: author
        });

        books.push(newBooks);

        indexBook[newBooks.isbn] = books.length;
    }

    function updateBook(bytes32 isbn, string calldata title, string calldata author, uint256 year) public {
        require(bookExist(isbn),"buku tidak ditemukan");
        uint getIndex = indexBook[isbn] - 1;

        books[getIndex] = Book({
            isbn: getisbn(title),
            title: title,
            year: year,
            author: author
        });

        indexBook[books[getIndex].isbn] = getIndex + 1;
        delete indexBook[isbn];
        }

    function deleteBook(bytes32 isbn) public {
        require(bookExist(isbn),"buku tidak ditemukan");
        uint getIndex = indexBook[isbn] - 1;
        Book memory lastBook = books[books.length - 1];

        books[getIndex] = lastBook;
        indexBook[lastBook.isbn] = getIndex + 1;

        delete indexBook[isbn];
        books.pop();
    }

    function getBookData(bytes32 isbn) public view returns (bytes32, string memory, uint256, string memory) {
       require(bookExist(isbn),"buku tidak ditemukan");
        uint getIndex = indexBook[isbn] - 1;

        return (
            books[getIndex].isbn,
            books[getIndex].title,
            books[getIndex].year,
            books[getIndex].author
        );
    }

   function bookExist(bytes32 _isbn) public view returns (bool) {
        return indexBook[_isbn] != 0;
    }
}
