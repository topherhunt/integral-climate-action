class ResourcesController < ApplicationController
  before_action :require_logged_in, only: [:new, :create, :edit, :update, :destroy]
  before_action :load_resource, only: [:show, :edit, :update, :destroy]
  before_action :load_target, only: [:new, :create]
  before_action :verify_ownership, only: [:edit, :update, :destroy]

  def index
    @most_popular_resources = Resource.order("viewings DESC").limit(8)
    @recent_events = Event.where(target_type: "Resource").latest(5)
    @tag_counts = Resource.order("created_at DESC").limit(100)
      .tag_counts_on(:tags)
      .sort_by(&:name)
  end

  def show
    @resource.viewings += 1
    @resource.save(validate: false)
  end

  def new
    @resource = Resource.new
  end

  def create
    @resource = Resource.new(create_params)
    @resource.creator = current_user

    if @resource.save
      Event.register(current_user, "create", @resource)
      redirect_to return_to_path, notice: "Your changes have been saved."
    else
      flash.now.alert = "Unable to save your changes. See error messages below."
      render "new"
    end
  end

  def edit
  end

  def update
    if @resource.update(update_params)
      redirect_to return_to_path, notice: "Your changes have been saved."
    else
      flash.now.alert = "Unable to save your changes. See error messages below."
      render "edit"
    end
  end

  def destroy
    @resource.destroy!
    redirect_to return_to_path, notice: "The resource was deleted."
  end

  private

  def load_resource
    @resource = Resource.find(params[:id])
  end

  # Main purpose: to verify that the target class & id specify a valid resource.
  def load_target
    if params.dig(:resource, :target_type)
      @target = params[:resource][:target_type].constantize.find(params[:resource][:target_id])
    end
  end

  def create_params
    params.require(:resource).permit(:title, :description, :source_name, :relevant_to, :current_url, :attachment, :ownership_affirmed, :target_type, :target_id, :tag_list, :media_type_list)
  end

  def update_params
    params.require(:resource).permit(:title, :description, :url, :relevant_to, :attachment, :ownership_affirmed, :tag_list, :media_type_list)
  end

  def return_to_path
    if @resource.target
      url_for(@resource.target)
    elsif params[:editing_user_profile].present?
      user_path(current_user)
    else
      resources_path
    end
  end

  def verify_ownership
    unless @resource.creator == current_user
      redirect_to resource_path(@resource), alert: "You don't have permission to edit this resource."
    end
  end

end
