require "date"
require "csv"

require "./log"
require "./mail"
require "./taskleaf"
require "./yahoojapan"

def get_timestamp
  # タイムスタンプ作成
  DateTime.now.strftime("%Y-%m-%d %H:%M:%S")
end

def symbolize_keys(csv_row)
  # CSV::rowのキーをシンボル化
  csv_row.map{ |key, val| [key.to_sym, val] }.to_h
end

def create_data(scraped_data)
  # 記録用データ作成
  scraped_data.map { |row| get_timestamp + "," + row }
end

def get_scraped_data(**params)
  # WEBデータの取得
  puts "--------------------"
  puts "訪問リスト読み込み中"
  puts "--------------------"
  begin
    result = []
    CSV.foreach(params[:file_path], headers: params[:headers]) do |website_info|
      website_info = symbolize_keys website_info
      id = website_info.shift[1].to_i
      print "#{no}件目 #{website_info[:name]} からデータ取得中… "
      case id
      when 1 then
        website = Taskleaf.new(website_info)
      when 2 then
        website = Yahoojapan.new(website_info)
      else
        puts "動作未定義のためスキップ"
      end
      if website
        data = create_data(website.get_data)
        puts "完了"
        data.each {|row| puts row}
        result << data
      end
      puts "--------------------"
    end
    result.flatten
  rescue => error
    p error
    result << get_timestamp + "," + error.to_s
  end
end

def read_mail_params(**params)
  # メール送信用のパラメータ読み込み
  print "メール送信用パラメータ読み込み中… "
  begin
    result = nil
    CSV.foreach(params[:file_path], headers: params[:headers]) do |row|
      result = symbolize_keys(row)
    end
    puts "成功"
    result
  rescue => error
    p error
    error
  end
end

VISITING_LIST = "visiting_list.csv"
MAIL_PARAMS = "mail_params.csv"
LOG_FILE = "logfile.txt"

# データの取得・記録用データの生成
scraped_data = get_scraped_data(file_path: VISITING_LIST, headers: true)

=begin  # メール機能を使う場合は、 mail_params.csv に入力後、この行を削除

# メール用パラメータ読み込み
mail_log = []
mail_params = read_mail_params(file_path: MAIL_PARAMS, headers: true)
# ハッシュが返ってきたら成功
if mail_params.is_a? Hash
  # メール送信
  mail_params[:port] = mail_params[:port].to_i
  mail_params[:body] = scraped_data.join "\n"
  mail_result = send_mail(mail_params)
  # 送信結果をメールログに追加
  send_mail_log = get_timestamp + ","
  send_mail_log += mail_result.nil? ? "メール送信完了" : "メール送信失敗," + mail_result.to_s
  mail_log << send_mail_log
else
  # メールパラメータ読み込み失敗
  mail_log << get_timestamp + ",メール送信用パラメータ読み込み失敗," + mail_params.to_s
end

=end  # メール機能を使う場合は、 mail_params.csv に入力後、この行を削除

# ログの記録
#log_text = (scraped_data + mail_log).join("\n") + "\n"  # メール機能を使う場合は、 mail_params.csv に入力後、この行を復活
log_text = scraped_data.join("\n") + "\n"                # メール機能を使う場合は、 mail_params.csv に入力後、この行を削除

params = { path: LOG_FILE,
           mode: "a",
           text: log_text }
add_log(params)