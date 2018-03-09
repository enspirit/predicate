require_relative "shared/a_comparison_factory_method"
class Predicate
  describe Factory, 'intersect' do

    subject{ Factory.intersect(:x, [2, 3]) }

    it{ should be_a(Intersect) }

    it{ should eq([:intersect, [:identifier, :x], [2, 3]]) }

  end
end
