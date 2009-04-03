class Cookie
  # Return hash of cookie keys + values
  def self.parse(set_cookie)
    set_cookie.gsub!(" ", "")
    ret = {}
    cookies = set_cookie.split(";")
    cookies.each do |cookie|
      cookie_vals = cookie.split(",")
      cookie_vals.each do |cookie_val|
	pair = cookie_val.split("=")
	ret.merge!(pair.first.to_sym => pair.last)
      end
    end
    ret
  end
end
