module Post::Write
  module Cell
    class View  < Trailblazer::Cell
      include SimpleForm::ActionViewExtensions::FormHelper

      property :content
    end # New
  end
end
