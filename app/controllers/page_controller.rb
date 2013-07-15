class PageController < ApplicationController

  def menu
    @articles = Page::Page.where('$or' => [{:parent=>''},{:parent=>nil}], :public =>true)  
  end

  def list
    @articles = Page::Page.where('$or' => [{:parent=>''},{:parent=>nil}])
  end

  def edit
    @action = "update"
    @page=Page::Page.where(:keyword =>  params[:keyword]).first
    session[:page] = @page
  end

  def new 
    @action = "create"
    @page = Page::Page.new
    @page.content = Page::Article.new
    respond_to do |format|
      format.html { render :template => "page/edit.html.erb" }
    end
  end

  def create
    page = Page::Page.new 
    save_page page
    @msg = params[:page_type]
  end

  def update
    page = session[:page]
    save_page page
  end

  def delete
  end

  def get
    p=Page::Page.where(:keyword =>  params[:keyword]).first

    if p.content.is_a?Page::Article
      @page = p
    elsif p.content.is_a?Page::AddIn
      redirect_to :controller=>'user', :action => 'index'
    end
  end


  def save_page page
    page.title = params[:title]
    page.keyword = params[:keyword] 
    page.parent = params[:parent]
    if params[:public] == nil
      page.public = false
    else      
      page.public = true      
    end
    if params[:page_type] == "1"
      article = Page::Article.new( :content=>params[:content])
      page.content = article
    elsif params[:page_type] == "2"
      add_in = Page::AddIn.new( :url=>params[:content])
      page.content = add_in
    end
    page.save! 
  end

  def getKinds(parent)
    return Page::Page.where(:parent =>parent)
  end
  helper_method :getKinds
  def kinds?(parent)
    if Page::Page.where(:parent =>parent).count > 0
      return true
    else
      return false
    end
  end
  def getPageType(p)
    if p.content.is_a?Page::Article
      return 1
    elsif p.content.is_a?Page::AddIn
     return 2
   end  end
   helper_method :getPageType
 end
