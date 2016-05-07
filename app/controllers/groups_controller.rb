class GroupsController < ApplicationController

  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  # 列出所有 group 的頁面
  def index
    @groups = Group.all
  end

  # 建立新 group 的頁面
  def new
    @group = Group.new
  end

  # 在新增討論版 按下 Submit 的反應
  def create
    @group = current_user.groups.new(group_params)

    if @group.save
      current_user.join!(@group)
      redirect_to groups_path
    else
      render :new
    end
  end

  # 顯示某個 group 的頁面
  def show
    # show 會顯示 html 畫面，所以將指定的 group 抓出來，讓 html 使用
    @group = Group.find(params[:id])
    @posts = @group.posts
  end

  # 修改討論版的頁面
  def edit
    # edit 會顯示 html 畫面，所以將指定的 group 抓出來，讓 html 使用即可
    @group = current_user.groups.find(params[:id])
  end

  # 修改討論版 按下 Submit 後的反應（怪的是 rake routes 顯示應該用 put method 才對，但實際看 html code，發現是用 post method）
  def update
    @group = current_user.groups.find(params[:id])

    # update 沒有 html 的畫面，所以底下還需要做其它事
    if @group.update(group_params)
      redirect_to groups_path, notice: "修改討論版成功"
    else
      render :edit
    end
  end 

  def destroy
    @group = current_user.groups.find(params[:id])
    @group.destroy
    redirect_to groups_path, alert: "討論版已刪除"
  end

  def join
    @group = Group.find(params[:id])
    
    if !current_user.is_member_of?(@group)
      current_user.join!(@group)
      flash[:notice] = "加入本討論版成功！"
    else
      flash[:warning] = "你已經是本討論版成員了！"
    end
    
    redirect_to group_path(@group)
  end
  
  def quit
    @group = Group.find(params[:id])
    
    if current_user.is_member_of?(@group)
      current_user.quit!(@group)
      flash[:alert] = "已退出本討論版！"
    else
      flash[:warning] = "你不是本討論版成員，怎麼退出 XD"
    end
    
    redirect_to group_path(@group)
  end

  private

  def group_params
    params.require(:group).permit(:title, :description)
  end
end
