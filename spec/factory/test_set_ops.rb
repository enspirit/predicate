require_relative "shared/a_comparison_factory_method"
class Predicate
  [
    [ :intersect, Intersect ],
    [ :subset, Subset ],
    [ :superset, Superset ],
  ].each do |op_name, op_class|
    describe Factory, op_name do

      subject{ Factory.send(op_name, :x, [2, 3]) }

      it{ should be_a(op_class) }

      it{ should eq([op_name, [:identifier, :x], [:literal, [2, 3]]]) }

    end
  end
end
