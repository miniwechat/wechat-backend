# encoding: UTF-8
require 'openssl'
require 'base64'
class AsyEncrypt
    def initialize (sys_key,sys_iv)
      @sys_key = sys_key
      @sys_iv = sys_iv
      @rsa = OpenSSL::PKey::RSA.generate 2048
    end

    # 返回公钥
    def create_pubkey
      rsa_pub_key = @rsa.public_key
      return rsa_pub_key
    end

    def private_key

    end

    # 返回私钥加密对称密钥
    def create_sec_session
      sys_key_encrypt = @rsa.private_encrypt(@sys_key)
      return sys_key_encrypt
    end

    def create_sec_iv
      sys_key_iv = @rsa.private_encrypt(@sys_key)
      return sys_key_iv
    end

end