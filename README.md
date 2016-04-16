# Repositor

[gem]: https://rubygems.org/gems/repositor

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
    @product ||= repo.find(params[:id])
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


In `app` directory you need to create new `repos` directory . Recomended to create `application_repo.rb` and inherit from it all repos, so you could keep all your repos under single point of inheritance.

```ruby
class ApplicationRepo
  # include ORM submodule
  # now supported only ActiveRecord
  # more will be added soon
  include Repositor::ActiveRecord
end
```

Than you need to create `product_repo.rb`:
```ruby
class ProductRepo < ApplicationRepo
  # here you will have default methods for repo actions
  # if you want communicate with model class,
  # just can use model method to send it any method you need
  def all_with_name_john
    model.where(name: 'John')
  end
end
```
and that's all... magic already happened (no)

If check what exactly was done, including `Repository` module in base `ApplicationRepo` will add default CRUD methods to all repos that will be inherited from it. That's all. No magic.

`Repositor` did for you a lot of dry work. In other case for each repo you must make identical methods, like this:
```ruby
class ProductsRepo
  def all
    Product.all
  end

  def new
    Product.new
  end

  def find(product_id)
    Product.find(product_id)
  end

  def create(product_params)
    Product.create(product_params)
  end

  def update(params)
    product.update(params)
  end

  def destroy(product)
    product.destroy
  end
end
```
If you need to add new method for model, just define it in repo file.
Keep your model skinny.

## TODO
* Add mongoid support
* Add generators that generate repo folder and some `application_repo.rb`
* Some improvements ? =)
