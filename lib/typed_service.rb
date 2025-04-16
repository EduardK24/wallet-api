class TypedService < Dry::Struct
  def self.call(...)
    new(...).call
  end
end
