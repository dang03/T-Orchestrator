root = ::File.dirname(__FILE__)
require ::File.join( root, 'app' )

#Logger.class_eval { alias :write :'<<' }
#logger = ::Logger.new(::File.new("log/app.log","a+"))
 
#configure do
#	use Rack::CommonLogger, logger
#end

run TnovaManager.new
