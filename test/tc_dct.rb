require 'yaml'

module TestDCT
  def test_dct
    dctin = YAML.load_file 'test/yml/testdct/dctin.yml'
    dct = DCT.new 13, dctin[0].size
    result = dct << dctin
    dctexp = YAML.load_file 'test/yml/testdct/dctexp.yml'
    assert_m dctexp, result, 6
  end
  def test_melcos
    dct = DCT.new 13, 40
    result = dct.melcos
    expected = 
      [[1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0], [0.999229036240723, 0.993068456954926, 0.98078528040323, 0.962455236453647, 0.938191335922484, 0.908143173825081, 0.872496007072797, 0.831469612302545, 0.785316930880745, 0.734322509435686, 0.678800745532942, 0.619093949309834, 0.555570233019602, 0.488621241496955, 0.418659737537428, 0.346117057077493, 0.271440449865074, 0.195090322016128, 0.117537397457838, 0.0392598157590687, -0.0392598157590685, -0.117537397457838, -0.195090322016128, -0.271440449865074, -0.346117057077493, -0.418659737537428, -0.488621241496955, -0.555570233019602, -0.619093949309834, -0.678800745532941, -0.734322509435686, -0.785316930880745, -0.831469612302545, -0.872496007072797, -0.908143173825081, -0.938191335922484, -0.962455236453647, -0.98078528040323, -0.993068456954926, -0.999229036240723], [0.996917333733128, 0.972369920397677, 0.923879532511287, 0.852640164354092, 0.760405965600031, 0.649448048330184, 0.522498564715949, 0.38268343236509, 0.233445363855905, 0.078459095727845, -0.0784590957278449, -0.233445363855905, -0.38268343236509, -0.522498564715949, -0.649448048330184, -0.760405965600031, -0.852640164354092, -0.923879532511287, -0.972369920397677, -0.996917333733128, -0.996917333733128, -0.972369920397677, -0.923879532511287, -0.852640164354092, -0.760405965600031, -0.649448048330184, -0.522498564715949, -0.38268343236509, -0.233445363855905, -0.0784590957278456, 0.0784590957278452, 0.233445363855905, 0.38268343236509, 0.522498564715948, 0.649448048330184, 0.76040596560003, 0.852640164354092, 0.923879532511287, 0.972369920397677, 0.996917333733128], [0.993068456954926, 0.938191335922484, 0.831469612302545, 0.678800745532942, 0.488621241496955, 0.271440449865074, 0.0392598157590687, -0.195090322016128, -0.418659737537428, -0.619093949309834, -0.785316930880745, -0.908143173825081, -0.98078528040323, -0.999229036240723, -0.962455236453647, -0.872496007072797, -0.734322509435686, -0.555570233019602, -0.346117057077493, -0.117537397457838, 0.117537397457837, 0.346117057077493, 0.555570233019602, 0.734322509435686, 0.872496007072797, 0.962455236453647, 0.999229036240723, 0.98078528040323, 0.908143173825081, 0.785316930880745, 0.619093949309834, 0.418659737537428, 0.195090322016129, -0.0392598157590685, -0.271440449865074, -0.488621241496954, -0.678800745532942, -0.831469612302545, -0.938191335922484, -0.993068456954926], [0.987688340595138, 0.891006524188368, 0.707106781186548, 0.453990499739547, 0.156434465040231, -0.156434465040231, -0.453990499739547, -0.707106781186547, -0.891006524188368, -0.987688340595138, -0.987688340595138, -0.891006524188368, -0.707106781186548, -0.453990499739547, -0.156434465040231, 0.156434465040231, 0.453990499739547, 0.707106781186547, 0.891006524188368, 0.987688340595138, 0.987688340595138, 0.891006524188368, 0.707106781186548, 0.453990499739547, 0.156434465040231, -0.15643446504023, -0.453990499739547, -0.707106781186547, -0.891006524188368, -0.987688340595138, -0.987688340595138, -0.891006524188368, -0.707106781186547, -0.453990499739548, -0.15643446504023, 0.15643446504023, 0.453990499739547, 0.707106781186547, 0.891006524188368, 0.987688340595138], [0.98078528040323, 0.831469612302545, 0.555570233019602, 0.195090322016128, -0.195090322016128, -0.555570233019602, -0.831469612302545, -0.98078528040323, -0.98078528040323, -0.831469612302545, -0.555570233019602, -0.195090322016129, 0.195090322016128, 0.555570233019602, 0.831469612302545, 0.98078528040323, 0.98078528040323, 0.831469612302546, 0.555570233019602, 0.195090322016129, -0.195090322016127, -0.555570233019602, -0.831469612302545, -0.980785280403231, -0.980785280403231, -0.831469612302546, -0.555570233019602, -0.195090322016128, 0.195090322016127, 0.555570233019602, 0.831469612302545, 0.98078528040323, 0.980785280403231, 0.831469612302546, 0.555570233019603, 0.195090322016128, -0.195090322016127, -0.555570233019602, -0.831469612302545, -0.98078528040323], [0.972369920397677, 0.760405965600031, 0.38268343236509, -0.0784590957278449, -0.522498564715949, -0.852640164354092, -0.996917333733128, -0.923879532511287, -0.649448048330184, -0.233445363855905, 0.233445363855905, 0.649448048330184, 0.923879532511287, 0.996917333733128, 0.852640164354093, 0.522498564715949, 0.0784590957278457, -0.38268343236509, -0.76040596560003, -0.972369920397677, -0.972369920397677, -0.760405965600031, -0.382683432365091, 0.078459095727845, 0.522498564715948, 0.852640164354092, 0.996917333733128, 0.923879532511287, 0.649448048330184, 0.233445363855906, -0.233445363855904, -0.649448048330184, -0.923879532511286, -0.996917333733128, -0.852640164354093, -0.522498564715951, -0.0784590957278443, 0.38268343236509, 0.76040596560003, 0.972369920397676], [0.962455236453647, 0.678800745532942, 0.195090322016128, -0.346117057077493, -0.785316930880745, -0.993068456954926, -0.908143173825081, -0.555570233019602, -0.039259815759069, 0.488621241496955, 0.872496007072797, 0.999229036240723, 0.831469612302546, 0.418659737537428, -0.117537397457837, -0.619093949309834, -0.938191335922484, -0.980785280403231, -0.734322509435685, -0.271440449865074, 0.271440449865074, 0.734322509435685, 0.98078528040323, 0.938191335922484, 0.619093949309835, 0.117537397457839, -0.418659737537428, -0.831469612302545, -0.999229036240723, -0.872496007072797, -0.488621241496955, 0.0392598157590682, 0.555570233019602, 0.908143173825081, 0.993068456954927, 0.785316930880746, 0.346117057077492, -0.195090322016129, -0.678800745532942, -0.962455236453647], [0.951056516295154, 0.587785252292473, 6.12323399573677e-17, -0.587785252292473, -0.951056516295154, -0.951056516295154, -0.587785252292473, -1.83697019872103e-16, 0.587785252292473, 0.951056516295154, 0.951056516295154, 0.587785252292473, 3.06161699786838e-16, -0.587785252292473, -0.951056516295153, -0.951056516295154, -0.587785252292473, -4.28626379701574e-16, 0.587785252292473, 0.951056516295153, 0.951056516295154, 0.587785252292474, 5.51091059616309e-16, -0.587785252292473, -0.951056516295153, -0.951056516295154, -0.587785252292472, -2.44991257893129e-15, 0.587785252292474, 0.951056516295153, 0.951056516295153, 0.587785252292475, -9.80336419954471e-16, -0.587785252292471, -0.951056516295154, -0.951056516295154, -0.587785252292472, -2.69484193876077e-15, 0.587785252292474, 0.951056516295153], [0.938191335922484, 0.488621241496955, -0.195090322016128, -0.785316930880745, -0.999229036240723, -0.734322509435686, -0.117537397457838, 0.555570233019602, 0.962455236453647, 0.908143173825081, 0.418659737537428, -0.271440449865074, -0.831469612302545, -0.993068456954926, -0.678800745532943, -0.0392598157590693, 0.619093949309834, 0.98078528040323, 0.872496007072798, 0.346117057077494, -0.346117057077493, -0.872496007072797, -0.980785280403231, -0.619093949309835, 0.0392598157590682, 0.678800745532942, 0.993068456954926, 0.831469612302545, 0.271440449865076, -0.418659737537426, -0.908143173825081, -0.962455236453648, -0.555570233019603, 0.117537397457837, 0.734322509435686, 0.999229036240723, 0.785316930880746, 0.19509032201613, -0.488621241496953, -0.938191335922484], [0.923879532511287, 0.38268343236509, -0.38268343236509, -0.923879532511287, -0.923879532511287, -0.38268343236509, 0.38268343236509, 0.923879532511287, 0.923879532511287, 0.382683432365091, -0.38268343236509, -0.923879532511286, -0.923879532511287, -0.382683432365091, 0.38268343236509, 0.923879532511286, 0.923879532511287, 0.382683432365091, -0.38268343236509, -0.923879532511286, -0.923879532511288, -0.382683432365091, 0.38268343236509, 0.923879532511287, 0.923879532511288, 0.382683432365091, -0.382683432365089, -0.923879532511287, -0.923879532511288, -0.382683432365091, 0.382683432365089, 0.923879532511287, 0.923879532511288, 0.382683432365091, -0.382683432365089, -0.923879532511287, -0.923879532511288, -0.382683432365091, 0.382683432365089, 0.923879532511287], [0.908143173825081, 0.271440449865074, -0.555570233019602, -0.993068456954926, -0.734322509435686, 0.0392598157590678, 0.785316930880744, 0.980785280403231, 0.488621241496956, -0.346117057077491, -0.938191335922483, -0.872496007072798, -0.19509032201613, 0.619093949309832, 0.999229036240723, 0.678800745532944, -0.117537397457836, -0.831469612302544, -0.962455236453648, -0.418659737537431, 0.418659737537426, 0.962455236453646, 0.831469612302547, 0.117537397457843, -0.678800745532939, -0.999229036240723, -0.619093949309838, 0.195090322016125, 0.872496007072794, 0.938191335922486, 0.346117057077496, -0.48862124149695, -0.98078528040323, -0.785316930880749, -0.0392598157590735, 0.734322509435683, 0.993068456954927, 0.555570233019606, -0.271440449865071, -0.908143173825077], [0.891006524188368, 0.156434465040231, -0.707106781186547, -0.987688340595138, -0.453990499739547, 0.453990499739547, 0.987688340595138, 0.707106781186548, -0.15643446504023, -0.891006524188368, -0.891006524188368, -0.15643446504023, 0.707106781186547, 0.987688340595138, 0.453990499739548, -0.453990499739547, -0.987688340595138, -0.707106781186547, 0.156434465040229, 0.891006524188368, 0.891006524188369, 0.156434465040231, -0.707106781186546, -0.987688340595138, -0.453990499739548, 0.453990499739547, 0.987688340595137, 0.707106781186548, -0.156434465040229, -0.891006524188368, -0.891006524188369, -0.156434465040231, 0.707106781186546, 0.987688340595138, 0.453990499739549, -0.453990499739543, -0.987688340595138, -0.707106781186548, 0.156434465040229, 0.891006524188366]] 
    expected.map! {|row| row.map{|e|e / 13}}
    expected.zip(result) {|a,b| a.zip(b) {|x,y| assert_in_delta x,y,0.000001}}
  end 
end
