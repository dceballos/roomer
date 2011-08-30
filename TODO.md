# Features
+ Scoped routes for tenants
+ Generators for Tenanted and Shared Migrators
    rails generate roomer:global:migration [migration_name] [attribute:type]
    rails generate roomer:global:migration [migration_name] [attribute:type]
+ Option to disable standard rails migration "rake db:migrate"

# Enhancements
+ Show warnings if unrun migrations exists under db/migrate/global while running rake roomer:shared:migrate

