require 'spec_helper'
require 'active_model'

class Article < Struct.new(:name, :description, :summary)
  include ActiveModel::Validations
  include ActiveModel::Callbacks

  define_model_callbacks :validation

  include SanitizeAttr

  def valid?
    run_callbacks(:validation) { super }
  end
end

describe SanitizeAttr do
  before { Article.reset_callbacks :validation }

  let(:name) { '<b onclick="alert()">My Name</b> <script type="text/javascript">evil()</script>'}
  let(:description) { '<i>Description</i><iframe></iframe>'}
  let(:summary) { '<html></html>' }

  subject { Article.new(name, description, summary) }

  it 'should sanitize only specified attributes' do
    Article.sanitize_attr :name, :description
    subject.valid?

    subject.name.should == '<b>My Name</b> evil()'
    subject.description.should == '<i>Description</i>'
    subject.summary.should == '<html></html>'
  end

  it 'should sanitize using the provided config' do
    Article.sanitize_attr :name, :description, config: Sanitize::Config::DEFAULT
    subject.valid?

    subject.name.should == 'My Name evil()'
    subject.description.should == 'Description'
    subject.summary.should == '<html></html>'
  end

  it 'should allow config to be defined as a symbol' do
    Article.sanitize_attr :name, :description, config: :default
    subject.valid?

    subject.name.should == 'My Name evil()'
    subject.description.should == 'Description'
    subject.summary.should == '<html></html>'
  end

  it 'should allow default to BASIC config if config is nil' do
    Article.sanitize_attr :name, :description, config: nil
    subject.valid?

    subject.name.should == '<b>My Name</b> evil()'
    subject.description.should == '<i>Description</i>'
    subject.summary.should == '<html></html>'
  end

  it 'should sanitize different columns with different configs' do
    Article.sanitize_attr :name, config: :default
    Article.sanitize_attr :description, config: :basic
    subject.valid?

    subject.name.should == 'My Name evil()'
    subject.description.should == '<i>Description</i>'
    subject.summary.should == '<html></html>'
  end

  it 'should not sanitize if validation is not triggered' do
    Article.sanitize_attr :name, :description

    Sanitize.should_not_receive(:fragment)
    subject
  end
end
