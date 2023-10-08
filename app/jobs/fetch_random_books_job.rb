require 'rest-client'

class FetchRandomBooksJob < ApplicationJob
  queue_as :default

  API_URL = 'https://www.googleas.com/books/v1/volumes'
  API_KEY = '' # Replace with your actual API key

  def perform
    books_data = get_random_books

    books_data.each do |book_data|
      Book.create!(
        title: book_data[:title],
        authors: book_data[:authors],
        publisher: book_data[:publisher],
        published_date: book_data[:publishedDate],
        description: book_data[:description],
        image_links: book_data[:imageLinks],
        category: book_data[:category],
        preview_link: book_data[:previewLink]
      )
    end
    # Process the books or save them to the database, as needed
  end

  private

  def keyword_sample
    keywords = ['fiction', 'fantasy', 'mystery', 'history', 'science', 'romance', 'adventure', 'technology']
    random_keyword = keywords.sample
  end

  def generate_random_query
    random_year = rand(1990..2023)
    "#{keyword_sample} #{random_year}"
  end

  def get_random_books
    books = []
    random_keyword = keyword_sample

    80.times do
      random_query = generate_random_query
      response = RestClient.get("#{API_URL}?q=#{random_query}&key=#{API_KEY}")

      if response.code == 200
        data = JSON.parse(response.body)
        if data['items'] && data['items'].any?
          random_book = data['items'].sample['volumeInfo']
          books << {
            title: random_book['title'],
            authors: random_book['authors'],
            publisher: random_book['publisher'],
            publishedDate: random_book['publishedDate'],
            description: random_book["description"],
            imageLinks: random_book["imageLinks"],
            category: random_keyword,
            previewLink: random_book["previewLink"]
          }
        end
      else
        Rails.logger.error("Error fetching data: #{response.body}")
      end
    end

    books
  end
end
