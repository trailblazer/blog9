module Post::Write
  module Cell
    class Revise  < Trailblazer::Cell
      def suggestions
        @options[:review].suggestions
      end
    end # Revise
  end
end
