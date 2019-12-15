if c = ::ActiveRecord::Base.connection
  c.execute 'PRAGMA journal_mode = WAL'
end
