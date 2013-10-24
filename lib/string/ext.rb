class String
  # ascii control characters (length=29) to map (exclude tab,lf,cr)
  CCHAR="\x00\x01\x02\x03\x04\x05\x06\x07\x08\x0B\x0C\x0E\x0F\x11\x12\x13\x14\x15\x16\x17\x18\x19\x1A\x1B\x1C\x1D\x1E\x1F";
  # Map to 
  CMAPP='.............................'
  
  # extended ascii characters (length=128) to map 
  # €?‚ƒ„…†‡ˆ‰Š‹Œ?Ž??‘’“”•–—˜™š›œ?žŸ?¡¢£¤¥¦§¨©ª«¬­®¯°±²³´µ¶·¸¹º»¼½¾¿ÀÁÂÃÄÅÆÇÈÉÊ?ÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿ
  # E?,f,.++^%S<C?Z??''"".--~Ts>o?zY?!c$oY|S.Ca<--R-o+23'uP.,10>113?AAAAAAACEEE?IIIIDNOOOOOx0UUUUYpBaaaaaaaceeeeiiiionooooo-ouuuuypy
  XCHAR="\x80\x81\x82\x83\x84\x85\x86\x87\x88\x89\x8A\x8B\x8C\x8D\x8E\x8F\x90\x91\x92\x93\x94\x95\x96\x97\x98\x99\x9A\x9B\x9C\x9D\x9E\x9F\xA0\xA1\xA2\xA3\xA4\xA5\xA6\xA7\xA8\xA9\xAA\xAB\xAC\xAD\xAE\xAF\xB0\xB1\xB2\xB3\xB4\xB5\xB6\xB7\xB8\xB9\xBA\xBB\xBC\xBD\xBE\xBF\xC0\xC1\xC2\xC3\xC4\xC5\xC6\xC7\xC8\xC9\xCA\xCB\xCC\xCD\xCE\xCF\xD0\xD1\xD2\xD3\xD4\xD5\xD6\xD7\xD8\xD9\xDA\xDB\xDC\xDD\xDE\xDF\xE0\xE1\xE2\xE3\xE4\xE5\xE6\xE7\xE8\xE9\xEA\xEB\xEC\xED\xEE\xEF\xF0\xF1\xF2\xF3\xF4\xF5\xF6\xF7\xF8\xF9\xFA\xFB\xFC\xFD\xFE\xFF"
  XMAPP='E?,f,.++^%S<C?Z??\'\'"".==~Ts>o?zY?!c$oY|S.Ca<==R=o+23\'uP.,10>113?AAAAAAACEEE?IIIIDNOOOOOx0UUUUYpBaaaaaaaceeeeiiiionooooo=ouuuuypy' # dont use a "-" as this is a special range indicator !!
  
  # Map a string to utf7 (converting extended chatacters, to there closest 7 bit equivalent)
  def toutf7!
    self.tr!(CCHAR,CMAPP) if ( self =~ /[\x00-\x31]/)
    self.tr!(XCHAR,XMAPP) if ( self =~ /[\x80-\xFF]/)
    self
  end

  # return class given a name
  def to_class
    Kernel.const_get(self.camelcase)
  end
  
end