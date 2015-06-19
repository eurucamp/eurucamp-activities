class RootMapper < Yaks::Mapper
  link :self, '/'
  link :activities, '/activities'
end
