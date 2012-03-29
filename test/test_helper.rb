# Load the normal Rails helper
require File.expand_path(File.dirname(__FILE__) + '/../../../../test/test_helper')

# Ensure that we are using the temporary fixture path
Engines::Testing.set_fixture_path
# Get fixtures from plugin directory
Fixtures.create_fixtures(File.dirname(__FILE__) + '/fixtures', 'users')