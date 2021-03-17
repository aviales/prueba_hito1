class TweetsController < ApplicationController
  before_action :set_tweet, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: :index
  # respond_to :js, :html, :json
  # GET /tweets
  # GET /tweets.json
  def index

    if params[:content].present?
      @tweets = Tweet.where('content = ?', params[:content])
    else
      @tweets = Tweet.all
    end

    @paginated_tweets = Tweet.page(params[:page]).paginate(page: params[:page], per_page: 50)
  end

  def like
    if current_user
      @tweet = Tweet.find(params[:tweet_id])
      if is_liked?
        @tweet.remove_like(current_user)
      else
        @tweet.add_like(current_user)
      end
    else
      redirect_to new_user_session_path
    end
    redirect_to root_path
  end

  def retweet
    if current_user
      @tweet = Tweet.find(params[:tweet_id])
      Tweet.create(content: @tweet.content , user_id: current_user.id, origin_tweet: @tweet.id)
    else
      redirect_to new_user_session_path
    end
    redirect_to root_path
  end

  def hashtags
    tag = Tag.find_by(name: params[:name])
    @tweets = tag.tweets
  end

  # def dashboard
  #   if params[:content].present?
  #     @tweets = Tweet.where('content = ?', params[:content])
  #   else
  #     @tweets = Tweet.find_valid
  #   end
  # end

  # GET /tweets/1
  # GET /tweets/1.json
  def show
  end

  # GET /tweets/new
  def new
    @tweet = Tweet.new
    @users = User.pluck :profile_photo, :id
  end

  # GET /tweets/1/edit
  def edit
  end

  # POST /tweets
  # POST /tweets.json
  def create
    @tweet = Tweet.new(tweet_params.merge(user: current_user))
    @tweet.user_id = current_user.id
    respond_to do |format|
      if @tweet.save
        format.html { redirect_to @tweet, notice: 'Tweet was successfully created.' }
        format.json { render :show, status: :created, location: @tweet }
      else
        format.html { render :new }
        format.json { render json: @tweet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tweets/1
  # PATCH/PUT /tweets/1.json
  def update
    if @tweet.user.id == current_user.id
      respond_to do |format|
        if @tweet.update(tweet_params)
          format.html { redirect_to @tweet, notice: 'Tweet was successfully updated.' }
          format.json { render :show, status: :ok, location: @tweet }
        else
          format.html { render :edit }
          format.json { render json: @tweet.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to tweets_path, notice: 'Only admins or the user who created the story can update'
    end
  end

  # DELETE /tweets/1
  # DELETE /tweets/1.json
  def destroy
    @tweet.destroy
    respond_to do |format|
      format.html { redirect_to tweets_url, notice: 'Tweet was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    
    def is_liked?
      Like.where(user: current_user.id, tweet: params[:tweet_id]).exists?
    end
    
    def set_tweet
      @tweet = Tweet.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tweet_params
      params.require(:tweet).permit(:content, :user_id, :origin_tweet)
    end
end
