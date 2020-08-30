require 'google/apis/sheets_v4'
require 'googleauth'
require 'googleauth/stores/file_token_store'

class CheckSheet
  def initialize
    client_id = Google::Auth::ClientId.from_file './config/sheets.json'
    token_store = Google::Auth::Stores::FileTokenStore.new file: './config/token.yaml'
    authorizer = Google::Auth::UserAuthorizer.new client_id, Google::Apis::SheetsV4::AUTH_SPREADSHEETS_READONLY, token_store
    user_id = 'default'
    @credentials = authorizer.get_credentials user_id
  end

  def get_info(range)
    service = Google::Apis::SheetsV4::SheetsService.new
    service.client_options.application_name = 'Google Sheets API Ruby Quickstart'
    service.authorization = @credentials

    spreadsheet_id = '1mLx2L8nMaRZu0Sy4lyFniDewl6jDcgnxB_d0lHG-boc'
    service.get_spreadsheet_values spreadsheet_id, range
  end
end
