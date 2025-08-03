class Discussion < ApplicationRecord
  belongs_to :user, default: -> { Current.user }
  validates :name, presence: true

  has_many :posts, dependent: :destroy

  accepts_nested_attributes_for :posts

  after_create_commit -> { broadcast_prepend_to %w[discussions discussion] }
  after_update_commit -> { broadcast_replace_to %w[discussions discussion] }
  after_destroy_commit -> { broadcast_remove_to %w[discussions discussion] }
  def to_param
    "#{id}-#{name.downcase.truncate(100, separator: " ")}".parameterize
  end
end
