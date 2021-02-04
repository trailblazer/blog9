class Post < ApplicationRecord
  has_many :reviews

  def review # TODO: test
    reviews.last
  end
end
