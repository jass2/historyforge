require 'rails_helper'

RSpec.describe '1940 US Census' do
  scenario 'record life cycle' do
    user = create(:census_taker)
    locality = create(:locality)

    sign_in user

    visit new_census1940_record_path
    expect(page).to have_content('New 1940 Census Record')

    fill_in 'Sheet', with: '1'
    select 'A', from: 'Side'
    fill_in 'Line', with: '1'
    fill_in 'County', with: 'Tompkins', match: :first
    fill_in 'City', with: 'Ithaca'
    fill_in 'Ward', with: '1'
    fill_in 'Enum dist', with: '1'
    fill_in 'House No.', with: '405'
    select 'N', from: 'Prefix'
    fill_in 'Street Name', with: 'Tioga'
    select 'St', from: 'Suffix'
    check 'Add building with address'
    select locality.name, from: 'Locality'
    fill_in 'Household No.', with: '1'

    fill_in 'Last name', with: 'Squarepants'
    fill_in 'First name', with: 'Sponge'
    fill_in 'Middle name', with: 'Bob'
    fill_in 'Title', with: 'Dr'
    fill_in 'Suffix', with: 'III'

    fill_in 'Relation to head', with: 'Head'

    choose 'M - Male', name: 'census_record[sex]'
    choose 'W - White', name: 'census_record[race]'
    fill_in 'Age at Last Birthday', with: '28'
    fill_in 'Age (months)', with: '5'
    choose 'M - Married', name: 'census_record[marital_status]'

    check 'Attended school or college?'
    choose 'C 5 Or Over', name: 'census_record[grade_completed]'

    fill_in 'Place of Birth', with: 'At Sea'
    check 'This person is foreign born.'
    choose 'AmCit - American Citizen', name: 'census_record[naturalized_alien]'

    fill_in 'Town', with: 'Ithaca', name: 'census_record[residence_1935_town]'
    fill_in 'County', with: 'Tompkins', name: 'census_record[residence_1935_county]'
    fill_in 'State', with: 'New York', name: 'census_record[residence_1935_state]'
    check 'On a Farm?'

    check 'Private/Non-emergency Government Work'
    check 'Public Emergency Work'
    check 'Seeking Work?'
    check 'Employed but Temporarily Absent'
    fill_in 'Duration of Unemployment in Weeks', with: '20'

    fill_in 'Occupation', with: 'Turnkey', match: :first
    fill_in 'Industry', with: 'Hotel'
    choose 'PW - Private wage or salary worker', name: 'census_record[worker_class]'
    fill_in 'Occupation code', with: 'VX70'
    fill_in 'Industry code', with: 'VX70'
    fill_in 'Worker class code', with: '3'
    fill_in 'Weeks Worked in 1939', with: '32'

    fill_in 'Income (Wages or Salary)', with: '100'
    check 'Other Income Source'

    fill_in 'Place of Birth - Father', with: 'Ireland'
    fill_in 'Place of Birth - Mother', with: 'Germany'
    fill_in 'Mother Tongue', with: 'English'

    fill_in 'Notes', with: 'Sponge Bob is a fictional cartoon character.'

    select 'In this family', from: 'After saving, add another person:'
    click_on 'Save'

    record = Census1940Record.first
    expect(record.last_name).to eq('Squarepants')
    expect(record.reviewed?).to be_falsey
    expect(record.created_by).to eq user

    building = Building.first
    expect(building).to_not be_nil

    # Make sure it saves and moves on to the next form with the correct fields prefilled
    expect(page).to have_content('New 1940 Census Record')
    expect(find_field('Sheet').value).to eq '1'
    expect(find_field('Side').value).to eq 'A'
    expect(find_field('County', match: :first).value).to eq 'Tompkins'
    expect(find_field('City').value).to eq 'Ithaca'
    expect(find_field('Ward').value).to eq '1'
    expect(find_field('Enum dist').value).to eq '1'
    expect(find_field('House No.').value).to eq '405'
    expect(find_field('Prefix').value).to eq 'N'
    expect(find_field('Street Name').value).to eq 'Tioga'
    expect(find_field('Suffix').value).to eq 'St'
    expect(find_field('Household No.').value).to eq '1'
    expect(find_field('Building').value).to eq building.id.to_s
    expect(find_field('Last name').value).to eq 'Squarepants'
    expect(find_field('Locality').value).to eq locality.id.to_s

    click_link 'View All'
    expect(page).to have_content '1940 U.S. Census'
    expect(find('.ag-cell', match: :first)).to have_content('Squarepants')
    expect(find('span.badge.badge-danger')).to have_content('NEW')
    expect(page).to have_content 'Found 1 record'

    click_on 'View'
    expect(page).to have_content 'Squarepants, Sponge Bob'
    # This would be a good place to verify that the page has all the things

    click_on 'Edit'
    expect(page).to have_content 'Census Scope'
    expect(find_field('Last name').value).to eq('Squarepants')
    fill_in 'Last name', with: 'Roundpants'
    click_on 'Save', match: :first
    expect(page).to have_content 'Roundpants'

    # We are only a census taker. We can't review stuff.
    # expect(page).to have_no_content 'Mark as Reviewed'
    # expect(page).to have_no_content 'Delete'

    # Upgrade the user to Reviewer
    user.roles << Role.find_by(name: 'reviewer')
    visit census1940_record_path(record)

    # Now review the record
    expect(page).to have_css('.dropdown-item', text: 'Mark as Reviewed', visible: :hidden)
    click_on 'Actions'
    click_on 'Mark as Reviewed'
    expect(page).to have_content "Reviewed by #{user.login} on"
  end
end