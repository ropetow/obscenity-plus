# test_base.rb
require 'test/unit'
require 'obscenity'

class TestObscenityBase < Test::Unit::TestCase
  def setup
    Obscenity.configure do |config|
      config.blacklist = ["badword"]
      config.whitelist = []
      config.replacement = :stars
    end
  end

  def test_methods_respond
    [:blacklist, :whitelist, :profane?, :sanitize, :replacement, :offensive, :replace].each do |method|
      assert_respond_to Obscenity::Base, method
    end
  end

  def test_profane_detection
    assert Obscenity::Base.profane?("badword")
    assert !Obscenity::Base.profane?("cleanword")
  end

  def test_sanitization
    assert_equal "*******", Obscenity::Base.sanitize("badword")
    assert_equal "cleanword", Obscenity::Base.sanitize("cleanword")
  end
end
