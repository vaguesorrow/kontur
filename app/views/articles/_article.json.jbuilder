json.extract! article, :id, :user_id, :title, :body, :cover_url, :published, :created_at, :updated_at
json.url article_url(article, format: :json)
