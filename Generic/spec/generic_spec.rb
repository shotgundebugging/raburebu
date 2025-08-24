# frozen_string_literal: true

require 'rails'
require 'active_support'
require 'active_support/core_ext/object/blank'

describe 'very generic' do
  it 'checks present? on non-blank string' do
    expect('foo'.present?).to be true
  end

  it 'checks present? on blank string' do
    expect(''.present?).to be false
  end
end
