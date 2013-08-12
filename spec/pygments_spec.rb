require 'spec_helper'

describe Octopress::Pygments do
  let(:wrapper) do
    Proc.new do |stuff, numbers|
      [
        "<figure class='code'>",
        "<div class='highlight'>",
        "<table><tr>",
        "<td class='line-numbers' aria-hidden='true'>",
        "<pre>#{numbers}</pre>",
        "</td>",
        "<td class='main  plain'>",
        "<pre>#{stuff}</pre>",
        "</td></tr>",
        "</table></div></figure>"
      ].join
    end
  end

  let(:expected_output_no_options) do
    stuff = <<-EOF
<figure class='code'><div class='highlight'><table><tr><td class='line-numbers' aria-hidden='true'><pre><div data-line='1' class='line-number'></div><div data-line='2' class='line-number'></div><div data-line='3' class='line-number'></div><div data-line='4' class='line-number'></div><div data-line='5' class='line-number'></div><div data-line='6' class='line-number'></div><div data-line='7' class='line-number'></div><div data-line='8' class='line-number'></div></pre></td><td class='main  plain'><pre><div class='line'>    require "hi-there-honey"
</div><div class='line'> </div><div class='line'>    def hi-there-honey
</div><div class='line'>      HiThereHoney.new("your name")
</div><div class='line'>    end
</div><div class='line'> </div><div class='line'>    hi-there-honey
</div><div class='line'>    # => "Hi, your name"
</div></pre></td></tr></table></div></figure>
EOF
    stuff.strip
  end

  let(:code) do
    <<-EOF
    require "hi-there-honey"

    def hi-there-honey
      HiThereHoney.new("your name")
    end

    hi-there-honey
    # => "Hi, your name"
    EOF
  end

  let(:markup) do
    [
      "lang:ruby",
      'title:"Hello"',
      "url:http://something.com/hi/fuaiofnioaf.html",
      "link_text:'get it here'",
      "mark:5,8-10,15",
      "linenos: yes",
      "start: 5",
      "end: 15",
      "range: 5-15"
    ].join(" ")
  end

  let(:bad_markup) do
    [
      "lang:ruby",
      'title:"Hello"',
      "url:http://something.com/hi/fuaiofnioaf.html",
      "link_text: get it here",
      "mark:5,8-10,15",
      "linenos: yes",
      "start: 5",
      "end: 15",
      "range: 5-15"
    ].join(" ")
  end

  let(:options) do
    {
      lang: "ruby",
      url:  "http://something.com/hi/fuaiofnioaf.html",
      title: "Hello",
      linenos: "yes",
      marks: [5, 8, 9, 10, 15],
      link_text: "get it here",
      start: 5,
      end: 15
    }
  end

  describe ".highlight" do
    it "returns HTML for an empty code block" do
      expect(described_class.highlight("", {})).to eql(wrapper.call("", ""))
    end

    context "with no options" do
      it "returns the right HTML for a given set of code" do
        expect(described_class.highlight(code, {})).to eql(expected_output_no_options)
      end
    end
  end

  describe ".highlight_failed" do
    #described_class.highlight_failed(error, syntax, markup, code, file = nil)
  end

  describe ".parse_markup" do
    context "with no defaults" do
      it "parses the defaults correctly" do
        expect(described_class.parse_markup(markup, {})).to eql(options)
      end
    end

    context "with defaults with a nil value" do
      it "overrides the nil values" do
        expect(described_class.parse_markup(markup, { lang: nil })).to eql(options)
      end
    end
  end

  describe ".clean_markup" do

    it "returns an empty string with good markup" do
      expect(described_class.clean_markup(markup)).to eql("")
    end

    it "returns erroneous text that isn't part of the markup" do
      expect(described_class.clean_markup(bad_markup)).to eql(" it here")
    end
  end
end
