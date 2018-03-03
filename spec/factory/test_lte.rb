require_relative "shared/a_comparison_factory_method"
class Predicate
  describe Factory, 'lte' do
    let(:method){ :lte }
    let(:node_class){ Lte }

    it_should_behave_like "a comparison factory method"
  end
end
