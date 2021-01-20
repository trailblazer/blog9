module Post::Write
  module Cell
    class View  < Trailblazer::Cell
      include SimpleForm::ActionViewExtensions::FormHelper

      property :content

      def able?(action)
        dictionary = Workflow::Collaboration::WriteWeb.to_h[:dictionary]
        signal, (ctx, ) = Trailblazer::Workflow::Moment::Dictionary2.([{dictionary: dictionary, event_name: "web:#{action}", process_model: model}, {}])

        signal.to_h[:semantic] == :success
      end
    end # New
  end
end
