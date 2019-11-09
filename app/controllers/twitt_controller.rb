require 'natto'
require 'RMagick'

class TwittController < ApplicationController
  protect_from_forgery with: :null_session
  
  def top
  end

  # セリフを形成する
  def ajax_create
    content = params[:contents]
    final_line = make_line(content)
    # テーブルに格納
    line_Model = Line.create(char_no: 1, content: content, line:final_line, post_flag:0)
    # レスポンス
    @final_line = final_line
    @line_id = line_Model.id
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  # セリフをTwitterに投稿する
  def create

    logger.debug("create line_id:"+params[:line_id])

    content = "";
    # Twitterに投稿する場合、post_flagを1に更新
    line = Line.find_by(id: params[:line_id])
    content = line.content
    line.update(post_flag: 1)

    /
    client = Twitter::REST::Client.new do |config|
      config.consumer_key         = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret      = ENV['TWITTER_CONSUMER_SECRET']
      config.access_token         = ENV['TWITTER_ACCESS_TOKEN']
      config.access_token_secret  = ENV['TWITTER_ACCESS_TOKEN_SECRET']
    end
    /

    # Twitterの認証を取得し、セリフを画像とともに投稿
    auth = request.env["omniauth.auth"]
    client = Twitter::REST::Client.new do |config|
      config.consumer_key         = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret      = ENV['TWITTER_CONSUMER_SECRET']  
      config.access_token         = auth.credentials.token
      config.access_token_secret  = auth.credentials.secret
    end

    # 画像を加工
    images = Magick::ImageList.new("./app/assets/images/image.jpg")
    logger.debug(images.class)
    images = images.scale(0.25)
    image_name = SecureRandom.uuid + ".jpg"
    images.write('./tmp/'+ image_name)

    final_line = make_line(content)
    client.update_with_media(final_line, File.new('./tmp/'+ image_name)) 
    redirect_to root_path, notice: "success!"
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
