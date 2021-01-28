module Post::Operation::Web
  class Review < Trailblazer::Operation # DISCUSS: make Review::Operation::New
    class Form < Reform::Form
      property :suggestions
      # validates :suggestions, presence: true
    end

    step Model(::Review, :new)
    step Contract::Build(constant: Form)
  end # Review
end
