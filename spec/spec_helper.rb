$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'puppet_docs'
require 'spec'
require 'spec/autorun'

module ViewHelper

  def change_layout
    change { PuppetDocs::View.layout }
  end
  
end

module FixtureHelper

  def fixtures_root
    @fixtures_root ||= Pathname.new(__FILE__).parent + 'fixtures'
  end
  
  def fixture(name)
    (fixtures_root + name).read
  end

end

Spec::Runner.configure do |config|
  config.mock_with :mocha
  config.include ViewHelper
  config.include FixtureHelper
end
