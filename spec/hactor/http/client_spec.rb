require 'spec_helper'
require 'hactor/http/client'

describe Hactor::HTTP::Client do
  let(:response_class) { mock }
  let(:backend) { mock }
  let(:client) { Hactor::HTTP::Client.new(response_class: response_class, backend: backend) }
  describe "#follow" do
    context "a valid URL is supplied" do
      let(:url) { 'http://example.com/' }
      let(:actor) { mock }
      let(:response) { stub }
      let(:hactor_response) { stub }

      it "GETs from URL and passes Response object to the actor" do
        backend.should_receive(:get)
          .with(url)
          .and_return(response)
        response_class.should_receive(:new)
          .with(response)
          .and_return(hactor_response)
        actor.should_receive(:call)
          .with(hactor_response)

        client.follow(url: url, actor: actor)
      end
    end
  end
end