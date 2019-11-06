require 'natto'
require 'RMagick'

class TwittController < ApplicationController
  protect_from_forgery with: :null_session
  
  def top
  end

  def ajax_create
    content = params[:contents]
    final_line = make_line(content)
    lineModel = Line.create(char_no: 1, content: content, line:final_line, post_flag:0)
    @final_line = final_line
    @line_id = lineModel.id
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def create
    content = "";

    if !(params[:line_id].blank?)
      logger.debug("create line_id:"+params[:line_id])
      line = Line.find_by(id: params[:line_id])
      content = line.content
      line.update(post_flag: 1)
    else
      content = params[:contents]
    end

    /
    client = Twitter::REST::Client.new do |config|
      config.consumer_key         = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret      = ENV['TWITTER_CONSUMER_SECRET']
      config.access_token         = ENV['TWITTER_ACCESS_TOKEN']
      config.access_token_secret  = ENV['TWITTER_ACCESS_TOKEN_SECRET']
    end
    /

    auth = request.env["omniauth.auth"]
    logger.debug('debug code')
    logger.debug(auth)
    client = Twitter::REST::Client.new do |config|
      config.consumer_key         = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret      = ENV['TWITTER_CONSUMER_SECRET']  
      config.access_token         = auth.credentials.token
      config.access_token_secret  = auth.credentials.secret
    end

   # fileObj = []
   # fileObj << File.new('./app/assets/images/image.jpg') # fileobject
    images = Magick::ImageList.new("./app/assets/images/image.jpg")
    logger.debug(images.class)
    images = images.scale(0.25)
    images.write('./tmp/'+'aaa.jpg')
    #fileObj = StringIO.open(images.to_blob)
    #client.update(params[:contents])
    #logger.debug(fileObj.class)
    final_line = make_line(content)
    client.update_with_media(final_line, File.new('./tmp/'+'aaa.jpg')) 
    redirect_to root_path, notice: final_line
    images.destroy!
  end
  
  # セリフを形成する
  def make_line(base_line)
  
    base_line0 = 'すごいやん！'
    base_line1 = '@dなんて、誰しもができるもんやないで。'
    base_line2 = 'しかも@mかぁ…ほんますごいわ。'
    base_line3 = '無理せんと、しっかり気分転換するんやで！'
  
    natto = Natto::MeCab.new

    m_flg = false
    d_flg = false

    natto.parse(base_line) do |n|
    
      if n.feature.start_with?('動詞') then
        base_line1.sub!('@d', n.surface)
        d_flg = true
      end

      if n.feature.start_with?('名詞') then
        base_line2.sub!('@m', n.surface)
        m_flg = true
      end
    end
    
    # 文字列の連結
    final_line = base_line0
    if d_flg then
      final_line = final_line + base_line1
    end
    if m_flg then
      final_line = final_line + base_line2
    end
    final_line = final_line + base_line3
    
    return final_line
  end
end
