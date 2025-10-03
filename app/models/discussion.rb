class Discussion < ApplicationRecord
  belongs_to :user, default: -> { Current.user }
  belongs_to :category, counter_cache: true, touch: true
  validates :name, presence: true

  delegate :name, prefix: true, to: :category, allow_nil: true

  has_many :posts, dependent: :destroy

  accepts_nested_attributes_for :posts

  scope :pinned_first, -> { order(pinned: :desc, updated_at: :desc) }

  broadcasts_to :category, inserts_by: :prepend

  after_create_commit -> { broadcast_prepend_to %w[discussions discussion] }
  after_update_commit -> { broadcast_replace_to %w[discussions discussion] }
  after_destroy_commit -> { broadcast_remove_to %w[discussions discussion] }

  def to_param
    "#{id}-#{name.downcase.truncate(100, separator: " ")}".parameterize
  end
end
