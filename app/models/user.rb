class User < ApplicationRecord


    validates :username, :session_token, presence: true
    validates :username, uniqueness: true
    validates :password, lenght: {minimum: 6, allow_nil: true}


    #figvaper

    has_many :subs,
        primary_key: :id,
        foreign_key: :moderator_id,
        class_name: :Sub

    attr_reader :password

    after_initialize :ensure_session_token

    def self.find_by_cridentials(username, password)
        user = User.find_by(username: username)

        if user && user.is_password?(password)
            user
        else
            nil
        end

    end

    def is_password?(password)
        BCrypt::Password.new(self.password_digest).is_password?(password)
    end

    def password=(password)
        @password = password
        self.password_digest = BCrypt::Password.create(password)
    end

    def ensure_session_token
        self.session_token ||= SecureRandom.urlsafe_base64
    end

    def reset_session_token!
        self.session_token = SecureRandom.urlsafe_base64
        self.save!
        self.session_token
    end


end