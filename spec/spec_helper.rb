require 'media_wiki'

require 'nokogiri'
require 'equivalent-xml/rspec_matchers'

require_relative 'fake_media_wiki'

RSpec.configure { |config|
  %w[expect mock].each { |what|
    config.send("#{what}_with", :rspec) { |c| c.syntax = [:should, :expect] }
  }

  config.alias_example_group_to :describe_live, begin
    require 'media_wiki/test_wiki/rspec_adapter'
  rescue LoadError
    { skip: 'MediaWiki::TestWiki not available'.tap { |msg|
      warn "#{msg}. Install the `mediawiki-testwiki' gem." } }
  else
    { live: true }.tap { |filter|
      MediaWiki::TestWiki::RSpecAdapter.enhance(config, filter) }
  end

  config.include(Module.new {
    def data(file)
      File.join(File.dirname(__FILE__), 'data', file)
    end
  })
}
