class MessagesController < ApplicationController
	
	before_filter :signed_in_user
	layout false, except: :new 
	

  def create
		PrivatePub.publish_to "/negotiation/#{current_user.negotiation.id}/new", :content => params[:content], :user_id => current_user.id unless params[:content].empty?
		@negotiation = current_user.negotiation
		@negotiation.messages.create(
			negotiation_id: @negotiation.id,
			content: params[:content],
			sender_id: current_user.id,
			receiver_id: @negotiation.receiver(current_user).id
		)
		render inline: 'Done'
  end
	
	private
		
		def signed_in_user
			unless signed_in?
				store_location
				redirect_to log_in_url
				flash[:error] = 'Please Sign In'
			end
		end
		
		def admin_user
			unless current_user.admin
				redirect_to root_url
				flash[:error] = 'You do not have permission to access that page.'
			end
		end
		
	
end
