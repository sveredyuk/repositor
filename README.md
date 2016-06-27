# Repositor

## Installation & Setup

Manual:
```
gem install 'repositor'
```

For gemfile:
```ruby
gem 'repositor'
```

And run in console:
```
bundle install
```

## Description

This gem is an implementation of **Repository Pattern** described in book [Fearless Refactoring Rails Controllers](http://rails-refactoring.com/) by Andrzej Krzywda 2014 (c). Awesome book, recommend read for all who are scary open own controller files ;)

I solit record instance manage and collection manage into two almost same (but not) layers - Repos & Queries

Repo - work with single record (:find, :new, :create, :update, :destroy)
Query - work with coolections of records (:where and others)

The main reason to user **RepoObject** is that your controller don't communicate with ORM layer (ActiveRecord or Mongoid). It must communicate with Repo layer so you are not stricted about your database adapter. If in future you will want to change it, you will need just to reconfigure your Repository layer. Sounds nice. Let's try it..

With some helps of helper method your controller can be only 30-40 lines of code. Nothing more.

With RepoObject you controller could look something like this:
```ruby
class ProductsController < ApplicationController

  # you are free from any action callbacks...
  # but define this 2 helper methods:
  helper_method :product, :products

  def create
    @product = repo.create(product_params)
    @product.valid? ? redirect_to(default_redirect) : render(:new)
  end

  def update
    @product = repo.update(product, product_params)
    @product.valid? ? redirect_to(default_redirect) : render(:edit)
  end

  def destroy
    repo.destroy(product) and redirect_to default_redirect
  end

  private

  def product_params
    params.require(:product).permit(:name, :price, :dscription)
  end

  def default_redirect
    products_path
  end

  # Helper method that find or init new instance for you and cache it in ivar
  # You can use it for at view show action just `product` method
  # or for _form partial also `product`
  def product
    @product ||= repo.find_or_initialize(params[:id])
  end

  # Second helper that allow to cache all collection
  # At view method `products` allows you access to the colelction
  # No any @'s anymore!
  def products
    @products ||= repo.all
  end

  # Declaration if repo object:
  def repo
    @products_repo ||= ProductRepo.new
  end
  # By default repositor will try to find `Product` model and communicate with it
  # if you need specify other model, pass in params
  # ProductRepo.new(model: SaleProduct)
end
```

## How to use

**By generator:**

`rails generate repos`

**Or manually:**

In `app` directory you need to create new `repos` directory . Recomended to create `application_repo.rb` and inherit from it all repos, so you could keep all your repos under single point of inheritance.

```ruby
class ApplicationRepo <  Repositor::ActiveRecordAdapter
  # now supported only ActiveRecord but will be added more soon
  # 
  # Adapter allow you to use 4 default methods for CRUD:
  # :new, :create, :update, :destroy
  # 
  # Only 2 for finding/quering records
  # :find, :all
  # 
  # And additional helpers
  # find_or_initialize(id, friendly: false) => support for friendly_id gem
  # or
  # friendly_find(slugged_id)
end
```

Than you need to create `product_repo.rb`:
```ruby
class ProductRepo < ApplicationRepo
  # here you have default methods for repository actions
  # if you want communicate with model class,
  # just can use model method to send it any method you need
  def create_if(params, condition)
    create(params) if condition
  end

  # Very good approach is that you got a place where you can
  # control persistence process, define some logic and reuse it everywhere.
  def update(record, params)
    result = record.update(params) if params[:ok] == 'ok'

    if result
      # trigger some event
    end
  end

  # You also can compose queries
  # But recommended to extract such methods to QueryObject (aka finder)
  def all_with_name_john
    model.where(name: 'John')
  end
end
```

Also `Repositor` allow redirect defined record methods to instance if it was passed as first argument:
```ruby
class ProductRepo < ApplicationRepo
  allow_instance_methods :new_record?
end

product_repo.new_record?(product)
# same as:
product.new_record?

# And not allowed will raise exception
product_repo.persited?(product) # => NoMethodError
```
Only with the reason that you are not linked with data, only with it repo.

**Keep your model skinny and without business logic.**

## TODO
* Add mongoid support
* Add sequel support
* Some improvements ? =)
