module Rulez
  describe Rule do

    # This should return the minimal set of attributes required to create a valid
    # Variable. As you add validations to Variable, be sure to
    # adjust the attributes here as well.
    let(:valid_attributes) {{ 
      "name" => "MyRuleName",
      "description" => "MyRuleDescription",
      "rule" => "true",
      "parameters" => "p1, p2, p3",
      "context_id" => Context.last.id
    }}

    #
    # Initializes and saves models necessary for rule creation (only once)
    # 
    before(:all) do
      @v1 = Variable.new 
      @v1.name = "v1"
      @v1.description = "Myv1Description"
      @v1.model = "Restaurant"
      @v1.save!

      @v2 = Variable.new
      @v2.name = "v2"
      @v2.description = "Myv2Description"
      @v2.model = "User"
      @v2.save!
      
      @c1 = Context.new
      @c1.name = "c1"
      @c1.description = "MyContextDescription"
      @c1.variables = [@v1,@v2]
      @c1.save!

      @c2 = Context.new
      @c2.name = "c2"
      @c2.description = "Myc2Description"
      @c2.save!
    end

    after(:all) do
      @v1.destroy
      @v2.destroy
      @c1.destroy
      @c2.destroy
    end

    #
    # Initializes a new rule
    # 
    before(:each) do
      @rule = Rule.new valid_attributes
      @rule.context = @c1
    end

    context "Validation and Creation" do
      describe "with valid attributes" do
        it "validates a Rule" do
          @rule.valid?.should be_true
        end

        it "saves a new Rule" do
          @rule.save.should be_true
        end

        it "validates with valid param in rule" do
          @rule.rule = "p1 == true"
          @rule.valid?.should be_true, "rule: " + @rule.rule + "\nerrors: " + @rule.errors.messages.to_s

          @rule.rule = "p2 == true"
          @rule.valid?.should be_true, "rule: " + @rule.rule + "\nerrors: " + @rule.errors.messages.to_s

          @rule.rule = "p3 == true"
          @rule.valid?.should be_true, "rule: " + @rule.rule + "\nerrors: " + @rule.errors.messages.to_s
        end

        it "validates with valid variable in rule" do
          @rule.rule = "v1.id == 4"
          @rule.valid?.should be_true, "rule: " + @rule.rule + "\nerrors: " + @rule.errors.messages.to_s

          @rule.rule = "v2.id == 4"
          @rule.valid?.should be_true, "rule: " + @rule.rule + "\nerrors: " + @rule.errors.messages.to_s
        end

        it "validates with valid function in rule" do 
          @rule.rule = "thetruth == true"
          @rule.valid?.should be_true, "rule: " + @rule.rule + "\nerrors: " + @rule.errors.messages.to_s

          @rule.rule = "alie == true"
          @rule.valid?.should be_true, "rule: " + @rule.rule + "\nerrors: " + @rule.errors.messages.to_s
        end

        it "validates with valid param/var/func" do
          @rule.rule = "thetruth == true && p1 == false || p2 - p3 >= v1.id + v2.id || alie == false"
          @rule.valid?.should be_true, "rule: " + @rule.rule + "\nerrors: " + @rule.errors.messages.to_s
        end

        it "validates with blank parameters" do
          @rule.parameters = ""
          @rule.valid?.should be_true, "parameters: " + @rule.parameters + "\nerrors: " + @rule.errors.messages.to_s
          
          @rule.parameters = "   "
          @rule.valid?.should be_true, "parameters: " + @rule.parameters + "\nerrors: " + @rule.errors.messages.to_s

          @rule.parameters = nil
          @rule.valid?.should be_true, "parameters: nil\nerrors: " + @rule.errors.messages.to_s
        end

        it "validates with correct parameters syntax" do
          @rule.parameters = "p1"
          @rule.valid?.should be_true, "parameters: " + @rule.parameters + "\nerrors: " + @rule.errors.messages.to_s

          @rule.parameters = "p1, p2"
          @rule.valid?.should be_true, "parameters: " + @rule.parameters + "\nerrors: " + @rule.errors.messages.to_s

          @rule.parameters = "p1, p2, p3,   p4"
          @rule.valid?.should be_true, "parameters: " + @rule.parameters + "\nerrors: " + @rule.errors.messages.to_s

          @rule.parameters = "p1_2_3, p_1_2_3, _p_1_2_3"
          @rule.valid?.should be_true, "parameters: " + @rule.parameters + "\nerrors: " + @rule.errors.messages.to_s
        end

      end

      describe "with invalid attributes" do
        before(:each) do
          @rule.valid?.should be_true
        end

        it "should not validate without name" do
          # nil name
          @rule.name = nil
          @rule.valid?.should be_false

          # blank name
          @rule.name = "   "
          @rule.valid?.should be_false
        end

        it "should not validate with name already taken" do
          @rule.save.should be_true
          rule2 = Rule.new(
              "name" => "MyOtherRuleName",
              "description" => "MyOtherRuleDescription",
              "rule" => "false",
              "parameters" => "p4, p5, p6",
              "context_id" => @c2.id
            )
          rule2.valid?.should be_true
          rule2.name = @rule.name
          rule2.valid?.should be_false
        end

        it "should not validate without description" do
          # nil description
          @rule.description = nil
          @rule.valid?.should be_false

          # blank description
          @rule.description = "   "
          @rule.valid?.should be_false
        end

        it "should not validate without rule" do
          # nil rule
          @rule.rule = nil
          @rule.valid?.should be_false

          # blank rule
          @rule.rule = "   "
          @rule.valid?.should be_false
        end

        it "should not validate with invalid rule syntax" do
          @rule.rule = "+-true"
          @rule.valid?.should be_false
        end

        it "should not validate with non-existent var/param/func in rule" do
          @rule.rule = "non_existent_variable == true"
          @rule.valid?.should be_false
        end

        it "should not validate without context" do
          # nil context
          @rule.context = nil
          @rule.valid?.should be_false

          # invalid context_id
          @rule.context = @c1
          @rule.valid?.should be_true
          @rule.context_id = 123123
          @rule.valid?.should be_false
        end

        it "should not validate with invalid parameters syntax" do
          @rule.parameters = ","
          @rule.valid?.should be_false

          @rule.parameters = "p1,"
          @rule.valid?.should be_false

          @rule.parameters = ",p1"
          @rule.valid?.should be_false

          @rule.parameters = "p1 p2"
          @rule.valid?.should be_false

          @rule.parameters = "1p"
          @rule.valid?.should be_false

          @rule.parameters = "p1,p2,p3,p4, ,p5"
          @rule.valid?.should be_false

          @rule.parameters = "p1 ,p2"
          @rule.valid?.should be_false

          @rule.parameters = "p1,\np2"
          @rule.valid?.should be_false

          @rule.parameters = " p1 "
          @rule.valid?.should be_false

          @rule.parameters = "p.1"
          @rule.valid?.should be_false

          @rule.parameters = "p-1"
          @rule.valid?.should be_false
        end
      end
    end

    context "Modify and Deletion" do
      describe "with existent Rule" do
        before(:each) do
          @rule.save
        end

        it "should destroy it" do
          count = Rule.count
          @rule.destroy
          Rule.count.should == count-1
        end

        it "should modify all its fields" do
          # name modified
          @rule.name = "MyNewName"
          @rule.save.should be_true

          # description modified
          @rule.description = "MyNewDescription"
          @rule.save.should be_true

          # rule modified
          @rule.rule = "false"
          @rule.save.should be_true

          # parameters modified
          @rule.parameters = "p4, p5"
          @rule.save.should be_true

          # context modified
          @rule.context = @c2
          @rule.save.should be_true
        end
      end
    end

    describe "get_parameters_list" do
      it "return correct list when valid rule" do
        @rule.parameters = "p1"
        @rule.save!
        @rule.get_parameters_list.should match_array(["p1"])

        @rule.parameters = "p1, p2"
        @rule.save!
        @rule.get_parameters_list.should match_array(["p1", "p2"])

        @rule.parameters = "p1, p2, p3,   p4"
        @rule.save!
        @rule.get_parameters_list.should match_array(["p1", "p2", "p3", "p4"])

        @rule.parameters = "p1_2_3, p_1_2_3, _p_1_2_3"
        @rule.save!
        @rule.get_parameters_list.should match_array(["p1_2_3", "p_1_2_3", "_p_1_2_3"])
      end
    end

  end
end