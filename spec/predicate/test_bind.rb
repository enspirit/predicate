require 'spec_helper'
class Predicate
  describe Predicate, "bind" do

    it 'allowing binding a eq placeholder' do
      p = Predicate.placeholder
      unbound = Predicate.eq(:name, p)
      bind = unbound.bind(p => "blambeau")
      expect(bind).to eql(Predicate.eq(:name, "blambeau"))
    end

    it 'allowing binding an in placeholder' do
      p = Predicate.placeholder
      unbound = Predicate.in(:name, p)
      bind = unbound.bind(p => ["blambeau","llambeau"])
      expect(bind).to eql(Predicate.in(:name, ["blambeau","llambeau"]))
    end

    it 'applies recursively placeholder' do
      p, p2 = Predicate.placeholder, Predicate.placeholder
      unbound = Predicate.eq(:name, p) & Predicate.eq(:last, p2)
      bind = unbound.bind(p => "bernard", p2 => "lambeau")
      expect(bind).to eql(Predicate.eq(:name, "bernard") & Predicate.eq(:last, "lambeau"))
    end

  end
end
