# frozen_string_literal: true

namespace :dev do
  desc 'Fill database with sample data'
  task populate: :environment do
    abort('This task cannot be run in the production environment.') if Rails.env.production?
    abort('This task requires the BASE_USER_EMAIL environment variable to be set.') unless ENV.key?('BASE_USER_EMAIL')

    puts 'Delete all users except the one with the BASE_USER_EMAIL'
    User.where.not(email: ENV.fetch('BASE_USER_EMAIL', nil)).destroy_all
    Couch.where.not(user: User.find_by(email: ENV.fetch('BASE_USER_EMAIL', nil))).destroy_all

    puts 'Create 30 randomized users'
    30.times do
      new_user = FactoryBot.create(:random_user)
      puts "Created user with address: #{new_user.address}, #{new_user.zipcode} #{new_user.city}, #{new_user.country}"
    end
  end

  task test_booking: :environment do
    user = User.find(4)
    puts user.first_name

    if user.offers_couch
      couch = Couch.find_by(user:)
      couch.capacity = rand(1..5)
      couch.save!

      puts "Couch capacity: #{couch.capacity}"

      facilities = Facility.all.sample(3)
      facilities.each do |facility|
        puts "Adding facility: #{facility.name}"
        CouchFacility.create!(couch:, facility:)
      end
    end
  end

  task test_plans: :environment do
    abort('This task cannot be run in the production environment.') if Rails.env.production?
    abort('This task cannot be run in the development environment.') if Rails.env.development?
    puts 'Delete all existing plans and create a couple of fake plans'
    Subscription.destroy_all
    Plan.destroy_all

    Plan.create!(name: 'Monthly Fake Plan', price_cents: 1000, interval: 'month')
    Plan.create!(name: 'Yearly Fake Plan', price_cents: 800, interval: 'year')

    puts 'Create a fake subscription for the main user'
    user = User.find_by(email: ENV.fetch('BASE_USER_EMAIL', nil))

    plan = Plan.first
    Subscription.create!(user:, plan:, stripe_id: 'fake_subscription_id')
    puts "Created subscription for user #{user.email} with plan"
  end
end
