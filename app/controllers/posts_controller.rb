class PostsController < ApplicationController
  before_action :require_login, only: [:new, :edit, :update]
  before_action :require_user_name, only: [:new, :edit, :create]
  before_action :load_post, only: [:edit, :update, :show]
  before_action :verify_authorship, only: [:edit, :update]

  def index
    @filters = params.slice(:author_id, :tag, :intention_type)
    @posts = Post.where(published: true).order("published_at DESC")
    if @filters[:author_id]
      @posts = @posts.where(author_id: @filters[:author_id])
    end
    if @filters[:intention_type]
      @posts = @posts.where(intention_type: @filters[:intention_type])
    end
    if @filters[:tag]
      @posts = @posts.tagged_with(@filters[:tag])
    end

    @authors = User.where(id: @posts.pluck(:author_id).uniq).order(:last_name)
    @intention_types = @posts.pluck(:intention_type).uniq.sort
    @tag_counts = @posts.tag_counts_on(:tags)
    @drafts_count = Post.where(author: current_user, published: false).count
  end

  # TODO: Get rid of this. I find my drafts by filtering for them just like other posts.
  def drafts
    @posts = Post.where(author: current_user, published: false)
  end

  def create
    # In order to enable ajax autosave, we create the record immediately and
    # all writing happens during #edit. TODO: Routinely clean up orphaned posts
    @post = current_user.posts.new(
      parent: (params[:parent_id] ? Post.find(params[:parent_id]) : nil),
      reply_at_char_position: params[:reply_at_char_position].presence)
    @post.save(validate: false)
    respond_to do |format|
      format.html { redirect_to edit_post_path(@post) }
      format.js do
        render json: { form_html: render_to_string(partial: "form_#{template_variant}", locals: { post: @post }) }
      end
    end
  end

  def edit
    respond_to do |format|
      format.html { render "edit_#{template_variant}" }
      format.js { render partial: "form_#{template_variant}", locals: { post: @post } }
    end
  end

  def update
    unless params[:commit].downcase.include?("draft")
      @post.published = true
      @post.published_at = Time.now
    end

    if @post.update(post_params)
      respond_to do |format|
        format.html { redirect_to post_path(@post.root), notice: update_success_message }
        format.js { render json: { success: true } }
      end
    else
      @post.published = false
      respond_to do |format|
        format.html {
          flash.now.alert = "Unable to save your changes. See error messages below."
          render "edit_#{template_variant}"
        }
        format.js { render json: { errors: @post.errors.full_messages } }
      end
    end
  end

  def autosave
    TODO # autosave JS posts here, and only updates `content_autosaved`.
  end

  def show
    unless @post.published? or @post.author == current_user
      raise ActiveRecord::RecordNotFound
    end
    @conversants = @post.conversants.to_a
    @post_conversant = PostConversant.new
  end

  private

  rescue_from ActiveRecord::RecordNotFound do
    redirect_to posts_path, alert: "That post doesn't exist."
  end

  def post_params
    params.require(:post).permit(:title, :content, :intention_type, :intention_statement, :tag_list)
  end

  def load_post
    @post = Post.find(params[:id])
  end

  def template_variant
    if @post.root?
      "root"
    elsif @post.reply_at_char_position.present?
      "inline_comment"
    else
      "bottom_comment"
    end
  end

  def update_success_message
    if @post.published? and @post.published_at > 1.minute.ago
      "Post published!"
    else
      "Post updated."
    end
  end

  def verify_authorship
    unless @post.author == current_user
      redirect_to post_path(@post), alert: "You don't have permission to edit this post."
    end
  end

end
