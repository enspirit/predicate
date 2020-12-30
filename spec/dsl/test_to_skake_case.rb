require 'spec_helper'

class Predicate
  describe Dsl, "to_snake_case" do

    def snake(str)
      Dsl.new.__send__(:to_snake_case, str)
    end

    it 'works on snake case already' do
      {
        "snake" => "snake",
        "snake_case" => "snake_case"
      }.each_pair do |k,v|
        expect(snake(k)).to eq(v)
      end
    end

    it 'works on camelCase already' do
      {
        "camelCase" => "camel_case",
        "theCamelCase" => "the_camel_case"
      }.each_pair do |k,v|
        expect(snake(k)).to eq(v)
      end
    end

    it 'works on PascalCase already' do
      {
        "PascalCase" => "pascal_case",
        "ThePascalCase" => "the_pascal_case"
      }.each_pair do |k,v|
        expect(snake(k)).to eq(v)
      end
    end

  end
end
