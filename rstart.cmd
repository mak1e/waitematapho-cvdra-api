set RAILS_ENV=production
cmd/c rake db:migrate
net stop rails_waitematapho
net start rails_waitematapho
pause
