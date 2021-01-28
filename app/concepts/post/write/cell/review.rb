module Post::Write
  module Cell
    class Review  < Trailblazer::Cell
      include SimpleForm::ActionViewExtensions::FormHelper

      def review_form
        @options[:review_form] or raise
      end
    end # New
  end
end
