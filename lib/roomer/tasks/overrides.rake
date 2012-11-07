namespace :db do
  Rake::Task["db:abort_if_pending_migrations"].clear
  task :abort_if_pending_migrations => "roomer:shared:abort_if_pending_migrations"

  Rake::Task["db:migrate"].clear
  task :migrate => "roomer:migrate"

  Rake::Task["db:schema:load"].clear
  task "schema:load" => ["roomer:shared:abort_if_pending_migrations", "roomer:shared:schema:load"]
end
