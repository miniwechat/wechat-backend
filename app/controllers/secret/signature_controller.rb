require 'openssl'
require 'digest/sha1'
require 'encrypt/sym_encrypt'
class Secret::SignatureController < ApplicationController

  def index
    from = params[:from] || 1
    to = params[:to] || 100
    result = SessionKey.all[from -1 , to]
    render json: {:status => 'success', :result => result},callback: params[:callback]
  end

  def confirm
    rawData = params[:rawData] || ''
    signature = params[:signature] || ''
    rdSession = params[:rdSession] || ''
    self.verify_confirm rawData,signature,rdSession
  end

  def scan
    rdSession = params[:rdSession] || ''
    rawData = params[:rawData] || ''
    signature = params[:signature] || ''
    lng = params[:lng] || ''
    lat = params[:lat] || ''
    timestamp = params[:timestamp] || ''
    if rdSession.length > 0
      if SessionKey.where(:rdSession => rdSession).length == 0
        render json: {:status => 'fail',:msg => '会话密钥不存在'}
      else
        rd_session = SessionKey.find(rdSession)
        session_key = rd_session.session_key
        openid = rd_session.openId
        sym_key = rd_session.rdSession_key
        sym_iv = rd_session.rdSession_iv
        signature_cal = Digest::SHA1.hexdigest(rawData+session_key)
        if signature_cal == signature
          self.scan_insert lng,lat,timestamp,openid,sym_key,sym_iv
          # render json: {:status => 'successs', :msg => '用户验证成功',:watermark => secret}
        else
          render json: {:status => 'fail', :msg => '用户验证失败'}
        end
      end
    else
      render json: {:status => 'fail', :msg => '会话密钥不可为空'}
    end
  end


  def verify_confirm (rawData,signature,rdSession)
    if rdSession.length > 0
      if SessionKey.where(:rdSession => rdSession).length == 0
        render json: {:status => 'fail',:msg => '会话密钥不存在'}
      else
        rd_session = SessionKey.find(rdSession)
        session_key = rd_session.session_key
        signature_cal = Digest::SHA1.hexdigest(rawData+session_key)
        if signature_cal == signature
          secret = {:rdSession => rd_session.rdSession,:rdSession_key => rd_session.rdSession_key,:rdSession_iv => rd_session.rdSession_iv}
          render json: {:status => 'successs', :msg => '用户验证成功',:watermark => secret}
        else
          render json: {:status => 'fail', :msg => '用户验证失败'}
        end
      end
    else
      render json: {:status => 'fail', :msg => '会话密钥不可为空'}
    end
  end

  def scan_insert (lng,lat,timestamp,openid,key,iv)
    sym_lng = SymEncrypt.new
    lng_add = 'currentLongitude:'+ lng
    lng_sec = sym_lng.sym_encrypt(lng_add,key,iv)

    sym_lng_test = SymEncrypt.new
    lng_sec_test = sym_lng_test.sym_decrypt(lng_sec,key,iv)
    p lng_sec
    p key
    p iv
    p lng_sec_test

    sym_lat = SymEncrypt.new
    lat_add = 'currentLatitude:' + lat
    lat_sec = sym_lat.sym_encrypt(lat_add,key,iv)

    sym_scanTime = SymEncrypt.new
    scanTime_add = 'currentScanTime:' + timestamp
    scanTime_sec = sym_scanTime.sym_encrypt(scanTime_add,key,iv)

    if (lng.length == 0 && lat.length == 0 && timestamp.length == 0)
      render json: {:status => 'fail', :msg => '二维码信息不全'}
    else
      if Scan.where(:lng_sec => lng_sec,:lat_sec => lat_sec,:openid => openid,:scanTime_sec => scanTime_sec).length == 0
        p lng_sec
        p lat_sec
        p scanTime_sec
        Scan.create(:lng_sec => lng_sec,:lat_sec => lat_sec,:openid => openid,:scanTime_sec => scanTime_sec)
        render json: {:status => 'success', :msg => '二维码信息上传成功'}
      else
        render json: {:status => 'fail', :msg => '二维码信息已上传'}
      end
    end
  end

  def test
    render json: {:result => 'result'}
  end
end
