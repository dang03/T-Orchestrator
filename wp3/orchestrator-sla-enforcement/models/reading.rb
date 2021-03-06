class Reading
  attr_accessor :nsi_id, :parameter_id, :value

  def initialize(params)
    @nsi_id = params["nsi_id"].to_i
    @parameter_id = params["parameter_id"].to_i
    @value = params["value"].to_f
  end

  def valid?
    @nsi_id > 0 && @parameter_id > 0 && !@value.nil?
  end
end
