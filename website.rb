require "selenium-webdriver"

class Website
  @@RETRY = 3
  @@WAIT = 1
  attr_reader :name, :url, :userid, :password, :driver

  def initialize(**params)
    @name = params[:name]
    @url = params[:url]
    @userid = params[:userid]
    @password = params[:password]
  end

  def connect
    # option設定 非表示動作、証明書関係のエラー無視
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument "--headless"
    options.add_argument "--ignore-certificate-errors"
    options.add_argument "--ignore-ssl-errors"
    # driver設定
    @driver = Selenium::WebDriver.for(:chrome, options: options)
    @driver.get @url
  end

  def disconnect
    @driver.quit
  end

  def login
    # loginがある場合サブクラスでオーバーライト
  end

  def make_download_data
    @driver.page_source
  end

  def displayed?(element_size)
    if element_size > 0
      true
    else
      sleep @@WAIT
      false
    end
  end

  def get_data
    begin
      self.connect
      self.login
      result = self.make_download_data
      self.disconnect
      result
    rescue => error
      p error
      error
    end
  end
end
