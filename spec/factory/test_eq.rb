require_relative "shared/a_comparison_factory_method"
class Predicate
  describe Factory, 'eq' do
    let(:method){ :eq }
    let(:node_class){ Eq }

    it_should_behave_like "a comparison factory method"
  end
end
