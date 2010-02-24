
module Area51
  def is_it_true?
    false
  end
end
module TestMe
  def test_foo
    assert is_it_true?
  end
end
