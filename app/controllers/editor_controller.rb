class EditorController < WorkflowController
  def review_posting
    # trigger "☝ ⏵︎Create form", adapter: Posting::Endpoint::Adapter do # we don't need the Model::Find step in Protocol.
    #   success { |ctx, contract:, model:, **| render locals: {contract: contract, form_url: create_posting_path, verb: "Create", model: model} }
    # end
    render :review_posting, locals: {model: Posting.find(params[:id])} # TODO: either use OP, or endpoint or add show to <ui>?
  end

  def approve_posting
    trigger "☑ ⏵︎Approve" do #
      # success { |ctx, model:, **| redirect_to editor_dashboard_path }
      success { |ctx, model:, **| redirect_to show_posting_path(model.id) }
    end
  end

  def reject_posting
    trigger "☑ ⏵︎Reject" do #
      success { |ctx, model:, **| redirect_to editor_dashboard_path }
    end
  end

  def dashboard
    render html: "Dashboard"
  end
end
