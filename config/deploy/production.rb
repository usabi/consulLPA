set :branch, ENV["branch"] || :master

server deploysecret(:server), user: deploysecret(:user), roles: %w(web app db importer cron background), port: deploysecret(:ssh_port)
#server deploysecret(:server2), user: deploysecret(:user), roles: %w(web app db importer cron background)
#server deploysecret(:server3), user: deploysecret(:user), roles: %w(web app db importer)
#server deploysecret(:server4), user: deploysecret(:user), roles: %w(web app db importer)
