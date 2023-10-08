import React, { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";

export default function Feeds() {
  const [books, setBooks] = useState([]);
  const [loading, setLoading] = useState(true);
  const [page, setPage] = useState(1);
  const navigate = useNavigate();

  useEffect(() => {
    checkToken()
    fetchBooks(page);
  }, []);

  const checkToken = () => {
    const token = JSON.parse(localStorage.getItem("token"))

    if (!token) {
      return navigate('/');
    }
  }

  const fetchBooks = async (pageNum) => {
    const authToken = JSON.parse(localStorage.getItem("token"))
    try {
      const response = await fetch(`/api/v1/feeds?limit=${10}&offset=${pageNum}`, {
        method: 'GET',
        headers: {
          'Authorization': `Bearer ${authToken}`,
          'Content-Type': 'application/json',
        },
      });
      const data = await response.json();
      if (data.status) {
        setBooks((prevBooks) => [...prevBooks, ...data.data]);
        setLoading(false);
      }
    } catch(err) {
      console.log(err)
    }
  };

  const handleScroll = () => {
    if (
      window.innerHeight + window.scrollY >=
      document.body.scrollHeight - 500
    ) {
      setPage((prevPage) => prevPage + 1);
      fetchBooks(page + 1);
    }
  };

  useEffect(() => {
    window.addEventListener("scroll", handleScroll);

    return () => {
      window.removeEventListener("scroll", handleScroll);
    };
  }, [page]);

  return (
    <div className="mt-8 mx-80">
      <h1 className="text-2xl font-bold mb-4">Book Feed</h1>
      <div className="grid grid-cols-1 gap-4 text-center">
        {books.map((book, index) => (
          <div
            key={index}
            className="bg-white p-[30px] shadow-md rounded-md text-center my-[20px] border cursor-pointer"
            onClick={() => navigate(`/books/${book.id}`)}
          >
            <img
              src={
                book.image_links
                  ? book.image_links.thumbnail.replace(/^http:/, "https:")
                  : "https://picsum.photos/200/200?grayscale"
              }
              alt={book.title}
              height={20}
              width={200}
              className="mx-auto mb-2 rounded-md"
            />
            <h2 className="text-xl font-bold mb-2">{book.title}</h2>
            <p className="text-gray-700 mb-2">
              By: {(book.authors && book.authors.join(", ")) || "unvailable"}
            </p>
            <p className="text-gray-800 px-[20px] text-justify">
              {book.description || "No description available"}
            </p>
          </div>
        ))}
      </div>
      {loading && <p className="text-center mt-4">Loading...</p>}
    </div>
  );
}
