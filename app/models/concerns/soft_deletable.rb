module SoftDeletable
  extend ActiveSupport::Concern

  def self.included(base = nil, &block)
    @included_in ||= []
    @included_in << base.name if base
    super
  end

  def self.included_in
    @included_in
  end

  included do
    scope :deleted, -> { where.not(deleted_at: nil) }
    scope :active, -> { where(deleted_at: nil) }
  end

  def destroy(mode = :soft)
    if mode == :hard
      super()
    else
      update(deleted_at: Time.zone.now)
    end
  end

  def restore
    update(deleted_at: nil)
  end

  def deleted?
    deleted_at?
  end
end
