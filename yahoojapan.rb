require "./website"

class Yahoojapan < Website
  def make_download_data
    # 主要ニュースを集める
    elements = driver.find_elements(:xpath, "//*[@id='tabpanelTopics1']/div/div[1]/ul/li")
    elements.map { |element| [@name, element.text.gsub(/\n/, ",")].join "," }
  end
end
