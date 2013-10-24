class Admin::HomeController < ApplicationController
    # uses base controller for all of the work
    layout 'admin'
    RECORD_CLASS = Settings  
end
