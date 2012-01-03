require 'spec_helper'
require 'spec/proto/test_service_impl'
require 'protobuf/rpc/servers/evented_runner'

describe Protobuf::Rpc::EventedServer do

  it "provides a Runner class" do 
    runner_class = described_class.to_s.gsub(/Server/, "Runner")
    expect { Protobuf::Util.constantize(runner_class) }.to_not raise_error     
  end

  it "Runner provides a stop method" do
    runner_class = described_class.to_s.gsub(/Server/, "Runner")
    runner_class = Protobuf::Util.constantize(runner_class)
    runner_class.respond_to?(:stop).should be_true
  end

end
