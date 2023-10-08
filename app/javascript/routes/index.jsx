import React from "react";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import Login from "../components/Login";
import SignUp from "../components/SignUp";
import Feeds from "../components/Feeds";
import SingleBookDetails from "../components/SingleBook";

export default (
  <Router>
    <Routes>
      <Route path="/" element={<Login />} />
      <Route path="/signup" element={<SignUp />} />
      <Route path="/feeds" element={<Feeds />} />
      <Route path="/books/:book_id" element={<SingleBookDetails />} />
    </Routes>
  </Router>
);
