
  while true
    begin
      tap do
        :begin
      rescue
        :rescue
      else
        :else
      ensure
        :ensure
      end
    rescue
      retry
    else
      retry
    end
    break
  end
