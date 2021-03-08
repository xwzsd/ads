class CreateService
  def initialize(params)
    @params = params
    @errors = []
    @ad = Ad.new(title: params[:title], description: params[:description], city: params[:city], user_id: params[:user_id])
  end

  attr_reader :params, :errors, :ad

  def call
    ad.valid? && ad.save!
    fail!(ad.errors)
    self
  end

  def success?
    !failure?
  end

  def failure?
    @errors.any?
  end

  private

  def fail!(messages)
    @errors += Array(messages)
  end
end
