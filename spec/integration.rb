require 'spec_helper'
require 'hactor'
require 'hactor/actor'

class UserListActor
  include Hactor::Actor

  def on_200(response)
    user_links = response.body.links.select { |link| link.rel == 'ht:user' }
    user_links.each do |link|
      puts "#{link.title} (#{link.href})"
    end
  end
end

class LatestPostActor
  include Hactor::Actor

  def on_200(response)
    puts response.body.embedded_resources.all.first.links.all
  end
end

class HomeActor
  include Hactor::Actor

  def on_200(response)
    response.follow 'ht:users', actor: UserListActor.new
    response.follow 'ht:latest-posts', actor: LatestPostActor.new
  end
end

describe Hactor do
  it "should work as expected :)" do
    Hactor.start url: 'http://haltalk.herokuapp.com/', actor: HomeActor.new
  end
end