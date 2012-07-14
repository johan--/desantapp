require File.expand_path("../../spec_helper", __FILE__)

describe Airstrip::SignupService do
  subject do
    Airstrip::SignupService
  end

  context "when given email address is valid and not duplicated" do
    let :app do
      stub(
        :params  => { :signup => { :email => "chris@nu7hat.ch" } },
        :request => stub(:ip => "127.0.0.1"),
        :session => { :referrer => "http://www.dummy.com/blog/post" }
      )
    end

    it "creates new signup entry" do
      res = subject.call(app)
      res.should == { "email" => "chris@nu7hat.ch" }
      Airstrip::Signup.find_by_email("chris@nu7hat.ch").should be
    end
  end

  context "when errors encountered" do
    let :app do
      stub(
        :params  => {},
        :request => stub(:ip => "127.0.0.1"),
        :session => {}
      )
    end

    it "returns error messages" do
      res = subject.call(app)
      res.full_messages.to_sentence.should == "Email has invalid format"
    end
  end
end