module AuthM
  module Generators
    class SeedsGenerator < Rails::Generators::Base

      source_root File.expand_path('../templates', __FILE__)

      def generate_seeds
        copy_file "seeds/seeds.rb", "db/seeds.rb"
      end

    end
  end
end
