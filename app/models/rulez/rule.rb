module Rulez
  class Rule < ActiveRecord::Base
    attr_accessible :description, :name, :rule

    belongs_to :context
  end
end
