class FileController < ApplicationController
  protect_from_forgery :except => :index

  def indx

  end

  def upload
    if request.post?
      filename = self.class.save_file(params[:file])
      if filename == 'exist'
        render json: {:status => 'fail', :msg => '文件已存在'}
      elsif filename == 'wrong'
        render json: {:status => 'fail', :msg => '文件名不能为空'}
      else
        render json: {:status => 'success'}
      end
    end
  end

  def download
    fileList = FileStore.all
    render json: {:fileList => fileList}
  end

  class << self
    def save_file(file)
      if file.nil? || file.original_filename.empty?
        'wrong'
      else
        filename = "#{Rails.root}/public/#{file.original_filename}"
        if File.exist?(filename)
          'exist'
        else
          File.open(filename,'wb') do |f|
            f.write(file.read)
          end
          FileStore.create(:name => file.original_filename)
        end
        filename
      end
    end
  end
end
