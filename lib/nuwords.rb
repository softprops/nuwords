#
# A Simple library for converting numeric values into words. Supports values
# up to #MAX (999,999,999,999,999). I could support more but it's not really that useful at
# that point. I draw the line at 
# 'nine hundred ninety-nine trillion nine hundred ninety-nine billion nine hundred ninety-nine million 
#  nine hundred ninety-nine thousand nine hundred ninety-nine'!
# simple usage:
#   0.in_words # => 'zero'
#   1234013.in_words    # => 'one million two hundred thirty-four thousand thirteen'
#
# custom language usage:
#   3.in_words :in => 'Mandarin'  # => 'san'
#
# custom translator usage:
#   142.in_words :translator => CustomTranslator  # => result of CustomTranslator.translate(142)
#
# @author softprops
#
module Nuwords
  # the maxiumum supported number
  MAX = 999_999_999_999_999
  
  # Translates a numeric value to words
  # This method takes an optional hash of options which include
  # :translator => The class responsible for translation behavior
  # :in         => The language Dictionary that the number should be translated into
  #                If the Dictionary for the language cannot be found an UnsupportedLanguageException will be raised
  def in_words(opts = {})
    translator = opts.delete(:translator) || Translator.new
    raise InvalidTranslatorException unless translator.respond_to?(:translate)
    translator.translate(self, opts)
  end
  
  alias_method :to_w, :in_words
  
  protected
  
  class InvalidTranslatorException < Exception; end
  class NumberNotSupportedException < Exception; end
  
  # Responsible for translating a given number into
  # words. To extend override #parse with your impl
  class Translator
    
    # The interface for performing actual translation
    def translate(number, opts = {})
      @dictionary = dictionary_for(opts[:in] || 'En')
      @dashed = opts[:dashed].nil? ? true : opts[:dashed] 
      parse(number, false)
    end
    
    protected 
    
    # Handles the core logic of interpreting
    # the given number in words
    # The language is dependent on the Dictionary provided with the 
    #:in option which defaults to En (English)
    def parse(number, ignore_zero = true)
      word = ''
      case number
      when 0
        word << @dictionary.zero! if !ignore_zero
      when 1..9
        word << @dictionary.ones![number - 1]
      when 11..19
        word << @dictionary.teens![(number - 10) - 1]
      when 10 || 20..99
        word << @dictionary.tens![(number / 10) - 1] if(number/10 > 0) 
        word << (@dashed ? '-' : '') << parse(number % 10)  if(number % 10 > 0)
      when 100..999
        word << parse(number/100) << " #{@dictionary.bigs![0]} "  if (number/100 > 0) 
        word << parse(number%100)                                 if (number%100 > 0)
      when 1_000..999_999
        word << parse((number/1000)) << " #{@dictionary.bigs![1]} "   if (number/1_000>0)
        word << parse(number%1000)                                    if (number%1_000>0)
      when 1_000_000..999_999_999
        word << parse(number/1_000_000) << " #{@dictionary.bigs![2]} "   if(number/1_000_000>0)
        word << parse(number%1_000_000)                                  if(number%1_000_000>0)
      when 1_000_000_000..999_999_999_999
        word << parse(number/1_000_000_000) << " #{@dictionary.bigs![3]} " if(number/1_000_000_000>0)
        word << parse(number%1_000_000_000)                                if(number%1_000_000_000>0)
      when 1_000_000_000_000..999_999_999_999_999
        word << parse(number/1_000_000_000_000) <<" #{@dictionary.bigs![4]} " if(number/1_000_000_000_000>0)
        word << parse(number%1_000_000_000_000)                              if(number%1_000_000_000_000>0)
      else
        raise NumberNotSupportedException.new("Number #{number} not supported")
      end
      word.strip
    end
    
    private
    
    # Fetchs the Library of words for the given
    # language
    def dictionary_for(lang)
      Dictionaries.find(lang.to_s)
    end
  end
    
  # =Language Dictionaries
  # to use your own, include Numords::Dictionaries::Dictionary
  # in a class that defines class methods #zero, #ones, #teens, #tens, #bigs
  # and invoke via 1.in_words(:in => CustomLanguage)
  module Dictionaries
    
    class UnsupportedLanguageException < Exception; end
    
    class << self
      # look up a dictionary for a given lan
      def find(lang)
        return Dictionaries.const_get(lang) if lang.kind_of?(String)
        lang
        rescue Exception => e; raise UnsupportedLanguageException.new("#{e} - unsupported language #{lang}")
      end
    end
    
    # Base behavior of Dictionary. Defines the definition
    # of accessor methods for %w( zero ones teens tens bigs )
    module Dictionary
      def self.included(klass)
        %w( zero ones teens tens bigs ).each do |classification|
          klass.class_eval %Q{
            def self.#{classification}(values)
              @@#{classification}=values
            end
            
            def self.#{classification}!
              @@#{classification}
            end
          }
        end
      end
    end # end Dictionary
    
    # English library (default)
    class En 
      include Dictionary
      zero 'zero'
      ones  %w( one two three four five six seven eight nine )
      teens %w( eleven twelve thirteen fourteen fifteen sixteen seventeen eighteen nineteen )
      tens  %w( ten twenty thirty fourty fifty sixty seventy eighty ninety )
      bigs  %w( hundred thousand million billion trillion )  
    end # end En
  end # end Dictionaries
end
Numeric.send :include, Nuwords # include in Numeric class for use