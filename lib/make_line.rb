require 'natto'

class MakeLine
    
  # 形成したセリフを返却する
  def get_line(char_no, target_text)

    natto = Natto::MeCab.new
    natto_result = natto.enum_parse(target_text)

    if char_no == 1 then
      # キャラクターNo.1の場合
      @in_base_line0 = 'すごいやん！'

      @in_base_line_1_do = '@m_sなんて、誰しもができるもんやないで。'
      @in_base_line_2_do = 'しかも@fかぁ…ほんますごいわ。'

      @in_base_line_1_not_do = '@dなんて、頑張ったなあ。'
      @in_base_line_2_not_do = 'しかも@mfか…えらいわ。'
      
      @in_base_line_3 = '無理せんと、しっかり気分転換するんやで！'

    elsif char_no == 2 then
      # キャラクターNo.2の場合
      @in_base_line0 = 'すごいですね。'

      @in_base_line_1_do = '@m_sなんて、簡単にできるものではないです。'
      @in_base_line_2_do = 'しかも@f…本当にすごいですね。'

      @in_base_line_1_not_do = '@dなんて、よく頑張りましたね。'
      @in_base_line_2_not_do = 'しかも@mf…えらいです。'
      
      @in_base_line_3 = '私も頑張らないと…。'
    end

    return make_line(natto_result)
  end
  
  private
    # セリフを形成する
    def make_line(target_line)

      line1_flg = false
      line2_flg = false
      base_line1 = ""
      base_line2 = ""

      if has_do(target_line) then
        # 「する」で終わっている場合
        target_line.each do |n|

          if (n.feature.start_with?('名詞') && n.feature.include?('サ変接続'))\
            || (n.feature.start_with?('名詞') && n.feature.include?('一般')) then
            base_line1 = @in_base_line_1_do.sub!('@m_s', n.surface)
            line1_flg = true
          end
          if n.feature.start_with?('副詞')\
            || n.feature.include?('副詞可能') then
            base_line2 = @in_base_line_2_do.sub!('@f', n.surface)
            line2_flg = true
          end
        end
      else
        # 「する」で終わっていない場合
        target_line.each do |n|

          if n.feature.start_with?('動詞') then
            base_line1 = @in_base_line_1_not_do.sub('@d', n.feature.split(",")[6])
            line1_flg = true
          end
          if n.feature.start_with?('名詞')\
            || n.feature.start_with?('副詞')\
            || n.feature.include?('副詞可能') then
            base_line2 = @in_base_line_2_not_do.sub('@mf', n.surface)
            line2_flg = true
          end
        end
      end

      # 文字列の連結
      final_line = @in_base_line0
      if line1_flg then
        final_line = final_line + base_line1
      end
      if line2_flg then
        final_line = final_line + base_line2
      end
      final_line = final_line + @in_base_line_3
      return final_line
    end

    private
    # 動詞「する」を含んでいるかチェック
    def has_do(target_line)
      target_line.each do |n|
        if n.feature.start_with?('動詞') then
          if n.feature.split(",")[6] == "する" then
            return true
          end
        end
      end
      return false 
    end
end