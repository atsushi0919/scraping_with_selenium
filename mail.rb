require "mail"

def send_mail(**params)
  print "メール送信中… "
  retry_count = 3
  begin
    # メール作成
    mail = Mail.new
    mail.from params[:from]
    mail.to params[:to]
    mail.subject params[:subject]
    mail.body params[:body]

    # オプション設定
    options = { address: params[:address],
                port: params[:port],
                domain: params[:domain],
                user_name: params[:user_name],
                password: params[:password],
                authentication: :plain,
                enable_starttls_auto: true }
    mail.charset = 'utf-8'
    mail.delivery_method(:smtp, options)
    mail.deliver!
    puts "成功"
  rescue => error
    puts "失敗" if retry_count == 3
    puts "・リトライします(あと#{retry_count} 回)"
    retry_count -= 1
    retry if retry_count > 0
    puts "メール送信失敗"
    error
  end
end