require 'test_helper'

# English library (default)
class AnotherLanguage 
  include Nuwords::Dictionaries::Dictionary
  zero  'zero'
  ones  %w( blah meh nom si wu liu chi ba nine )
  teens %w( eleven twelve thirteen fourteen fifteen sixteen seventeen eighteen nineteen )
  tens  %w( bacon twenty thirty fourty fifty sixty seventy eighty ninety )
  bigs  %w( hundred thousand million billion trillion )  
end

class NuwordsTest < Test::Unit::TestCase
  
  context "the library" do
    should "provide the maxiumum supported value" do
      assert true, Nuwords.const_defined?(:MAX)
    end
    context "when given a bogus translator" do
      should "raise a InvalidTranslatorException" do
        assert_raise Nuwords::InvalidTranslatorException do
          1.in_words(:translator => Hash)
        end
      end
    end
  end
  
  context "a numberic value" do
    context "less than one" do
      should "translate to zero" do
        assert_equal "zero", 0.in_words
      end
    end
    
    context "that is greater than ten and less than on hundred" do
      should "be delimited by a dash if not devisible evenly by ten" do
        assert_equal "twenty-five", 25.in_words 
      end
      
      context "when requested not to have dashes" do
        should "not be delimited by a dash if not devisible evenly by ten" do
          assert_equal "twentyfive", 25.in_words(:dashed => false)
        end
      end
    end
    
    context "that is translated to a custom language" do
      should "translate numeric values accordingly" do
        assert_equal 'bacon', 10.in_words(:in => AnotherLanguage)
      end
    end
    
    context "that is translated to a bogus language" do
      should "raise an UnsupportedLanguageException" do
        assert_raise Nuwords::Dictionaries::UnsupportedLanguageException do
          10.in_words(:in => "asdf")
        end
      end
    end
    
    context "that is less or equal to 999,999,999,999,999" do
      should "not raise a NumberNotSupportedException" do
        assert_nothing_raised do
          # 0.upto(999_999_999_999_999) works but takes a good while to run
          (999_999_999_999_999 - 1).in_words
          999_999_999_999_999.in_words
        end
      end
    end
    
    context "that is greater than 999,999,999,999,999" do
      should "raise a NumberNotSupportedException" do
        assert_raise Nuwords::NumberNotSupportedException do
          999_999_999_999_999.next.in_words
        end
      end
    end
    
    should "respond to aliased method #to_w" do
      assert true, 1.respond_to?(:to_w)
    end
    
    should "return the same value when #to_w is called as with #in_words" do
      assert_equal 1.to_w, 1.in_words
    end
  end
end