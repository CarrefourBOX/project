module ShippingCodeGenerator
  extend ActiveSupport::Concern

  OBJECT_LABELS = %w[DE DF DG DA DJ DM DN DK DU DY OA OB OC EC PB PD PI PJ SQ SR].freeze

  def generate_code
    code = OBJECT_LABELS.sample
    9.times do
      code += rand(0..9).to_s
    end
    code += 'BR'
  end
end
