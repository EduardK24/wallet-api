module Api
  module V1
    module ValidationHelper
      def validate_with(validator_class)
        result = validator_class.new.call(params)
        
        if result.failure?
          error!({
            status: 400,
            message: 'Validation failed',
            errors: result.errors.to_h
          }, 400)
        end
        
        result
      end
    end
  end
end 