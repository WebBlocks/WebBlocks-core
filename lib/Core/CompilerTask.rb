require 'pathname'

Dir.glob(Pathname.new(__FILE__).parent + "CompilerTask/*.rb").each { |r| require r }