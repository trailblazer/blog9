module Post::Write
  module Cell
    class New  < Trailblazer::Cell
      include SimpleForm::ActionViewExtensions::FormHelper

      def form_url
        @options[:form_url]
      end
    end # New
  end
end
