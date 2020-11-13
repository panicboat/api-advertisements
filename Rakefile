# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

Rake::Task['db:migrate'].enhance do
  Rake::Task[:after_migrate].invoke if Rails.env.development?
end

task :after_migrate do
  Rake::Task[:create_erd].invoke
end

task :create_erd do
  sh 'bin/rake erd title=advertisements filename=db/schema sort=false'
end
