require "./website"

class Taskleaf < Website
  def login
    # ログイン操作
    @driver.find_element(:id, "session_email").send_keys(@userid)
    @driver.find_element(:id, "session_password").send_keys(@password)
    @driver.find_element(:name, "commit").click
  end

  def make_download_data
    # ログインクリック後の表示待ち
    @@RETRY.times {
      break if displayed? @driver.find_elements(:tag_name, "tr").size
    }
    # trタグ以下の情報を集める
    elements = @driver.find_elements(:tag_name, "tr")
    elements[1..-1].reverse.map { |element| [@name, element.text].join "," }
  end
end
