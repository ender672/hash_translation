require 'test/unit'
#require 'test/preload'
require 'hash_translation'

class TestHashReader < Test::Unit::TestCase
  COMPLEX_HASH = {
    :hi => %w{silly buns button lungs},
    :some => {
      :time => 'ago',
      :we => {
        :stood => nil,
        :on => {
          :top => {
            :of => {
              :this => 'mountain'
            }
          }
        }
      }
    }
  }

  def setup
    @h = HashTranslation::HashReader.new(COMPLEX_HASH)
  end

  def test_attribute_access
    assert_equal 'ago', @h.some.time
    assert_equal COMPLEX_HASH[:hi], @h.hi
  end

  def test_square_bracket_access
    assert_equal 'ago', @h.some[:time]
    assert_equal COMPLEX_HASH[:hi], @h[:hi]
  end

  def test_scope
    a = 'something'
    b = nil
    @h.some.we do
      a = @h.stood
      b = @h.on.top.of.this
    end
    assert_nil a
    assert_equal 'mountain', b
  end

  def test_scope_with_var
    a = 'something'
    b = nil
    @h.some.we do |we|
      a = we.stood
      b = we.on.top.of.this
    end
    assert_nil a
    assert_equal 'mountain', b
  end
end