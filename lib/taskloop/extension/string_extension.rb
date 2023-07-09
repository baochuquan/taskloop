class String
  require 'digest'

  def sha1
    sha1_digest = Digest::SHA1.new
    sha1_digest.update(self)
    return sha1_digest.hexdigest
  end

  def sha1_32bit
    sha1[0..31]
  end

  def sha1_16bit
    sha1[0..15]
  end
end