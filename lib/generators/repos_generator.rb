class ReposGenerator < Rails::Generators::Base
  def create_repos_file
    create_file "app/repos/application_repo.rb",
"class ApplicationRepo
  include Repositor::ActiveRecord
end
"
  end
end
