# -*- encoding : utf-8 -*
require 'openssl'
require 'base64'

class SymEncrypt
    def initialize
    end

    def encrypted data
      @sym = OpenSSL::Cipher.new("aes-128-cbc")
      @sym.encrypt
      @sym_key = @sym.random_key
      @sym_iv = @sym.random_iv
      encryptedData = @sym.update(data) + @sym.final
      return encryptedData
    end

    def create_symkey
      return @sym_key
    end

    def create_symiv
      return @sym_iv
    end

    def sym_encrypt data,key,iv
      encrypted = OpenSSL::Cipher.new("aes-128-cbc")
      encrypted.encrypt
      encrypted.key = Base64.decode64(key)
      encrypted.iv = Base64.decode64(iv)
      result = encrypted.update(data) + encrypted.final
      return Base64.encode64(result)
    end

    def sym_decrypt encryptedData,key,iv
      decrypted = OpenSSL::Cipher.new("aes-128-cbc")
      decrypted.decrypt
      decrypted.key = Base64.decode64(key)
      decrypted.iv = Base64.decode64(iv)
      decryptData = decrypted.update(Base64.decode64(encryptedData)) + decrypted.final
      return decryptData
    end

end