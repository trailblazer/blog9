module Review::Cell
  class Sent  < Trailblazer::Cell
    # include SimpleForm::ActionViewExtensions::FormHelper
    property :suggestions

    def post
      model.post
    end
  end # Sent
end
