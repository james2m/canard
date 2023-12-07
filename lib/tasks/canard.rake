# frozen_string_literal: true

namespace :canard do
  desc 'Upgrades deprecated ability definition syntax and moves the files from abilities to app/abilities'
  task upgrade: :environment do
    require 'rake/clean'
    source_path = 'abilities'
    destination_path = Canard::Abilities.definition_paths.first

    Dir.mkdir(destination_path) unless Dir.exist?(destination_path)

    if Dir.exist?(source_path)
      Dir[File.join(source_path, '*.rb')].each do |input_file|
        input = File.read(input_file)
        output = input.gsub(/abilities_for/, 'Canard::Abilities.for')
        output_file = File.expand_path(File.basename(input_file), destination_path)
        File.write(output_file, output)
        File.delete(input_file)
      end
      Dir.delete(source_path)
    end
  end
end
