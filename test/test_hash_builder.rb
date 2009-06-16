require 'test/unit'
#require 'test/preload'
require 'hash_translation'

class TestHashBuilder < Test::Unit::TestCase
  def setup
    @h = HashTranslation::HashBuilder.new
  end

  def test_create_key
    @h.something
    assert_equal({:something => {}}, @h.target!)
  end

  def test_create_key_value
    @h.this_is_a_key 'this is a value'
    assert_equal({:this_is_a_key => 'this is a value'}, @h.target!)
  end

  def test_create_key_value_with_equals
    @h.test_with_equals = 'this is the value'
    assert_equal({:test_with_equals => 'this is the value'}, @h.target!)
  end

  def test_create_key_value_with_square_brackets
    @h['string as a key'] = 'value from string key'
    @h[:symbol_key] = 'val from symbol'
    assert_equal(
      {'string as a key' => 'value from string key', :symbol_key => 'val from symbol'},
      @h.target!
    )
  end

  def test_chained_methods
    @h.on.and.on.we.keep 'going'
    assert_equal(
      {:on => {:and => {:on => {:we => {:keep => 'going'}}}}},
      @h.target!
    )
  end

  def test_dont_harm_existing_values
    @h.rock.and 'roll'
    @h.rock.a.bye 'baby'
    assert_equal(
      {:rock => {:and => 'roll', :a => {:bye => 'baby'}}},
      @h.target!
    )
  end

  def test_scope
    @h.rock do
      @h.paper 'scissors'
    end
    assert_equal({:rock => {:paper => 'scissors'}}, @h.target!)
  end

  def test_chaining_with_scope
    @h.once.upon.a do
      @h.time.there.was.a 'princess'
      @h.while.you.find 'pebbles'
    end
    assert_equal(
      {:once => {:upon => {:a => {:time => {:there => {:was => {:a => 'princess'}}}, :while => {:you => {:find => 'pebbles'}}}}}},
      @h.target!
    )
  end

  def test_no_value_given
    @h.wheres_my_value
    assert_equal({:wheres_my_value => {}}, @h.target!)
  end

  def test_nil_value_given_doesnt_create_an_empty_hash
    @h.ladies_and_gentlemen nil
    assert_equal({:ladies_and_gentlemen => nil}, @h.target!)
  end

  def test_assign_and_continue
    i = @h.sometimes
    i.feel 'lonely'
    assert_equal({:sometimes => {:feel => 'lonely'}}, @h.target!)
  end

  def test_assign_and_start_block
    i = @h.sometimes
    i.feel 'lonely'
    assert_equal({:sometimes => {:feel => 'lonely'}}, @h.target!)
  end
  
  def test_multiple_assign_and_manipulate_in_block
    a = @h.two.levels
    a.down do
      @h.deep.we 'go'
      a.deep.you 'see'
    end
    assert_equal(
      {:two => {:levels => {:down => {:deep => {:we => 'go', :you => 'see'}}}}},
      @h.target!
    )
  end

  def test_block_var
    @h.we do |we|
      we.hop 'sometimes'
      we.skip 'sometimes'
    end
    assert_equal({:we => {:hop => 'sometimes', :skip => 'sometimes'}}, @h.target!)
  end

  def test_block_with_arg
    @h.boat({:full => {:steam => 'ahead'}}) do
      @h.watch 'out'
    end
    assert_equal(
      {:boat => {:full => {:steam => 'ahead'}, :watch => 'out'}},
      @h.target!
    )
  end

  def test_double_double
    @h.pirates.lasers do
      @h.harpoons.whales do
        @h.gimme.gimme 'bang'
      end
    end
    assert_equal(
      {:pirates => {:lasers => {:harpoons => {:whales => {:gimme => {:gimme => 'bang'}}}}}},
      @h.target!
    )
  end
end

