def add_log(**params)
  print "ログファイル書き込み中… "
  begin
    File.open(params[:path], mode=params[:mode]) { |f| f.write params[:text] }
    puts "成功"
  rescue => error
    p error
    error
  end
end