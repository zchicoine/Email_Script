require 'KEE'
require 'Data_Controller'

###
# 1) Download ship emails from the server
###

def obtain_emails
    connect_config = {auth_type: :basic,email_address:'mah.sync24@gmail.com',password:'jaw35Maw'}
    KEE.config_connection(connect_config)
    KEE.new.unread_emails
end

###
# 2) Extract ship information
###
def extract_info(data)
    # for now
    info = []
    data.each do |d|
        info.push({status:'fail',body:d[:body],subject:d[:subject],from:d[:reply_to=],email_address:d[:email_address], date:d[:date].to_s})
    end
    info
end

###
# 3) Save successful to website database, save unsuccessful emails to recovery database
###
def save_emails(emails)
    data_controller = DataController.new
    emails.each do |email|
       if email[:status] == 'fail'
           data_controller.unsuccessful_email(email)
       elsif email[:status] == 'succ'
           # data_controller.successful_email(email)
       end
    end
end

###
# 4) update the user database. number of ships, personal, order and not ships emails
###
    # TODO: is not yet implement

###########################
# run the script
save_emails(extract_info(obtain_emails))