require 'roo'

class UsersController < ApplicationController
  def new
  end

  def index
    @users = User.all
    @total_rows = params[:total_rows]
      @successful_rows = params[:successful_rows]
      @failed_rows = params[:failed_rows]
      @failure_reasons = params[:failure_reasons]
  end

  def import
    file = params[:file]
    spreadsheet = Roo::Spreadsheet.open(file.path)

    header = spreadsheet.row(1)
    @total_rows = 0
    @successful_rows = 0
    @failed_rows = 0
    @failure_reasons = []  # Initialize failure_reasons array
    @validation_errors = []

  # Specify the sheet names or indexes to import from
  sheet_names_to_import = ['UsersData1', 'UsersData2']  # Modify this based on your sheet names

  sheet_names_to_import.each do |sheet_name|
    spreadsheet.default_sheet = sheet_name  # Set the current sheet
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      user = User.new
      user.attributes = row
      if user.save
        @successful_rows += 1
      else
        @failed_rows += 1
        @validation_errors << user.errors.full_messages
        # Store reasons for failed records in the array
        @failure_reasons << "Row #{i}: #{user.errors.full_messages.join(', ')}"
      end
    end
    @total_rows += (spreadsheet.last_row - 1)
    end


    flash[:import_summary] = {
      total_rows: @total_rows,
      successful_rows: @successful_rows,
      failed_rows: @failed_rows,
      failure_reasons: @failure_reasons
    }

    redirect_to users_path(total_rows: @total_rows, successful_rows: @successful_rows, failed_rows: @failed_rows, failure_reasons: @failure_reasons, validation_errors: @validation_errors), notice: "Users imported successfully."

  end

end
