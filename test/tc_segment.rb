module TestSegment
  def test_ruby_array
    seg = Segmenter.new 4, 2
    data = (1..14).to_a
    r = seg << data
    expected = [[1, 2, 3, 4], [3, 4, 5, 6], [5, 6, 7, 8], [7, 8, 9, 10],
            [9,10,11,12],[11,12,13,14]]
    assert_m expected, r, 8
  end
  def test_incremental_seg
    pcm = (0..1000)
    frame_size = 205
    shift = 160
    segmenter = Segmenter.new frame_size, shift
    variation = [frame_size - 1, frame_size, frame_size + 1]
    segmentations = variation.map do |size|
      pcm.each_slice size do |s|
          seg = segmenter << s
      end
    end
    segmentations.each_cons 2 do |a, b|
        assert_equal a, b
    end
  end
  def test_impedence_mismatch1
    seg = Segmenter.new 4, 2
    data = (1..15).to_a
    r1 = seg << data
    data = (16..26).to_a
    r2 = seg << data
    xp1 =[[1, 2, 3, 4], [3, 4, 5, 6], [5, 6, 7, 8], [7, 8, 9, 10],
            [9,10,11,12],[11,12,13,14]]
    xp2 = [[13,14,15,16],[15,16,17,18],[17,18,19,20],[19,20,21,22],
            [21,22,23,24],[23,24,25,26]]
    assert_m xp1, r1, 5
    assert_m r2, xp2, 5
  end
  def txst_impedence_mismatch2
    seg = Segmenter.new 4, 2 
    data = (1..13).to_a
    r1 = seg << data
    data = (14..18).to_a
    r2 = seg << data
    xp1 =[[1, 2, 3, 4], [3, 4, 5, 6], [5, 6, 7, 8], [7, 8, 9, 10],[9,10,11,12]]
    xp2 = [[11,12,13,14],[13,14,15,16],[15,16,17,18]]
    assert_m xp1, r1, 5
    assert_m xp2, r2, 5
  end
  def test_underflow
    seg = Segmenter.new 4, 2
    r = seg << [1,2]
    assert_nil r
  end
  def test_ruby_fixnum_array
    seg = Segmenter.new 4, 2
    r = seg << [1,2,3,4,5,6,7,8,9,10,11,12,13,14]
    assert r[0].kind_of?(Array),  "Arrays should remain Arrays"
    #assert r[0][0].kind_of?(Fixnum), "Expected to remain Fixnum"
  end
end
