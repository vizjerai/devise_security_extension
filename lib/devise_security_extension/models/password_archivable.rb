module Devise # :nodoc:
  module Models # :nodoc:

    # PasswordArchivable
    module PasswordArchivable

      def self.included(base) # :nodoc:
        base.extend ClassMethods

        base.class_eval do
          has_many :old_passwords, :as => :password_archivable, :class_name => "OldPassword"
          before_save :archive_password
          include InstanceMethods
        end
      end

      module InstanceMethods # :nodoc:

        private

        def archive_password
          if self.encrypted_password_changed?
            self.old_passwords.create! :encrypted_password => self.encrypted_password_change.first, :password_salt => self.password_salt_change.first
          end
        end

      end

      module ClassMethods #:nodoc:
        ::Devise::Models.config(self, :password_archiving_count)
      end
    end
  end

end
