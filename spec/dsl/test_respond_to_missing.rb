require 'spec_helper'

class Predicate
  describe Dsl do
    subject{
      Predicate::Dsl.new(:x)
    }

    it 'respond to negated forms' do
      [
        :notSize,
        :notEq
      ].each do |m|
        expect(subject.send(:respond_to_missing?, m)).to eql(true)
      end
    end

    it 'respond to camelCased forms' do
      [
        :hasSize
      ].each do |m|
        expect(subject.send(:respond_to_missing?, m)).to eql(true)
      end
    end
  end
end