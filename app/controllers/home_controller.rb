class HomeController < ApplicationController
  def index
  	#intialize variables on request
    session[:max_time] ||= 1.hour.from_now.to_i
	session[:current_ip] ||= request.remote_ip
	session[:request_count] ||= 1
	# start counter and timer
	if Time.now.to_i < session[:max_time] && request.remote_ip == session[:current_ip]
   		session[:request_count] += 1
   		#limit the request count to 100
   		if session[:request_count] >= 100
   			#compute for the time remaining
   			n = session[:max_time] - Time.now.to_i
   			render json: "Rate limit exceeded. Try again in #{n} seconds", status: 429	
   		end
   	else
   		#reset the variables after the time limit has been reached
   		session[:max_time] = nil
		session[:request_count] = nil
	end
  end
end
