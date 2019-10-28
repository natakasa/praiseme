require 'natto'

class TwittController < ApplicationController
  protect_from_forgery with: :null_session
  
  def top
  end

  def ajax_create
    @final_line = make_line(params[:contents])
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def create
    client = Twitter::REST::Client.new do |config|
      config.consumer_key         = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret      = ENV['TWITTER_CONSUMER_SECRET']
      config.access_token         = ENV['TWITTER_ACCESS_TOKEN']
      config.access_token_secret  = ENV['TWITTER_ACCESS_TOKEN_SECRET']
    end
    
    images = []
    images << File.new('./app/assets/images/image.jpg')

    #client.update(params[:contents])
    final_line = make_line(params[:contents])
    client.update_with_media(final_line, images)
    redirect_to root_path, notice: final_line
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
