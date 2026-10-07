class CommentsController < ApplicationController
  before_action :authenticate_user!, only: %i[ new create edit update destroy ]
  before_action :set_comment, only: %i[ show edit update destroy ]
  before_action :authorize_comment_owner, only: %i[ edit update destroy ]

  # GET /comments or /comments.json
  def index
    @comments = Comment.all
  end

  # GET /comments/1 or /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments or /comments.json
  def create
    @article = Article.find(params[:article_id] || comment_params[:article_id])
    @comment = @article.comments.build(body: comment_params[:body], user: current_user)

    respond_to do |format|
      if @comment.save
        format.html { redirect_to article_path(@article, anchor: "comments"), notice: "Комментарий добавлен.", status: :see_other }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render "articles/show", status: :unprocessable_content }
        format.json { render json: @comment.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /comments/1 or /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params.slice(:body))
        format.html { redirect_to @comment, notice: "Comment was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @comment.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /comments/1 or /comments/1.json
  def destroy
    @comment.destroy!

    respond_to do |format|
      format.html { redirect_to comments_path, notice: "Comment was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def comment_params
      params.expect(comment: [ :article_id, :body ])
    end

    def authorize_comment_owner
      head :forbidden unless @comment.user_id == current_user.id
    end
end
