require_relative "shared/a_comparison_factory_method"
class Predicate
  describe Factory, 'lt' do
    let(:method){ :lt }
    let(:node_class){ Lt }

    it_should_behave_like "a comparison factory method"
  end
end
