# frozen_string_literal: true

require 'json'
require 'pp'

schedule_json = File.read(File.expand_path('../../../2018.isleofruby.org/data/schedule.json', __FILE__))
program_json  = File.read(File.expand_path('../../../2018.isleofruby.org/data/program.json', __FILE__))
speakers_yaml = File.read(File.expand_path('../../../2018.isleofruby.org/data/speakers.yml', __FILE__))

schedule_data = JSON.parse(schedule_json)
program_data  = JSON.parse(program_json)
speakers_data = YAML.safe_load(speakers_yaml)

module ImportHelpers
  def speaker_image_path(twitter)
    "speakers/#{clean_twitter_handle(twitter).gsub(/^_/, '')}@2x.jpg"
  end

  def clean_twitter_handle(twitter)
    twitter.tr('@', '')
  end
end
include ImportHelpers

Time.use_zone('Europe/London') do
  CONFERENCE_EVENT      = Event.new
  CONFERENCE_START_DATE = Time.zone.local(2018, 4, 13)

  pp speakers_data

  schedule_data.each do |item|
    item_date   = CONFERENCE_START_DATE.advance(days: item['conference_day'] - 1)
    start_time  = Time.zone.parse(item['start_time'], item_date)
    end_time    = Time.zone.parse(item['end_time'], item_date)

    session     = if item['program_session_id'].present?
                    program_data.detect do |program_session|
                      program_session['id'] == item['program_session_id']
                    end
                  else
                    {}
                  end
    speakers    = if session && session['speakers']
                    session['speakers'].map do |session_speaker|
                      speakers_data['speakers'].detect do |speaker|
                        speaker['name'].casecmp(session_speaker['name'].downcase).zero?
                      end
                    end
                  else
                    []
                  end
    tags        = session ? ['talk'] + (session['tags'] || []) : []

    title       = item['title']
    title      += " - #{item['presenter']}" if item['presenter'].present?

    speaker     = speakers.first || {}
    image_url   = "https://isleofruby.org/images/#{speaker_image_path(speaker['twitter'])}" if speaker['twitter'].present?
    session_url = "https://isleofruby.org/speakers/#{speaker['name'].parameterize}" if speaker['name'].present?

    description = ''
    description += "## Talk by [#{speaker['name']}](#{session_url})\n\n" if speaker['name'].present?
    description += item['description']
    if speaker['name'].present?
      first_name = speaker['name'].split(' ').first
      description += "\n\n---"
      description += "\n- [Read more about #{first_name}](#{session_url})"
      description += "\n- [Follow #{first_name} on Twitter](https://twitter.com/#{speaker['twitter']})"
    end

    location = item['room'] == 'Main room' ? 'Seminar room' : item['room']

    activity = Activity.new(
      name:                   title,
      description:            description,
      location:               location,
      start_time:             start_time,
      end_time:               end_time,
      event:                  CONFERENCE_EVENT,
      official:               true,
      requires_event_ticket:  true,
      limit_of_participants:  120,
      image_url:              image_url,
      # creator_id:,
      additional_information: { imported: item.as_json, speakers: speakers },
      tags:                   tags
    )

    p activity
    # p activity.valid?
    # p activity.errors
    activity.save!
  end
end
