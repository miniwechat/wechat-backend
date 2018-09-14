require 'net/https'
require "uri"
# require 'aes'
require "base64"
require 'encrypt/asy_encrypt'
require 'encrypt/sym_encrypt'
# require 'models/sym_aes'
# require 'encrypt/aes_test'

class Secret::SessionsController < ApplicationController

  # APPID = 'wx6e1ee86184594b21'
  APPSECRET = 'bc47b62ba51711164d3a95222e4055b8'
  SERVER = 'https://api.weixin.qq.com/sns/jscode2session?'

  def index
  end
  
  def create
    id = params[:id].to_i || 0
    appId = params[:appId]
    secretId = APPSECRET
    # jsCode = '0238OUK31ABo7O1Qb8M31LQWK318OUKp'
    jsCode = params[:jsCode] || '0238OUK31ABo7O1Qb8M31LQWK318OUKp'
    grantType = params[:grant_type]
    code = {:appId => appId,:secret => secretId,:js_code => jsCode, :grant_type => grantType}
    self.wechatget(code)
  end

  def wechatget(message)
    uri = URI.parse(SERVER)
    data = message
    uri.query = URI.encode_www_form(data)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
    p response.body
    if (JSON.parse response.body)['errcode']
      error_detail = JSON.parse response.body
      render json: {:status => 'error',:msg => '获取会话密钥失败',:error_detail => error_detail}
    else if (JSON.parse response.body)['session_key']
           session_detail = JSON.parse response.body
           self.generate_secretkey(session_detail)
           else
             render json: {:status => 'fail',:msg => '获取密钥失败'}
           end
    end
  end

  # 根据session_key和openid生成rd_session,并存入数据库
  def generate_secretkey(session_openid)
    session_key = session_openid['session_key']
    openid = session_openid['openid']
    openid_time = openid + Time.now.utc.to_s
    sym = SymEncrypt.new
    rdSession = Base64.encode64(sym.encrypted openid_time)   # 初始化对称加密
    sys_key = Base64.encode64(sym.create_symkey)        # 未加密对称密钥
    sys_iv = Base64.encode64(sym.create_symiv)       # 未加密对称向量iv
    watermark = {:rdSession => rdSession}
    if rdSession && SessionKey.where(:rdSession => rdSession).length == 0
      SessionKey.create(:rdSession => rdSession,:session_key => session_key,:openId => openid,
                        :rdSession_key => sys_key, :rdSession_iv => sys_iv)
      render json: {:status => 'success',:msg => '获取密钥成功', :watermark => watermark}
    end
  end

end
