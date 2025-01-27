# frozen_string_literal: true

require "uri"
require "open-uri"
require "zip"

module Cldr
  class << self
    def download(source = nil, target = nil, version = nil)
      version ||= 34
      source ||= "http://unicode.org/Public/cldr/#{version}/core.zip"
      target ||= File.expand_path("./vendor/cldr")

      URI.parse(source).open do |tempfile|
        FileUtils.mkdir_p(target)
        Zip.on_exists_proc = true
        Zip::File.open(tempfile.path) do |file|
          file.each do |entry|
            path = target + "/" + entry.name
            FileUtils.mkdir_p(File.dirname(path))
            file.extract(entry, path)
          end
        end
      end
    end
  end
end
