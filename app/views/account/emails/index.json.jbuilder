# frozen_string_literal: true

json.array! @account_emails, partial: 'account_emails/account_email', as: :account_email
