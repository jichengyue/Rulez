require "spec_helper"

module Rulez
  describe Rulez do
    it "runs doctor and no errors are found" do
      errors = Rulez::doctor
      errors.should be_empty
    end
  end
end