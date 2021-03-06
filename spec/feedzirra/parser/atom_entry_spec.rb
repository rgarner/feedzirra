require File.join(File.dirname(__FILE__), %w[.. .. spec_helper])

describe Feedzirra::Parser::AtomEntry do
  before(:each) do
    # I don't really like doing it this way because these unit test should only rely on AtomEntry,
    # but this is actually how it should work. You would never just pass entry xml straight to the AtomEnry
    @entry = Feedzirra::Parser::Atom.parse(sample_atom_feed).entries.first
  end

  it "should parse the title" do
    @entry.title.should == "AWS Job: Architect & Designer Position in Turkey"
  end

  describe "The url" do
    subject { @entry.url }

    its(:to_s) { should eql("http://aws.typepad.com/aws/2009/01/aws-job-architect-designer-position-in-turkey.html?param=1&param=2") }
    its(:rel)  { should eql("alternate") }
    its(:type) { should eql("text/html") }
  end

  it "should parse the url even when" do
    Feedzirra::Parser::Atom.parse(load_sample("atom_with_link_tag_for_url_unmarked.xml")).entries.first.url.to_s.should == "http://www.innoq.com/blog/phaus/2009/07/ja.html"
  end

  it "should parse the author" do
    @entry.author.should == "AWS Editor"
  end

  describe "The content" do
    subject { @entry.content }

    it         { should be_a(Feedzirra::Parser::AtomContent)}
    its(:type) { should eql('html') }
    its(:to_s) { should eql(sample_atom_entry_content) }
    its(:body) { should eql(sample_atom_entry_content) }
  end

  it "should provide a summary" do
    @entry.summary.should == "Late last year an entrepreneur from Turkey visited me at Amazon HQ in Seattle. We talked about his plans to use AWS as part of his new social video portal startup. I won't spill any beans before he's ready to..."
  end

  it "should parse the published date" do
    @entry.published.should == Time.parse_safely("Fri Jan 16 18:21:00 UTC 2009")
  end

  it "should parse the categories" do
    @entry.categories.should == ['Turkey', 'Seattle']
  end

  it "should parse the updated date" do
    @entry.updated.should == Time.parse_safely("Fri Jan 16 18:21:00 UTC 2009")
  end

  it "should parse the id" do
    @entry.id.should == "tag:typepad.com,2003:post-61484736"
  end

  it "should support each" do
    @entry.respond_to? :each
  end

  it "should be able to list out all fields with each" do
    all_fields = []
    @entry.each do |field, value|
      all_fields << field
    end
    all_fields.sort == ['author', 'categories', 'content', 'id', 'published', 'summary', 'title', 'url']
  end

  it "should be able to list out all values with each" do
    title_value = ''
    @entry.each do |field, value|
      title_value = value if field == 'title'
    end
    title_value.should == "AWS Job: Architect & Designer Position in Turkey"
  end

  it "should support checking if a field exists in the entry" do
    @entry.include?('title') && @entry.include?('author')
  end

  it "should allow access to fields with hash syntax" do
    @entry['title'] == @entry.title
    @entry['title'].should == "AWS Job: Architect & Designer Position in Turkey"
    @entry['author'] == @entry.author
    @entry['author'].should == "AWS Editor"
  end

  it "should allow setting field values with hash syntax" do
    @entry['title'] = "Foobar"
    @entry.title.should == "Foobar"
  end

  describe "parsed links" do
    subject(:links) { @entry.links }

    it { should have(3).links }

    describe "The first link" do
      subject(:link) { links.first }

      its(:rel)  { should eql('alternate') }
      its(:href) { should eql('http://aws.typepad.com/aws/2009/01/aws-job-architect-designer-position-in-turkey.html?param=1&param=2') }
      its(:title) { should eql('Bunnies') }
    end
  end
end