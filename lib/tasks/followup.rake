namespace :followup do
  
	task :chat_followup_mails => :environment do
		Post.chat_followup
	end
end