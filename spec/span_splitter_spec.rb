require 'spec_helper'
require 'octopress-code-highlighter/span_splitter'

describe Octopress::CodeHighlighter::SpanSplitter do
  subject(:result) { described_class.split(code) }

  describe ".call" do
    context "with a single-line span" do
      let(:code) { %(<span class="k">end</span>\n) }

      it "leaves the code as-is" do
        expect(result).to eql(code)
      end
    end

    context "with a 2-line span" do
      let(:code) do
        <<-EOF
<span class="w">
  </span>
EOF
      end
      let(:expected) do
        <<-EOF
<span class="w"></span>
<span class="w">  </span>
EOF
      end

      it "splits the span across both lines" do
        expect(result).to eql(expected)
      end
    end

    context "with a multi-line span" do
      let(:code) do
        <<-EOF
<span class="s">"""
  Some text
"""</span>
EOF
      end
      let(:expected) do
        <<-EOF
<span class="s">"""</span>
<span class="s">  Some text</span>
<span class="s">"""</span>
EOF
      end

      it "splits the span across all lines" do
        expect(result).to eql(expected)
      end
    end

    context "with a mix of single-line and multi-line spans" do
      let(:code) do
        <<-EOF
<span class="w">  </span><span class="p">{</span><span class="w">
    </span><span class="s">Some text</span><span class="w">
  </span><span class="p">}</span>
EOF
      end
      let(:expected) do
        <<-EOF
<span class="w">  </span><span class="p">{</span><span class="w"></span>
<span class="w">    </span><span class="s">Some text</span><span class="w"></span>
<span class="w">  </span><span class="p">}</span>
EOF
      end

      it "preserves the single-line spans and splits the multi-line spans" do
        expect(result).to eql(expected)
      end
    end
  end
end
