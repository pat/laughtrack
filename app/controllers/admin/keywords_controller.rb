class Admin::KeywordsController < Admin::ApplicationController
  expose(:show)    { Show.find params[:show_id] }
  expose(:keyword) { show.keywords.find params[:id] }
  
  def create
    show.keywords.create params[:keyword]
    
    redirect_to edit_admin_show_path(show)
  end
  
  def delete
    keyword.destroy
    
    redirect_to edit_admin_show_path(show)
  end
end
