require 'encrypt/sym_encrypt'

class WechatController < ApplicationController

  def index
    # from = params[:from] || 1
    # to = params[:to] || 100
    time = params[:time] || ''
    cate = params[:cate] || ''
    rdSession = params[:rdSession] || ''
    if rdSession.length > 0 && SessionKey.where(:rdSession => rdSession).length > 0
      if time == '0' # 一月之内
        if cate == '0' # 一月之内典型信息
          typical = []
          result = Scan.where("created_at > ?",Time.now - 1.month)
          result.each do |item|
            typical_item = {:id => item.id,:lng => item.lng_sec,:lat => item.lat_sec}
            typical.push(typical_item)
          end
        render json: {:status => "success", :msg => '一月内典型信息',:result => typical}, callback: params['callback']
        else if cate == '1' #一月之内全部信息
               result = Scan.where("created_at > ?",Time.now - 1.month)
               render json: {:status => 'success', :msg => '一月之内全部信息',:result => result},callback: params['callback']
             else
               render json: {:status => 'fail', :msg => '查询条件不全'},callback: params['callback']
             end
        end
      else if time == '1' # 一年之内
             if cate == '0' # 一年之内典型信息
               typical = []
               result = Scan.where("created_at > ?",Time.now - 1.year)
               result.each do |item|
                 typical_item = {:id => item.id,:lng => item.lng_sec,:lat => item.lat_sec}
                 typical.push(typical_item)
               end
               render json: {:status => "success", :msg => '一年内典型信息',:result => typical}, callback: params['callback']
             else if cate == '1' #一年之内全部信息
                    result = Scan.where("created_at > ?",Time.now - 1.month)
                    render json: {:status => 'success', :msg => '一年内全部信息',:result => result},callback: params['callback']
                  else
                    render json: {:status => 'fail', :msg => '查询条件不全'},callback: params['callback']
                  end
             end
           else
             render json: {:status => 'fail', :msg => '查询条件不全'},callback: params['callback']
           end
      end
    else
      render json: {:status => 'fail', :msg => '用户不存在'},callback: params['callback']
    end
  end

  # def create
  #   id = params[:id].to_i || 0
  #   if id >= 0 && Scan.where(:id => id).length == 0
  #     lng = params[:lng] || 121.449314
  #     lat = params[:lat] || 31.030629
  #     timestamp = params[:timestamp]
  #     result = Scan.create(:id => id, :lng=> lng.to_f, :lat=> lat.to_f, :timestamp=> timestamp)
  #     render json: {:status => "success", :result => result}, callback: params['callback']
  #   else
  #     render json: {:status => "fail", :msg=> "添加失败"}, callback: params['callback']
  #   end
  # end
  #
  # def update
  #   id = params[:id].to_i
  #   if id >= 0 && id <100 && Scan.where(:id => id).length == 1
  #     scan = Scan.find(id)
  #     lng = params[:lng] || scan.lng
  #     lat = params[:lat] || scan.lat
  #     timestamp = params[:timestamp] || scan.timestamp
  #     result = Scan.update(:id => id, :lng=> lng.to_f, :lat=> lat.to_f, :timestamp=> timestamp)
  #     render json: {:status => "success", :result => result}, callback: params['callback']
  #   else
  #     render json: {:status => "fail", :msg => "更新失败"}, callback: params['callback']
  #   end
  # end
  #
  # def delete
  #   id = params[:id].to_i
  #   if id > 0 && Scan.where(:id => id).length == 1
  #     scan = Scan.find(id)
  #     result = scan.destroy
  #     render json: {:status => "success", :result => !result.nil?}, callback: params['callback']
  #   else
  #     render json: {:status => "fail", :msg => "清除数据失败"}, callback: params['callback']
  #   end
  # end

  def decode
    rdSession = params[:rdSession] || ''
    encryptedData = params[:encryptedData] || ''
    sym_key = params[:key] || ''
    sym_iv = params[:iv] || ''
    if encryptedData.length > 0 && rdSession.length > 0 && sym_key.length >0 && sym_iv.length > 0 && SessionKey.where(:rdSession => rdSession).length > 0
      encrypted = SymEncrypt.new
      data = encrypted.sym_decrypt(encryptedData,sym_key,sym_iv)
      render json: {:status => 'success',:result => data},callback: params[:callback]
    else
      p 'fail'
      render json: {:status => 'fail'}
    end
  end

end
