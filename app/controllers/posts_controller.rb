class PostsController < ApplicationController

  before_action :authenticate_user!

  before_action :find_group

  # 建立新 Post 的頁面
  def new
    @post = @group.posts.new
  end

  # 修改 Post 的頁面
  def edit
    @post = current_user.posts.find(params[:id])
  end

  # Edit 頁面按下 Submit 後做的動作
  def update
    @post = current_user.posts.find(params[:id])

    if @post.update(post_params)
      redirect_to group_path(@group), notice: "文章修改成功！" 
    else
      render :edit
    end
  end

  # New Post 按下 Submit 後的反應
  def create
    @post = @group.posts.build(post_params)
    @post.author = current_user

    if @post.save
      redirect_to group_path(@group), notice: "新增文章成功！"
    else
      render :new
    end
  end

  # Post 按下 delete 後的反應
  def destroy
    @post = current_user.posts.find(params[:id])

    @post.destroy
    redirect_to group_path(@group) ,alert: "文章已刪除"
  end

  private

  def find_group
    @group = Group.find(params[:group_id])
  end
  
  def post_params
    params.require(:post).permit(:content)
  end
end
