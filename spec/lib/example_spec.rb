require_relative '../spec_helper'

####################################################################################################
# Parameter checking

# describe 'The example dynamic' do
#   it 'fails if the name attribute is missing' do
#     expect { sparkle_render { dynamic!(:example, 'MyExample') } }.to raise_error(RuntimeError)
#   end
# end

####################################################################################################
# Main execution path

# template = sparkle_render do
#   dynamic!(:example, 'MyExample',
#     name: 'my_example'
#   )
# end

# describe 'An example with simple types' do
#   subject { cloudformation(template).resource(:MyExample) }
#
#   it { is_expected.to have_tags }
#   its('Name') { is_expected.to be 'my_example' }
# end
