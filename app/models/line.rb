class Line < ApplicationRecord
    validates :char_no, presence: true
    validates :content, presence: true
    validates :line, presence: true
end
