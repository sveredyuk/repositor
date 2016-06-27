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

I split record instance manage and collection manage into two almost same (but not) layers - Repos & Queries

**Repo** - for single record (:find, :new, :create, :update, :destroy)

**Query** - for collection of records (:all, :where and others)

The main reason to user **RepoObject** is that your controller don't communicate with ORM layer (ActiveRecord or Mongoid). It will communicate with Repo/Query so you are not stricted about your database adapter or data API. It's some sort of anti-corruption layer also. If in future you will want to change it, you will need just to reconfigure your Repository layer. Sounds nice. Let's try it..

With some support of `helper_method` your controller can be only 50-60 lines of code. Nothing more.

With **Repo** and **Query** you controller could look something like this:
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
    @products ||= query.all
  end

  # Declaration of repo object:
  def repo
    @products_repo ||= ProductRepo.new
  end

  # Declaration of query object:
  def query
    @product_query ||= ProductQuery.new
  end
  # By default repositor will try to find `Product` model and communicate with it
  # if you need specify other model, pass in params
  # ProductRepo.new(model: TopProduct)
  # or
  # ProductQuery.new(model: SaleProduct)
end
```

## How to use

**By generator:**

`rails generate repos`

**Or manually:**

In `app` directory you need to create new `repos` and `queries` directory . Recomended to create `application_repo.rb` and inherit from it all repos, so you could keep all your repos under single point of inheritance. (Same for queries)

`app/repos/application_repo.rb`
```ruby
class ApplicationRepo <  Repositor::Repo::ActiveRecordAdapter
  # now supported only ActiveRecord but will be added more soon
  # 
  # Adapter allow you to use 4 default methods for CRUD:
  # :new, :create, :update, :destroy
  # 
  # Only 1 for find record
  # :find
  # 
  # And additional helpers
  # find_or_initialize(id, friendly: false) => support for friendly_id gem
  # or
  # friendly_find(slugged_id)
end
```

`app/queries/application_query.rb`
```ruby
class ApplicationQuery <  Repositor::Query::ActiveRecordAdapter
  # now supported only ActiveRecord but will be added more soon
  # 
  # Adapter allow you to use 3 methods for CRUD:
  # :all, :first, :last
end
```

Than you need to create `app/repos/product_repo.rb`:
```ruby
class ProductRepo < ApplicationRepo
  # here you have default methods for repository actions
  # if you want communicate with model class,
  # just can use model method to send it any method you need

  # Very good approach is that you got a place where you can
  # control persistence process, define some logic and reuse it everywhere.
  def update(record, params)
    result = record.update(params) if params[:ok] == 'ok'

    if result
      # trigger some event
    end

    result # don't forgot return object
  end
end
```

and `app/queries/product_query.rb`
```ruby
class ProductQuery < ApplicationQuery
  # here you can define all scopes
  # ATTENTION! Your queries always must reutrn Relation (!!!)
  
  # Simple scopes extraction from model
  def active
    where(status: 'active')
  end

  def disabled(status: 'disabled')
    where(status: 'active')
  end
  
  # You can combine queries
  def active_and_disabled
    active | disabled
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
