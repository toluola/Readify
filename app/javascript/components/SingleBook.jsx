import React, { useState, useEffect } from 'react';
import { useParams } from 'react-router-dom';

const SingleBookDetails = () => {
  const { book_id } = useParams();
  const [bookDetail, setBookDetails] = useState({})
  const [reviews, setReviews] = useState([]);
  const [newReview, setNewReview] = useState({});
  const [likeState, setLikeStatus] = useState(false)

  useEffect(() => {
    fetchBookDetails()
  }, [])

  const fetchBookDetails = async () => {
    {console.log(book_id)}
    const authToken = JSON.parse(localStorage.getItem("token"))
    try {
      const response = await fetch(`/api/v1/books/${book_id}`, {
        method: 'GET',
        headers: {
          'Authorization': `Bearer ${authToken}`,
          'Content-Type': 'application/json',
        }
      });
      const data = await response.json();
      console.log(data)
      if (data.status) {
        setBookDetails(data.data)
        if (data.data.reviews?.length > 0) {
          setReviews(data.data.reviews)
        }
        setLikeStatus(data.liked)
      }
    } catch(err) {
      console.log(err)
    }
  }

  const handleAddReview = async () => {
    const authToken = JSON.parse(localStorage.getItem("token"))
    const token = document.querySelector('meta[name="csrf-token"]').content;
    try {
      const response = await fetch(`/api/v1/review`, {
        method: 'POST',
        headers: {
          "X-CSRF-Token": token,
          'Authorization': `Bearer ${authToken}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({content: newReview.content, book_id})
      });
      const data = await response.json();
      console.log(data)
      if (data.status) {
        setReviews([...reviews, newReview]);
        setNewReview({content: ""});
      }
    } catch(err) {
      console.log(err)
    }
  };

  const handleLikeBook = () => {
    // Add logic to handle book liking
  };

  return (
    <div className="container mx-auto mt-8">
      <div className="max-w-xl mx-auto p-8 bg-white rounded shadow-lg">
        <h1 className="text-2xl font-bold mb-4">{bookDetail.title}</h1>
        <div className="mb-4">
          <img
            src={bookDetail.image_links?.thumbnail || "https://placekitten.com/300/200"}
            alt="Book Cover"
            className="mx-auto mb-4 rounded-md"
            width={200}
            height={20}
          />
          <button onClick={handleLikeBook} className="bg-blue-500 text-white px-4 py-2 rounded-md">
            {likeState ? "Unlike Book" : "Like Book"}
          </button>
        </div>
        <div className="mb-4">
          <h2 className="text-xl font-bold mb-2">Book Reviews</h2>
          {reviews.map((review, index) => (
            <div key={index} className="bg-gray-100 p-2 mb-2 rounded-md">
              {review.content}
            </div>
          ))}
        </div>
        <div>
          <h2 className="text-xl font-bold mb-2">Add a Review</h2>
          <textarea
            value={newReview.content}
            onChange={(e) => setNewReview({id: null, content: e.target.value})}
            className="w-full p-2 border border-gray-300 rounded-md mb-4"
            rows="4"
            placeholder="Write your review here..."
          />
          <button onClick={handleAddReview} className="bg-blue-500 text-white px-4 py-2 rounded-md">
            Add Review
          </button>
        </div>
      </div>
    </div>
  );
}

export default SingleBookDetails;
