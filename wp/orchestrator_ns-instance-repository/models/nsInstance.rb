class NsInstance < ActiveRecord::Base
  id = nil
  after_save {id = self.id}
end
