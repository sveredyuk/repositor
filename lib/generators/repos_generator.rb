class ReposGenerator < Rails::Generators::Base
  def create_repos_file
    create_file "app/repos/application_repo.rb",
"class ApplicationRepo < Repositor::Repo::ActiveRecordAdapter
end
"
  end

  def create_query_file
    create_file "app/queries/application_query.rb",
"class ApplicationQuery < Repositor::Query::ActiveRecordAdapter
end
"
  end
end
