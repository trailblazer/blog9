module Post::Write
  module Cell
    class View  < Trailblazer::Cell
      include SimpleForm::ActionViewExtensions::FormHelper

      def able?(action)
        dictionary = Workflow::Collaboration::WriteWeb.to_h[:dictionary]
        signal, (ctx, ) = Trailblazer::Workflow::Moment::Runtime.([{dictionary: dictionary, event_name: "web:#{action}", process_model: model}, {}])

        signal.to_h[:semantic] == :success
      end

      class Show < Trailblazer::Cell
        extend ViewName::Flat

        property :content

        def state
          if model.state == "waiting for review" # FIXME: how to encapsulate that?
            "Post is under review"
          elsif model.state == "edit requested" # FIXME: how to encapsulate that?
            "Review finished, changes suggested"
          elsif model.state == "approved, ready to publish" # FIXME: how to encapsulate that?
            "Approved, ready to publish"
          end
        end
      end
    end # New
  end
end
