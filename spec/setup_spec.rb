class Thing # fake model
  def hello
    "hello"
  end

  def yeah
    "yeahhhh!"
  end
end

class AnotherThing # another fake model =)
end

class ThingRepo < Repositor::Repo::ActiveRecordAdapter
  #allow_instance_methods :hello
end

class ThingQuery < Repositor::Query::ActiveRecordAdapter
end
