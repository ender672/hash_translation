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

  def test_hash_translation
    h = {:existing => 'hash'}
    another_hash = {:another => 'hash'}
    HashTranslation.translate(h, COMPLEX_HASH, another_hash) do |s, d1, d2|
      s.far.reaching do
        s.effects.of do
          d1.some do
            s.literature d1.we.on.top.of.this
            s.partnership d2.another
          end
        end
      end
    end
    assert_equal(
      {:existing => 'hash', :far => {:reaching => {:effects => {:of => {:literature => 'mountain', :partnership => 'hash'}}}}},
      h
    )
  end
end