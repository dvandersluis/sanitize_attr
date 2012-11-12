require 'sanitize_attr'

class Model < Struct.new(:html, :no_html, :other_html)
  include SanitizeAttr

  class << self
    attr_accessor :validations

    def before_validation(&block)
      self.validations ||= []
      self.validations << block
    end
  end

  sanitize_attr :html

  def save
    self.tap { |m| m. class.validations.each{ |block| block.call(self) } unless self.class.validations.empty? }
  end
end

class ModelWithMultipleSanitizedAttrs < Model
  sanitize_attr :html, :other_html
end

class ModelWithHashSanitizedAttrs < Model
  sanitize_attr attrs: [:html, :other_html]
end

module Sanitize
  module Config
    HTML = Class.new
  end
end

describe SanitizeAttr do
  before do
    Sanitize.should_receive(:clean).at_least(1).times.and_return("Cleaned string")
  end

  subject { Model.new("html", "no html").save }

  it "should sanitize passed in attributes on save" do
    subject.html.should == "Cleaned string"
  end

  it "should sanitize multiple attributes if provided" do
    m = ModelWithMultipleSanitizedAttrs.new("html", "no html", "other html")
    m.save
    m.html.should == "Cleaned string"
    m.other_html.should == "Cleaned string"
  end

  it "should sanitize attributes provided via an attrs hash" do
    m = ModelWithHashSanitizedAttrs.new("html", "no html", "other html")
    m.save
    m.html.should == "Cleaned string"
    m.other_html.should == "Cleaned string"
  end

  it "should not sanitize attributes that are not specified" do
    subject.no_html.should == "no html"
  end

  it "should not sanitize blank attributes" do
    subject.html = ""
    subject.save
    subject.html.should == ""
  end
end