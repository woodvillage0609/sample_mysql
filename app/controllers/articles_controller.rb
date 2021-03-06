class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy]
  before_action :super_user, only: [:new, :create, :edit, :update, :destroy]

  # GET /articles
  # GET /articles.json
  def index
    @articles = Article.order(created_at: :desc)
    @random_articles = Article.all.order("RAND()")
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
    @random_articles = Article.where.not(id:@article).order("RAND()")
    @articles = Article.all.order(created_at: :desc)

  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
  end

  def rest_article 
    @articles_rest = Article.offset(32).paginate(:page => params[:page], :per_page =>24).order(created_at: :desc)
    @random_articles = Article.all.order("RAND()")
  end

  # POST /articles
  # POST /articles.json
  def create
    @article = Article.new(article_params)

    respond_to do |format|
      if @article.save
        format.html { redirect_to @article, notice: 'Article was successfully created.' }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1
  # PATCH/PUT /articles/1.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to @article, notice: 'Article was successfully updated.' }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_url, notice: 'Article was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def article_params
      params.require(:article).permit(:photo, :title, :content, :url, :source)
    end


    def super_user
      unless user_signed_in? && current_user.email == "woodvillage0609@gmail.com" 
        redirect_to root_path
      end
    end

end
