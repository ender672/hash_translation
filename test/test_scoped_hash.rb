require 'test/unit'
#require 'test/preload'
require 'hash_translation'

class TestScopedHash < Test::Unit::TestCase
  def setup
    @h = HashTranslation::HashBuilder.new
  end

  def test_target_bang
    assert_equal({}, @h.target!)
  end

  def test_set_target_bang
    h = {:pea => 'soup', :for => 'all'}
    @h.set_target! h
    assert_equal h, @h.target!
  end

  def test_pass_bang_to_hash
    @h.harry
    @h.dick
    @h.tom
    assert([:harry, :dick, :tom].all?{|k| @h.target!.include? k})
  end

  def test_short_keys
    @h.a = 'something'
    assert_equal 'something', @h[:a]
  end

  def test_square_brackets
    @h.bob = 'dole'
    assert_equal 'dole', @h[:bob]
  end
end