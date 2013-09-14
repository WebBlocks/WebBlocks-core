require 'pathname'

Dir.glob(Pathname.new(__FILE__).parent + "Core/**/*.rb").each { |r| require r }
