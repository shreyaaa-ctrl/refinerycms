class ProductsController < ApplicationController

  before_filter :find_shop, :only => [:new, :index]
  before_filter :find_all_products, :only => :index
  before_filter :find_page

  crudify :product

  def new
    @product = Product.new :shop => @shop
  end

  def index
    # you can use meta fields from your model instead (e.g. browser_title)
    # by swapping @page for @product in the line below:
    present(@page)
  end

  def show
    @product = Product.find(params[:id])
    @shop = @product.shop
    @similar_products = Product.similar_to(@product).without(@product).limit(3)
    # more products from same shop:
    # todo: maximal 3 produkte anzeigen, evtl nach kriterien wie tag-ähnlichkeit oder beliebtheit auswählen

    # you can use meta fields from your model instead (e.g. browser_title)
    # by swapping @page for @product in the line below:
    present(@page)
  end

protected


  def find_shop
    if params[:shop_id]
      @shop = Shop.find(params[:shop_id])
    end
  end

  def find_all_products
    if @shop
      @products = @shop.products.find(:all, :order => "position ASC")
    else
      @products = Product.find(:all, :order => "position ASC")
    end
  end

  def find_page
    @page = Page.find_by_link_url("/products")
  end

end
