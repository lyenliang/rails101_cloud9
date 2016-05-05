class GroupsController < ApplicationController

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
    @group = Group.new(group_params)

    if @group.save
      redirect_to groups_path
    else
      render :new
    end
  end

  # 顯示某個 group 的頁面
  def show
    # show 會顯示 html 畫面，所以將指定的 group 抓出來，讓 html 使用
    @group = Group.find(params[:id])
  end

  # 修改討論版的頁面
  def edit
    # edit 會顯示 html 畫面，所以將指定的 group 抓出來，讓 html 使用即可
    @group = Group.find(params[:id])
  end

  # 修改討論版 按下 Submit 後的反應（怪的是 rake routes 顯示應該用 put method 才對，但實際看 html code，發現是用 post method）
  def update
    @group = Group.find(params[:id])

    # update 沒有 html 的畫面，所以底下還需要做其它事
    if @group.update(group_params)
      redirect_to groups_path, notice: "修改討論版成功"
    else
      render :edit
    end
  end 

  private

  def group_params
    params.require(:group).permit(:title, :description)
  end
end
