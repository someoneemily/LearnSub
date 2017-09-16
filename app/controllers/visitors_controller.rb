class VisitorsController < ApplicationController
	def index
	end

	def show
	end 
	
	def getdata
		puts params
		redirect_to visitor_path
	end
end
