# Repositor

[gem]: https://rubygems.org/gems/repositor

## Installation & Setup

In gemfile:
```ruby
gem 'repositor'
```

In console:
```
bundle
```

## Description

This gem is an implementation of Repository Pattern described in book [Fearless Refactoring Rails Controllers](http://rails-refactoring.com/) by Andrzej Krzywda 2014 (c). Awesome book, recommend read for all who are scary open own controller files ;)

The main reason to user RepoObject is that your controller don't communicate with ORM layer (ActiveRecord or Mongoid). It must communicate with Repo layer so you are not stricted about your database adapter. If in future you will want to change it, you will need just to reconfigure your Repository layer. Sounds nice. Let's try it..

With RepoObject you controller must look something like this:
```ruby
class ProductsController < ApplicationController

  # you are free from action callbacks...

  def index
    @products = repo.all # you communicate with repo object, not with model!
  end

  def show
    @product = repo.find(params[:id]) # with repo... only...
  end

  def new
    @product = repo.new # it's awesome! no?
  end

  def edit
    @product = repo.find(params[:id]) # some dry?
  end

  def create
    respond_to do |format|
      @product = repo.create(product_params) # send params to repo
      if @product.valid? # just check for valid, not for create action
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      @product = repo.update(params[:id], product_params) # give repo id of record and params for update
      if @product.valid? # only validations
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    repo.destroy(params[:id]) # destroy also throw repo object
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def product_params
    params.require(:product).permit(:name, :price, :dscription)
  end

  # Declaration if repo object:
  def repo
    @products_repo ||= ProductsRepo.new
  end
  # By default repositor will try to find `Product` model and communicate with it
  # if you need specify other model, pass in params
  # ProductsRepo.new(model: SaleProduct)
end
```

## How to use


In `app` directory you need to create new `repos` directory . Recomended to create `application_repo.rb` and inherit from it all repos, so you could keep all your repos under single point of inheritance.

```ruby
class ApplicationRepo
  # include ORM submodule
  # now supported only ActiveRecord
  # more will added soon
  include Repositor::ActiveRecord
end
```

Than you need to create `products_repo.rb`:
```ruby
class ProductsRepo < ApplicationRepo
  # here you will have default methods for repo actions
end
```
and that's all... magic already happened (no)

If check what exactly was done, including `Repository` module in base `ApplicationRepo` will add default CRUD methods to all repos that will be inherited from it. That's all. No magic.

`Repositor` did for you a lot of dry work. In other case for each repo you must make identical methods, like this:
```ruby
class ProductsRepo
  def find(product_id)
    Product.find(product_id)
  end

  def all
    Product.all
  end

   def new
    Product.new
  end

  def update(product_id, params)
    find(product_id).tap do |product|
    product.update(params)
    end
  end

  def destroy(product_id)
    find(product_id).destroy
  end

  def create(product_params)
    Product.create(product_params)
  end
end
```
If you need to add new method to repo, just define it in repo file.

## TODO
* Specs on the way...
* Add mongoid support
* Some improvements ? =)
