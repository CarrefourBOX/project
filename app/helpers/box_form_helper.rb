module BoxFormHelper
  def box_input_value(value)
    if value.nil?
      nil
    elsif value.to_s.size <= 2
      value.to_s
    else
      value.to_s.insert(-3, ',')
    end
  end
end
