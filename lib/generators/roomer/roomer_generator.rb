module Roomer
  module Generators
    class RoomerGenerator < Rails::Generators::NamedBase
      namespace "roomer"
      hook_for :orm
    end
  end
end
