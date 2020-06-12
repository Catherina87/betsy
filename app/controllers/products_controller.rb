class ProductsController < ApplicationController

  def new 
    @product = Product.new
  end

  def create 
    @product = Product.new(product_params)
    if @product.merchant_id.nil?
      @product.merchant_id = session[:merchant_id]
    end
    if @product.save 
      flash[:success] = "Successfully created #{@product.title}"
      redirect_to product_path(@product.id)
      return
    else
      render :new 
      return
    end
  end

  def edit 
    @product = Product.find_by(id: params[:id])
    if @product.nil?
      redirect_to products_path
      return
    end
  end

  def update 
    @product = Product.find_by(id: params[:id])
    if @product.nil?
      head :not_found
      return
    elsif @product.update(product_params)
      flash[:success] = "Successfully updated #{@product.title}"
      redirect_to product_path(@product.id)
      return
    else
      render :edit 
      return
    end
  end

  def index
    if params[:merchant_id]
      # This is the nested route, /merchants/:merchant_id/products
      @merchant = Merchant.find_by(id: params[:merchant_id])
      @products = @merchant.products
    elsif params[:category_id]
      @category = Category.find_by(id: params[:category_id])
      @products = @category.products
    else
      # This is the 'regular' route, /products
      @products = Product.all
    end
  end

  def show
    @product = Product.find_by(id: params[:id])

    if @product.nil?
      redirect_to products_path
      return
    end
  end


  private 

  def product_params 
    return params.require(:product).permit(:title, :price, :description, :merchant_id,
                                    :photo_url, :stock, active: true, category_ids: [])
  end
end
